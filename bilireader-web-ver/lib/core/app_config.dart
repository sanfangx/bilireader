import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

/// 全站常數（對齊實測的 linovelib 後端）。
class AppConfig {
  AppConfig._();

  static const String origin = 'https://tw.linovelib.com';
  static const String loginUrl = '$origin/login.php';
  static const String registerUrl = '$origin/register.php';
  static const String logoutUrl = '$origin/logout.php';
  static const String bookcaseUrl = '$origin/bookcase.php';
  static const String userCenterUrl = '$origin/user.php';

  static const String _androidUA =
      'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/124.0.0.0 Mobile Safari/537.36';

  // iOS 用 Safari UA：WKWebView 引擎是 WebKit/Safari，UA 必須對齊引擎指紋，
  // 否則 Cloudflare 的 JS 挑戰（UA 宣稱 Android 但引擎是 Safari）會一直過不去。
  static const String _iosUA =
      'Mozilla/5.0 (iPhone; CPU iPhone OS 17_6 like Mac OS X) '
      'AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.6 '
      'Mobile/15E148 Safari/604.1';

  /// 平台對應的行動版 User-Agent。
  /// **WebView 與 dio 必須用同一個**——cf_clearance 綁定 UA + IP。
  static String get userAgent =>
      (!kIsWeb && Platform.isIOS) ? _iosUA : _androidUA;

  /// 登入後要收割 / 後續帶上的 cookie。
  static const List<String> sessionCookieNames = <String>[
    'cf_clearance', 'jieqiUserInfo', 'jieqiVisitInfo', 'PHPSESSID', 'jieqiRecentRead', 'night',
  ];

  /// 判定「已登入」的關鍵 cookie。
  static const String loginMarkerCookie = 'jieqiUserInfo';
}
