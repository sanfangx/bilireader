/// 使用者中心資訊（由 `/user.php` 解析）。
///
/// 取代先前「從 cookie 讀 jieqiUserId / jieqiUserName」的錯誤做法——實測登入 cookie
/// 只有 `jieqiUserInfo`(加密 CSV) / `jieqiVisitInfo` / `PHPSESSID` / `cf_clearance`，
/// 並沒有 userId / userName，故暱稱與頭像必須另抓 `/user.php` 解析。
class UserProfile {
  const UserProfile({
    this.userId,
    this.nickname,
    this.avatarUrl,
    this.levelLabel,
    this.isVip = false,
  });

  /// 站方使用者 id（由頭像路徑 `/files/system/avatar/{seg}/{id}s.jpg` 的檔名反推）。
  final String? userId;

  /// 顯示暱稱。
  final String? nickname;

  /// 頭像完整 URL。
  final String? avatarUrl;

  /// 會員等級文字（例：普通會員 / VIP）。
  final String? levelLabel;

  final bool isVip;

  /// 三個關鍵欄位皆空 = 解析失敗 / 未登入，視為無效 profile。
  bool get isEmpty => userId == null && nickname == null && avatarUrl == null;

  Map<String, dynamic> toJson() => <String, dynamic>{
        if (userId != null) 'userId': userId,
        if (nickname != null) 'nickname': nickname,
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
        if (levelLabel != null) 'levelLabel': levelLabel,
        'isVip': isVip,
      };

  factory UserProfile.fromJson(Map<String, dynamic> j) => UserProfile(
        userId: j['userId'] as String?,
        nickname: j['nickname'] as String?,
        avatarUrl: j['avatarUrl'] as String?,
        levelLabel: j['levelLabel'] as String?,
        isVip: j['isVip'] as bool? ?? false,
      );
}
