import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth_session_manager.dart';
import '../storage/database/database_providers.dart';
import '../storage/session_store.dart';
import '../storage/token_store.dart';
import '../ws/ws_providers.dart';

part 'infra_providers.g.dart';

/// 於 `main()` 以 `overrideWithValue` 注入（SharedPreferences 為非同步初始化）。
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) =>
    throw UnimplementedError('sharedPreferencesProvider 必須於 main() override');

@Riverpod(keepAlive: true)
FlutterSecureStorage flutterSecureStorage(Ref ref) =>
    const FlutterSecureStorage();

@Riverpod(keepAlive: true)
TokenStore tokenStore(Ref ref) =>
    SecureTokenStore(ref.watch(flutterSecureStorageProvider));

@Riverpod(keepAlive: true)
SessionStore sessionStore(Ref ref) =>
    PrefsSessionStore(ref.watch(sharedPreferencesProvider));

@Riverpod(keepAlive: true)
AuthSessionManager authSessionManager(Ref ref) => AuthSessionManager(
  tokenStore: ref.watch(tokenStoreProvider),
  sessionStore: ref.watch(sessionStoreProvider),
  // lazy：僅在 clear()（登出/401/666）時才讀 DAO 清該 uid 的所有 owner-scoped 本機快取——
  // 私訊 + 書籤 + 閱讀進度。避免登出後（或換帳號）殘留上一帳號的本機資料（使用者要求）。
  clearOwnerCache: (int uid) async {
    await ref.read(privateMessageDaoProvider).clearOwner(uid);
    await ref.read(bookmarkDaoProvider).clearOwner(uid);
    await ref.read(readingProgressDaoProvider).clearOwner(uid);
  },
  // 清除後中斷即時通訊 WS：invalidate 令已建立之 socket dispose()（→ disconnect 關閉以舊
  // token 認證的連線）；未曾建立則為 no-op。下次觀察（新帳號開通知/私訊頁）會以新 token 重連
  // （doc 08「token 變空→closeSocket」、§7.7）。
  onCleared: () {
    ref.invalidate(noticeSocketProvider);
    ref.invalidate(chatSocketProvider);
  },
);

/// 強制更新旗標（規範 §7.0 501）。UI（Phase 8）觀察此狀態顯示不可取消更新對話框。
@Riverpod(keepAlive: true)
class ForceUpdateController extends _$ForceUpdateController {
  @override
  bool build() => false;

  void require() {
    if (!state) {
      state = true;
    }
  }
}
