import 'package:flutter/foundation.dart';

/// 每日簽到結果（`task/sign_in` → {points,totalScore}）。
@immutable
class SignInResult {
  const SignInResult({
    required this.points,
    required this.totalScore,
    this.alreadySigned = false,
  });

  /// 本次獲得積分（伺服器未給時 DTO 預設 3，比照原 App）。
  final int points;
  final int totalScore;

  /// 今日已簽到（code==201 或 message 含「已簽到」）：仍記錄當日、但不彈 Toast。
  final bool alreadySigned;
}

/// 版本檢查結果（`version/check`）。強更以 HTTP 501 或 body.code==501 表示；
/// 動態 Map 中唯一被讀取的欄位為 [appUrl]（APK 下載連結）。
@immutable
class VersionCheck {
  const VersionCheck({required this.needUpdate, this.appUrl});

  final bool needUpdate;
  final String? appUrl;
}

/// 更新日誌項（`version/changelog` → `List<VersionLogItem>`）。顯示文字已轉繁（§5.0）。
@immutable
class VersionLog {
  const VersionLog({
    required this.versionName,
    required this.updateContent,
    this.isCurrent = false,
  });

  final String versionName;
  final String updateContent;
  final bool isCurrent;
}

/// 啟動公告（`system/startupAnnouncement`）。顯示文字已轉繁（§5.0）。
///
/// 去重（只彈一次、內容更新才再彈）：以 [identityKey]（dismissKey，缺則 `system_block_<bid>`）
/// + [signatureSource] 的雜湊為 key，比照原 App `MainActivity` 行為。
@immutable
class StartupAnnouncement {
  const StartupAnnouncement({
    this.bid,
    this.title,
    this.content,
    this.actionText,
    this.actionUrl,
    this.dismissKey,
    this.description,
    this.latestVersionName,
    this.latestVersionCode,
    this.latestUpdateContent,
  });

  final int? bid;
  final String? title;
  final String? content;
  final String? actionText;
  final String? actionUrl;
  final String? dismissKey;
  final String? description;
  final String? latestVersionName;
  final int? latestVersionCode;
  final String? latestUpdateContent;

  /// 是否有可顯示內容（標題或內文其一非空）。
  bool get hasContent =>
      (title?.trim().isNotEmpty ?? false) ||
      (content?.trim().isNotEmpty ?? false);

  /// 是否顯示行動按鈕（actionUrl 為 http/https；大小寫不敏感，比照原 isHttpUrl）。
  bool get hasAction {
    final String url = actionUrl?.trim().toLowerCase() ?? '';
    return url.startsWith('http://') || url.startsWith('https://');
  }

  /// 去重身分：dismissKey 優先，否則 `system_block_<bid>`（bid 缺為 0）。
  String get identityKey {
    final String key = dismissKey?.trim() ?? '';
    return key.isNotEmpty ? key : 'system_block_${bid ?? 0}';
  }

  /// 簽章來源字串（內容或版本欄位任一變動即產生新簽章 → 會重新彈出）。
  String get signatureSource => <String>[
    title ?? '',
    description ?? '',
    actionText ?? '',
    actionUrl ?? '',
    latestVersionName ?? '',
    '${latestVersionCode ?? ''}',
    latestUpdateContent ?? '',
    content?.trim() ?? '',
  ].join('|');
}
