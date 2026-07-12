import 'dart:convert';

import '../models/user_profile.dart';

/// 登入 session：保存收割到的 cookie，以及另抓 `/user.php` 解析出的使用者資訊。
///
/// 身分（暱稱/頭像/id）改由 [profile] 提供——**不再**從 cookie 讀取
/// jieqiUserId / jieqiUserName（那兩個 cookie 實際上不存在）。
class AuthSession {
  AuthSession({required this.cookies, required this.savedAt, this.profile});

  final Map<String, String> cookies;
  final DateTime savedAt;

  /// 使用者中心資訊；登入成功後才由 `/user.php` 補上（可能為 null）。
  final UserProfile? profile;

  bool get isLoggedIn => cookies['jieqiUserInfo']?.isNotEmpty ?? false;

  String? get userId => profile?.userId;

  String? get avatarUrl => profile?.avatarUrl;

  String get displayName {
    final n = profile?.nickname;
    return (n != null && n.isNotEmpty) ? n : '書友';
  }

  String? get levelLabel => profile?.levelLabel;

  bool get isVip => profile?.isVip ?? false;

  AuthSession copyWith({UserProfile? profile}) => AuthSession(
        cookies: cookies,
        savedAt: savedAt,
        profile: profile ?? this.profile,
      );

  /// 給 dio / 圖片請求帶上的 Cookie header。
  String get cookieHeader =>
      cookies.entries.map((e) => '${e.key}=${e.value}').join('; ');

  Map<String, dynamic> toJson() => <String, dynamic>{
        'cookies': cookies,
        'savedAt': savedAt.toIso8601String(),
        if (profile != null) 'profile': profile!.toJson(),
      };

  factory AuthSession.fromJson(Map<String, dynamic> j) => AuthSession(
        cookies: Map<String, String>.from(j['cookies'] as Map),
        savedAt: DateTime.tryParse(j['savedAt'] as String? ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0),
        profile: j['profile'] is Map
            ? UserProfile.fromJson(
                Map<String, dynamic>.from(j['profile'] as Map))
            : null,
      );

  String encode() => jsonEncode(toJson());

  factory AuthSession.decode(String s) =>
      AuthSession.fromJson(jsonDecode(s) as Map<String, dynamic>);
}
