import 'package:bilireader/core/auth/auth_session_manager.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_stores.dart';

void main() {
  test('clear 以舊 uid 呼叫 clearOwnerCache，並清 token/uid', () async {
    final FakeTokenStore ts = FakeTokenStore()..token = 't';
    final FakeSessionStore ss = FakeSessionStore()
      ..uid = 42
      ..groupId = 5;
    int? clearedUid;
    final AuthSessionManager m = AuthSessionManager(
      tokenStore: ts,
      sessionStore: ss,
      clearOwnerCache: (int uid) async => clearedUid = uid,
    );
    await m.load();

    await m.clear();

    expect(clearedUid, 42);
    expect(ts.token, isNull);
    expect(ss.uid, isNull);
  });

  test('clear 於清 token 後呼叫 onCleared（登出中斷 WS，避免舊 token 連線殘留）', () async {
    final FakeTokenStore ts = FakeTokenStore()..token = 't';
    final FakeSessionStore ss = FakeSessionStore()..uid = 7;
    bool cleared = false;
    Object? tokenAtCallback = 'sentinel';
    final AuthSessionManager m = AuthSessionManager(
      tokenStore: ts,
      sessionStore: ss,
      onCleared: () {
        cleared = true;
        tokenAtCallback = ts.token; // token store 應已刪（token 先清、再 onCleared）
      },
    );
    await m.load();

    await m.clear();

    expect(cleared, isTrue);
    expect(tokenAtCallback, isNull); // onCleared 在 token 清空後才觸發
  });

  test('未提供 clearOwnerCache 時 clear 仍正常', () async {
    final FakeTokenStore ts = FakeTokenStore()..token = 't';
    final FakeSessionStore ss = FakeSessionStore()..uid = 1;
    final AuthSessionManager m = AuthSessionManager(
      tokenStore: ts,
      sessionStore: ss,
    );
    await m.load();

    await m.clear();

    expect(ts.token, isNull);
  });
}
