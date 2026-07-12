import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user_profile.dart';
import '../network/api_client.dart';
import 'auth_session.dart';

enum AuthStatus { unknown, loggedOut, loggedIn, expired }

/// 全域登入狀態。單例 + ChangeNotifier，根層用 ListenableBuilder 監聽。
class AuthController extends ChangeNotifier {
  AuthController._();
  static final AuthController instance = AuthController._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _key = 'auth_session_v1';

  AuthStatus _status = AuthStatus.unknown;
  AuthSession? _session;
  bool _guestMode = false;

  /// 上次翻成 expired 的時間，供 [markExpired] 做 5 秒 debounce。
  DateTime? _lastExpireAt;

  AuthStatus get status => _status;
  AuthSession? get session => _session;
  bool get isLoggedIn => _status == AuthStatus.loggedIn;

  /// 訪客模式：未登入仍可瀏覽書城/詳情/閱讀免費章（帳號功能需登入）。
  /// 不持久化——每次啟動回登入落地頁再選。
  bool get guestMode => _guestMode;

  void enterGuestMode() {
    _guestMode = true;
    notifyListeners();
  }

  /// App 啟動時讀回持久化的 session。
  Future<void> load() async {
    try {
      final raw = await _storage.read(key: _key);
      if (raw != null) {
        final s = AuthSession.decode(raw);
        if (s.isLoggedIn) {
          _session = s;
          _set(AuthStatus.loggedIn);
          return;
        }
      }
    } catch (_) {
      // 解析失敗 → 視為未登入
    }
    _set(AuthStatus.loggedOut);
  }

  /// WebView 登入成功後收割到的 cookie。
  Future<void> saveSession(Map<String, String> cookies) async {
    final s = AuthSession(cookies: cookies, savedAt: DateTime.now());
    _session = s;
    await _storage.write(key: _key, value: s.encode());
    _set(AuthStatus.loggedIn);
  }

  /// 收割 cookie 後補上 `/user.php` 解析出的使用者資訊（暱稱/頭像/等級）。
  /// profile 為 null 或尚未登入時不動作。
  Future<void> applyProfile(UserProfile? profile) async {
    final s = _session;
    if (s == null || profile == null) return;
    _session = s.copyWith(profile: profile);
    try {
      await _storage.write(key: _key, value: _session!.encode());
    } catch (_) {
      // 寫入失敗不影響記憶體中的 session
    }
    notifyListeners();
  }

  Future<void> logout() async {
    // 1) best-effort 通知伺服器登出。
    try {
      await ApiClient.instance.dio.get<String>('/logout.php');
    } catch (_) {}
    // 2) 清 WebView CookieManager —— 否則下次開 WebView 會自動以舊帳號登入，
    //    使用者無法真正登出 / 切換帳號（原本只刪 secure storage 的 blocker）。
    if (!kIsWeb) {
      try {
        await CookieManager.instance().deleteAllCookies();
      } catch (_) {}
    }
    // 3) 清本機 session（登出也退出訪客模式，回登入落地頁）。
    _session = null;
    _guestMode = false;
    await _storage.delete(key: _key);
    _set(AuthStatus.loggedOut);
  }

  /// cf_clearance / 登入態失效 → 標記逾期，引導重驗（保留舊 session 供顯示）。
  ///
  /// 加 5 秒 debounce：多個並發請求同時偵測到失效時只翻一次狀態、避免抖動；
  /// 也保護「剛重新登入後」的殘留失敗請求不會立刻又把新 session 踢成逾期。
  void markExpired() {
    if (_status != AuthStatus.loggedIn) return;
    final now = DateTime.now();
    if (_lastExpireAt != null &&
        now.difference(_lastExpireAt!) < const Duration(seconds: 5)) {
      return;
    }
    _lastExpireAt = now;
    _set(AuthStatus.expired);
  }

  void _set(AuthStatus s) {
    _status = s;
    notifyListeners();
  }
}
