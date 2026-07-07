import 'package:flutter/foundation.dart';

/// 使用者資訊 domain entity（規範 §4.3：不攜帶 JSON annotation）。僅收錄顯示與
/// session 相關欄位。注意：[nickname]/[sign] 等 server 文字可能為簡體，presentation
/// 顯示前須經 OpenCC 轉繁（規範 §5.0）。
@immutable
class UserInfo {
  const UserInfo({
    required this.uid,
    this.username,
    this.nickname,
    this.avatarUrl,
    this.groupid,
    this.level,
    this.isVip = false,
    this.experience,
    this.score,
    this.egold,
    this.credit,
    this.votes,
    this.sign,
    this.email,
  });

  final int uid;
  final String? username;
  final String? nickname;
  final String? avatarUrl;
  final int? groupid;
  final String? level;
  final bool isVip;

  /// 會員數值（設計稿 `.pfstat5`，皆為 UserEntity 真實欄位）。
  final int? experience; // 經驗
  final int? score; // 積分
  final int? egold; // 輕嗶哩幣
  final int? credit; // 貢獻
  final String? votes; // 推薦票（wire 為 String）
  final String? sign;
  final String? email;

  /// 作者專區權限（groupid 1=管理員 / 5=作者 / 6=用愛發電）。
  bool get canAccessAuthorZone => groupid == 1 || groupid == 5 || groupid == 6;
}
