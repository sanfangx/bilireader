import 'dart:typed_data';

import 'package:bilireader_app/core/network/cf_signals.dart';
import 'package:bilireader_app/core/network/retry_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// 依序回吐預設 responses 的假 adapter；記錄被呼叫次數。
class _ScriptedAdapter implements HttpClientAdapter {
  _ScriptedAdapter(this.script);

  /// 每筆：(statusCode, body, headers)。用完停在最後一筆。
  final List<(int, String, Map<String, List<String>>)> script;
  int calls = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final int i = calls < script.length ? calls : script.length - 1;
    calls++;
    final (int code, String body, Map<String, List<String>> headers) =
        script[i];
    return ResponseBody.fromString(body, code, headers: headers);
  }

  @override
  void close({bool force = false}) {}
}

Dio _dioWith(_ScriptedAdapter adapter) {
  final Dio dio = Dio(BaseOptions(
    baseUrl: 'https://example.test',
    validateStatus: (_) => true, // 對齊正式 client：429/503 是「成功」Response。
  ));
  dio.httpClientAdapter = adapter;
  dio.interceptors.add(
    // sleep 短路成即時，測試不真的等待退避。
    RetryInterceptor(dio, sleep: (_) async {}),
  );
  return dio;
}

Response _resp(int code, {String body = '', Map<String, List<String>>? headers}) {
  return Response(
    requestOptions: RequestOptions(path: '/'),
    statusCode: code,
    data: body,
    headers: Headers.fromMap(headers ?? const {}),
  );
}

void main() {
  group('CfSignals.looksLikeChallenge', () {
    test('落回 login.php → 挑戰', () {
      final r = Response(
        requestOptions: RequestOptions(path: '/user.php'),
        statusCode: 200,
        data: '',
      );
      // realUri 取自 requestOptions.uri；改用最終導向的 path 模擬。
      final r2 = Response(
        requestOptions: RequestOptions(
            path: '/login.php', baseUrl: 'https://tw.linovelib.com'),
        statusCode: 200,
        data: '',
      );
      expect(CfSignals.looksLikeChallenge(r), isFalse);
      expect(CfSignals.looksLikeChallenge(r2), isTrue);
    });

    test('cf-mitigated 標頭 → 挑戰', () {
      expect(
        CfSignals.looksLikeChallenge(
            _resp(403, headers: {'cf-mitigated': ['challenge']})),
        isTrue,
      );
    });

    test('_cf_chl_opt / Just a moment / Cloudflare 503 → 挑戰', () {
      expect(CfSignals.looksLikeChallenge(_resp(403, body: 'x _cf_chl_opt y')),
          isTrue);
      expect(
          CfSignals.looksLikeChallenge(_resp(503, body: '<title>Just a moment')),
          isTrue);
      expect(CfSignals.looksLikeChallenge(_resp(503, body: 'Cloudflare Ray ID')),
          isTrue);
    });

    test('純 429 / 一般 200 / 一般 403 → 非挑戰', () {
      expect(CfSignals.looksLikeChallenge(_resp(429, body: 'Too Many')), isFalse);
      expect(CfSignals.looksLikeChallenge(_resp(200, body: '<html>ok')), isFalse);
      expect(CfSignals.looksLikeChallenge(_resp(403, body: 'forbidden')),
          isFalse);
    });
  });

  group('CfSignals.isTransientStatus / isRetriableResponse', () {
    test('429/502/503/504 暫時；200/403/404 非暫時', () {
      for (final c in [429, 502, 503, 504]) {
        expect(CfSignals.isTransientStatus(c), isTrue, reason: '$c');
      }
      for (final c in [200, 301, 403, 404]) {
        expect(CfSignals.isTransientStatus(c), isFalse, reason: '$c');
      }
    });

    test('429 非挑戰 → 可重試；503+Cloudflare（挑戰）→ 不可重試；200 → 不可重試', () {
      expect(CfSignals.isRetriableResponse(_resp(429)), isTrue);
      expect(
          CfSignals.isRetriableResponse(_resp(503, body: 'Cloudflare')), isFalse);
      expect(CfSignals.isRetriableResponse(_resp(200)), isFalse);
    });
  });

  group('RetryInterceptor.computeBackoffMs', () {
    test('指數：attempt 0/1/2 → 500/1000/2000（jitter 0）', () {
      expect(RetryInterceptor.computeBackoffMs(0), 500);
      expect(RetryInterceptor.computeBackoffMs(1), 1000);
      expect(RetryInterceptor.computeBackoffMs(2), 2000);
    });

    test('夾到 maxMs', () {
      expect(RetryInterceptor.computeBackoffMs(10, maxMs: 8000), 8000);
    });

    test('Retry-After 優先且夾到 30 秒', () {
      expect(RetryInterceptor.computeBackoffMs(0, retryAfterSecs: 3), 3000);
      expect(RetryInterceptor.computeBackoffMs(5, retryAfterSecs: 999), 30000);
    });

    test('jitter 疊加於指數項', () {
      expect(RetryInterceptor.computeBackoffMs(0, jitterMs: 250), 750);
    });
  });

  group('RetryInterceptor 端到端（假 adapter）', () {
    test('429,429,200 → 透明重試至 200，共打 3 次', () async {
      final adapter = _ScriptedAdapter([
        (429, 'rate', {}),
        (429, 'rate', {}),
        (200, '<html>content', {}),
      ]);
      final res = await _dioWith(adapter).get<String>('/top/weekvisit/1.html');
      expect(res.statusCode, 200);
      expect(res.data, contains('content'));
      expect(adapter.calls, 3);
    });

    test('全 429 → 重試上限後放行原碼，共打 1+maxRetries=4 次', () async {
      final adapter = _ScriptedAdapter([(429, 'rate', {})]);
      final res = await _dioWith(adapter).get<String>('/x');
      expect(res.statusCode, 429);
      expect(adapter.calls, 4);
    });

    test('真正 CF 挑戰（503+Cloudflare）不重試，只打 1 次', () async {
      final adapter = _ScriptedAdapter([
        (503, '<title>Just a moment</title> challenge-platform', {}),
        (200, 'should-not-reach', {}),
      ]);
      final res = await _dioWith(adapter).get<String>('/x');
      expect(res.statusCode, 503);
      expect(adapter.calls, 1);
    });

    test('404 客戶端錯誤不重試，只打 1 次', () async {
      final adapter = _ScriptedAdapter([(404, 'not found', {})]);
      final res = await _dioWith(adapter).get<String>('/missing');
      expect(res.statusCode, 404);
      expect(adapter.calls, 1);
    });
  });
}
