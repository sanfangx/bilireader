import 'package:flutter/foundation.dart';

import '../constants/api_constants.dart';
import '../storage/session_store.dart';
import '../storage/token_store.dart';

/// 認證 session 本地管理（規範 §6.3、§7.3）。集中處理 token/uid/groupid 的
/// 讀寫與清除，供攔截器與認證狀態使用。純邏輯、無 Flutter/Riverpod 依賴，便於測試。
class AuthSessionManager {
  AuthSessionManager({
    required TokenStore tokenStore,
    required SessionStore sessionStore,
    Future<void> Function(int ownerUid)? clearOwnerCache,
    void Function()? onCleared,
  }) : _tokenStore = tokenStore,
       _sessionStore = sessionStore,
       _clearOwnerCache = clearOwnerCache,
       _onCleared = onCleared;

  final TokenStore _tokenStore;
  final SessionStore _sessionStore;

  /// 登出 / 401 / 666 時，以舊 uid 清 owner-scoped 快取（私訊等，doc 06）。
  final Future<void> Function(int ownerUid)? _clearOwnerCache;

  /// 登出 / 401 / 666 清除**後**的收尾（不需 uid）：中斷即時通訊 WebSocket（notice/chat），
  /// 避免殘留以舊 token 認證的連線（doc 08 §「token 變空→closeSocket」、§7.7）。
  final void Function()? _onCleared;

  String? _cachedToken;
  int _lastClearAtMs = 0;
  Future<void>? _hydration;

  /// 供攔截器同步讀取的目前 token（in-memory 快取）。null/空代表未登入。
  String? get currentToken => _cachedToken;

  bool get isLoggedIn => _cachedToken != null && _cachedToken!.isNotEmpty;

  /// 保證啟動時 token 已「首次」由儲存載入完成，供 Authorization 攔截器在送出
  /// 請求前 await。修正冷啟動競態：請求早於 [load] 完成 → 少了 Authorization
  /// header → 自招 401 反而清掉已保存的 token（規範 §6.3、§7.3）。首次之後
  /// persist / clear 直接更新 in-memory 快取，無需重載，故只記憶第一次；載入
  /// 失敗不永久記憶（下次請求可重試）。
  Future<void> ensureLoaded() {
    return _hydration ??= load().then<void>((_) {}).catchError((
      Object _,
      StackTrace _,
    ) {
      _hydration = null;
    });
  }

  /// 從儲存載入 session（App 啟動時呼叫），回填 in-memory 快取。
  Future<AuthSessionData> load() async {
    final String? token = await _tokenStore.read();
    _cachedToken = token;
    final int? uid = await _sessionStore.readUid();
    final int? groupId = await _sessionStore.readGroupId();
    return AuthSessionData(token: token, uid: uid, groupId: groupId);
  }

  /// 保存登入 session（登入 / 註冊成功後）。
  Future<void> persist({required String token, int? uid, int? groupId}) async {
    await _tokenStore.write(token);
    _cachedToken = token;
    if (uid != null) {
      await _sessionStore.writeUid(uid);
    }
    if (groupId != null) {
      await _sessionStore.writeGroupId(groupId);
    }
  }

  /// 立即清除本地登入態（token/uid/groupid）。用於顯式 401/666（handleUnauthorized）
  /// 與 logout（無論 server 是否成功都清）。
  ///
  /// 清除順序（規範 §7.3）：先以舊 uid 清 owner-scoped 資料（私訊 / 訊息中心快取
  /// 與未讀），最後才移除 token/uid/groupid。owner cache 於 Phase 3 建立後接上。
  Future<void> clear() async {
    // 清除順序（規範 §7.3、doc 06）：先以舊 uid 清 owner-scoped 快取（私訊等），
    // 最後才移除 token/uid/groupid（否則拿不到 owner uid）。
    final int? oldUid = await _sessionStore.readUid();
    if (oldUid != null) {
      await _clearOwnerCache?.call(oldUid);
    }
    await _tokenStore.delete();
    await _sessionStore.clear();
    _cachedToken = null;
    // token 已清空 → 中斷 WS（否則舊 token 認證之連線持續開著，伺服器仍認為舊帳號在線）。
    _onCleared?.call();
  }

  /// 泛用錯誤路徑的 401/666 清登入，帶 5 秒 debounce（規範 §6.3）。
  /// 多個並發請求同時 401 時只清一次。回傳是否實際執行清除；[nowMs] 便於測試注入。
  Future<bool> clearWithDebounce({required int nowMs}) async {
    if (nowMs - _lastClearAtMs < ApiConstants.clearLoginDebounceMs) {
      return false;
    }
    _lastClearAtMs = nowMs;
    await clear();
    return true;
  }
}

/// 載入後的 session 快照。
@immutable
class AuthSessionData {
  const AuthSessionData({this.token, this.uid, this.groupId});

  final String? token;
  final int? uid;
  final int? groupId;

  bool get isLoggedIn => token != null && token!.isNotEmpty;
}
