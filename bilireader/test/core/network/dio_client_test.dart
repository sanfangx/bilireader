import 'dart:typed_data';

import 'package:bilireader/core/auth/auth_session_manager.dart';
import 'package:bilireader/core/network/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_stores.dart';

/// 攔截住送出的請求並回傳固定 body，供攔截器鏈整合測試。
class _CaptureAdapter implements HttpClientAdapter {
  _CaptureAdapter({this.body = '{"code":200,"message":"ok","data":{}}'});

  final String body;
  RequestOptions? captured;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    captured = options;
    return ResponseBody.fromString(
      body,
      200,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Future<AuthSessionManager> _session({String? token}) async {
  final FakeTokenStore ts = FakeTokenStore()..token = token;
  final AuthSessionManager m = AuthSessionManager(
    tokenStore: ts,
    sessionStore: FakeSessionStore(),
  );
  await m.load();
  return m;
}

void main() {
  test('攔截器鏈：版本 header + Authorization + BNUP2 簽章（受保護路徑）', () async {
    final AuthSessionManager session = await _session(token: 'mytoken');
    final Dio dio = buildDioClient(
      session: session,
      onForceUpdate: () {},
      onAuthFailure: (_) {},
    );
    final _CaptureAdapter adapter = _CaptureAdapter();
    dio.httpClientAdapter = adapter;

    await dio.post<dynamic>('client/bilinovel/circle/publish');

    final Map<String, dynamic> h = adapter.captured!.headers;
    expect(h['App-Version-Code'], '39');
    expect(h['App-Version-Name'], '1.74.1');
    expect(h.containsKey('Accept-Language'), isFalse);
    expect(h['Authorization'], 'mytoken');
    expect(h.containsKey('X-App-Upload-Nonce'), isTrue);
    expect((h['X-App-Upload-Signature'] as String).length, 64);
  });

  test('非受保護路徑不加 BNUP2 簽章', () async {
    final AuthSessionManager session = await _session(token: 'mytoken');
    final Dio dio = buildDioClient(
      session: session,
      onForceUpdate: () {},
      onAuthFailure: (_) {},
    );
    final _CaptureAdapter adapter = _CaptureAdapter();
    dio.httpClientAdapter = adapter;

    await dio.post<dynamic>('client/bilinovel/user/login');

    expect(
      adapter.captured!.headers.containsKey('X-App-Upload-Signature'),
      isFalse,
    );
  });

  test('未登入時不加 Authorization', () async {
    final AuthSessionManager session = await _session();
    final Dio dio = buildDioClient(
      session: session,
      onForceUpdate: () {},
      onAuthFailure: (_) {},
    );
    final _CaptureAdapter adapter = _CaptureAdapter();
    dio.httpClientAdapter = adapter;

    await dio.post<dynamic>('client/bilinovel/user/login');

    expect(adapter.captured!.headers.containsKey('Authorization'), isFalse);
  });

  test('回應業務碼 401 觸發 onAuthFailure（集中處理）', () async {
    final AuthSessionManager session = await _session(token: 'mytoken');
    int? failedCode;
    final Dio dio = buildDioClient(
      session: session,
      onForceUpdate: () {},
      onAuthFailure: (int code) => failedCode = code,
    );
    dio.httpClientAdapter = _CaptureAdapter(
      body: '{"code":401,"message":"失效"}',
    );

    await dio.post<dynamic>('client/bilinovel/user/getuserInfo');

    expect(failedCode, 401);
  });

  test('回應業務碼 501 觸發 onForceUpdate', () async {
    final AuthSessionManager session = await _session(token: 'mytoken');
    bool forced = false;
    final Dio dio = buildDioClient(
      session: session,
      onForceUpdate: () => forced = true,
      onAuthFailure: (_) {},
    );
    dio.httpClientAdapter = _CaptureAdapter(
      body: '{"code":501,"message":"請更新"}',
    );

    await dio.post<dynamic>('client/bilinovel/system/version');

    expect(forced, isTrue);
  });
}
