import 'dart:typed_data';

import 'package:bilireader/features/system/data/system_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// 回傳固定 body（HTTP 200 外殼，body.code 為業務碼）供簽到偵測測試。
class _CannedAdapter implements HttpClientAdapter {
  _CannedAdapter(this.body);
  final String body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString(
    body,
    200,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>[Headers.jsonContentType],
    },
  );

  @override
  void close({bool force = false}) {}
}

SystemRemoteDataSource _remote(String body) {
  final Dio dio = Dio(BaseOptions(baseUrl: 'https://x/'))
    ..httpClientAdapter = _CannedAdapter(body);
  return SystemRemoteDataSource(dio);
}

void main() {
  group('signIn 已簽偵測（放寬，修正重裝後簽不了）', () {
    test('code 200 + 積分 → 新簽（alreadySigned=false，不誤判）', () async {
      final r = await _remote(
        '{"code":200,"message":"签到成功","data":{"points":5,"totalScore":10}}',
      ).signIn();
      expect(r.alreadySigned, isFalse);
      expect(r.data.points, 5);
    });

    test('code 201 → 已簽', () async {
      final r = await _remote('{"code":201,"message":"","data":{}}').signIn();
      expect(r.alreadySigned, isTrue);
    });

    test('非 200 + 訊息「今日已经签到过了」→ 已簽（放寬涵蓋）', () async {
      // 舊版嚴格比對「已签到」子字串 → 「已经签到」不含該子字串 → 誤判失敗、卡「簽到中」。
      final r = await _remote(
        '{"code":500,"message":"今日已经签到过了","data":null}',
      ).signIn();
      expect(r.alreadySigned, isTrue);
    });

    test('非 200 + 訊息含「簽到」（繁）→ 已簽', () async {
      final r = await _remote(
        '{"code":400,"message":"重複簽到","data":null}',
      ).signIn();
      expect(r.alreadySigned, isTrue);
    });

    test('非 200 + 無關錯誤訊息 → 拋（非已簽，維持錯誤語意）', () async {
      expect(
        () => _remote('{"code":500,"message":"伺服器忙碌","data":null}').signIn(),
        throwsA(anything),
      );
    });
  });
}
