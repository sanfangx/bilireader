import 'package:bilireader/core/auth/auth_session_manager.dart';
import 'package:bilireader/core/constants/api_constants.dart';
import 'package:bilireader/core/network/interceptors/authorization_interceptor.dart';
import 'package:bilireader/core/storage/token_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_stores.dart';

/// 記錄 read 次數的 TokenStore，用來驗證 ensureLoaded 只載入一次。
class _CountingTokenStore implements TokenStore {
  _CountingTokenStore(this.token);
  String? token;
  int reads = 0;

  @override
  Future<String?> read() async {
    reads++;
    return token;
  }

  @override
  Future<void> write(String value) async => token = value;

  @override
  Future<void> delete() async => token = null;
}

void main() {
  group('AuthSessionManager', () {
    test('persist + load 保存並讀回 token/uid/groupid', () async {
      final FakeTokenStore ts = FakeTokenStore();
      final FakeSessionStore ss = FakeSessionStore();
      final AuthSessionManager m = AuthSessionManager(
        tokenStore: ts,
        sessionStore: ss,
      );

      await m.persist(token: 'abc', uid: 42, groupId: 5);
      expect(m.currentToken, 'abc');
      expect(m.isLoggedIn, isTrue);

      final AuthSessionData data = await m.load();
      expect(data.token, 'abc');
      expect(data.uid, 42);
      expect(data.groupId, 5);
      expect(data.isLoggedIn, isTrue);
    });

    test('clear 清除 token/uid/groupid（logout 本地清除）', () async {
      final FakeTokenStore ts = FakeTokenStore()..token = 't';
      final FakeSessionStore ss = FakeSessionStore()
        ..uid = 1
        ..groupId = 5;
      final AuthSessionManager m = AuthSessionManager(
        tokenStore: ts,
        sessionStore: ss,
      );
      await m.load();

      await m.clear();

      expect(ts.token, isNull);
      expect(ss.uid, isNull);
      expect(ss.groupId, isNull);
      expect(m.currentToken, isNull);
      expect(m.isLoggedIn, isFalse);
    });

    test('clearWithDebounce：5 秒內只清一次（401/666 集中處理）', () async {
      final FakeTokenStore ts = FakeTokenStore()..token = 't';
      final FakeSessionStore ss = FakeSessionStore()..uid = 1;
      final AuthSessionManager m = AuthSessionManager(
        tokenStore: ts,
        sessionStore: ss,
      );
      await m.load();

      // 第一次：距上次 (0) 已 >= 5s → 清除。
      expect(await m.clearWithDebounce(nowMs: 10000), isTrue);
      expect(ts.token, isNull);

      // 模擬重新登入後，2 秒內再次 401 → debounce，不清。
      ts.token = 't2';
      expect(await m.clearWithDebounce(nowMs: 12000), isFalse);
      expect(ts.token, 't2');

      // 6 秒後 → 再次清除。
      expect(await m.clearWithDebounce(nowMs: 16000), isTrue);
      expect(ts.token, isNull);
    });

    test('ensureLoaded：由儲存回填快取，且只載入一次（memoized）', () async {
      final _CountingTokenStore ts = _CountingTokenStore('tok');
      final AuthSessionManager m = AuthSessionManager(
        tokenStore: ts,
        sessionStore: FakeSessionStore(),
      );

      expect(m.currentToken, isNull); // 尚未載入
      await Future.wait(<Future<void>>[m.ensureLoaded(), m.ensureLoaded()]);
      await m.ensureLoaded();

      expect(m.currentToken, 'tok');
      expect(ts.reads, 1); // 併發 + 重複呼叫只讀一次
    });
  });

  group('AuthorizationInterceptor 冷啟動競態', () {
    test('未顯式 load 時，onRequest 仍會 await ensureLoaded 掛上 token', () async {
      final FakeTokenStore ts = FakeTokenStore()..token = 'racetok';
      final AuthSessionManager m = AuthSessionManager(
        tokenStore: ts,
        sessionStore: FakeSessionStore(),
      );
      // 模擬冷啟動：尚未呼叫 load()，同步 currentToken 仍為 null。
      expect(m.currentToken, isNull);

      final AuthorizationInterceptor interceptor = AuthorizationInterceptor(m);
      final RequestOptions options = RequestOptions(path: '/x');
      await interceptor.onRequest(options, RequestInterceptorHandler());

      // 修正前：header 缺失 → 自招 401。修正後：已 await 載入完成再掛 token。
      expect(options.headers[ApiConstants.headerAuthorization], 'racetok');
    });

    test('未登入（無 token）時不掛 Authorization header', () async {
      final AuthSessionManager m = AuthSessionManager(
        tokenStore: FakeTokenStore(),
        sessionStore: FakeSessionStore(),
      );
      final AuthorizationInterceptor interceptor = AuthorizationInterceptor(m);
      final RequestOptions options = RequestOptions(path: '/x');
      await interceptor.onRequest(options, RequestInterceptorHandler());

      expect(
        options.headers.containsKey(ApiConstants.headerAuthorization),
        isFalse,
      );
    });
  });
}
