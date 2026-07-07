import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/di/infra_providers.dart';
import '../../../core/network/api_result.dart';
import '../../../core/router/auth_controller.dart';
import '../../reader/reading_progress_providers.dart'
    show currentOwnerUidProvider;
import '../data/system_providers.dart';
import '../domain/feedback_options.dart';
import '../domain/system_entities.dart';

part 'system_controllers.g.dart';

/// 更新日誌（`version/changelog`）。
@riverpod
Future<List<VersionLog>> changelog(Ref ref) async {
  return (await ref.watch(systemRepositoryProvider).changelog()).dataOrThrow();
}

/// App 啟動流程協調（版本檢查 / 啟動公告去重 / 每日自動簽到）+ 開啟外部連結。
/// 皆比照原 App `MainActivity` / `AutoSignInManager` 行為（§11 ⑧）。
@Riverpod(keepAlive: true)
class SystemStartup extends _$SystemStartup {
  @override
  void build() {}

  /// 公告去重 key 前綴：**每則公告獨立記憶**（比照原 App `<dismissKey>_signature`）——
  /// 避免只用單一 slot 時「換了另一則公告後，先前已關閉的公告又重新彈出」。
  static const String _kSeenAnnouncementPrefix = 'sys_announcement_seen_';

  /// 每日簽到去重 / 顯示 key（per-uid，比照 `checked_day_<uid>`）。
  static String signInDayKey(int uid) => 'sys_last_sign_in_ymd_$uid';
  static String signInPointsKey(int uid) => 'sys_last_sign_in_points_$uid';

  /// 今日日期（yyyyMMdd）。
  static String todayYmd() {
    final DateTime n = DateTime.now();
    final String mm = n.month.toString().padLeft(2, '0');
    final String dd = n.day.toString().padLeft(2, '0');
    return '${n.year}$mm$dd';
  }

  /// 版本檢查（fail-open）。needUpdate 時強更旗標亦會由攔截器於 501 設定。
  Future<VersionCheck> versionCheck() =>
      ref.read(systemRepositoryProvider).checkVersion();

  /// 取得「應顯示」的啟動公告（以 identityKey 為 key、內容簽章比對）；無或已看過回 null。
  Future<StartupAnnouncement?> announcementIfNew() async {
    final ApiResult<StartupAnnouncement?> res = await ref
        .read(systemRepositoryProvider)
        .startupAnnouncement();
    final StartupAnnouncement? ann = res is ApiSuccess<StartupAnnouncement?>
        ? res.data
        : null;
    if (ann == null || !ann.hasContent) {
      return null;
    }
    final String? seen = ref
        .read(sharedPreferencesProvider)
        .getString(_seenKey(ann));
    if (seen == _signatureOf(ann)) {
      return null; // 同一份已看過
    }
    return ann;
  }

  /// 記錄公告已顯示（該 identity 記住此簽章；內容更新產生新簽章才會再彈）。
  Future<void> markAnnouncementSeen(StartupAnnouncement ann) => ref
      .read(sharedPreferencesProvider)
      .setString(_seenKey(ann), _signatureOf(ann));

  /// 每日自動簽到（登入且今日未簽）。§7.0：狀態變更，僅每日一次由 App 觸發。
  /// 比照 `AutoSignInManager`：以 `checked_day_<uid>` 去重；code==201/「已簽到」也記錄當日
  /// （不再重打），僅「真正簽到成功（200）」回傳結果供彈 Toast，已簽回 null。
  Future<SignInResult?> autoSignInIfNeeded() async {
    if (!ref.read(authControllerProvider).isLoggedIn) {
      return null;
    }
    final int? uid = await ref.read(currentOwnerUidProvider.future);
    if (uid == null) {
      return null;
    }
    final String key = signInDayKey(uid);
    final String today = todayYmd();
    final SharedPreferences prefs = ref.read(sharedPreferencesProvider);
    if (prefs.getString(key) == today) {
      return null;
    }
    final ApiResult<SignInResult> res = await ref
        .read(systemRepositoryProvider)
        .signIn();
    if (res is ApiSuccess<SignInResult>) {
      // 成功或「今日已簽」都記錄當日，避免同日重複打 sign_in。
      await prefs.setString(key, today);
      // 真正簽到成功才記錄本次積分（已簽到 201 無積分）；供「我的」簽到卡顯示。
      if (!res.data.alreadySigned) {
        await prefs.setInt(signInPointsKey(uid), res.data.points);
      }
      return res.data.alreadySigned ? null : res.data;
    }
    return null;
  }

  /// 以外部瀏覽器開啟連結（強更 appUrl / 公告 actionUrl）。
  Future<bool> openUrl(String url) async {
    final Uri? uri = Uri.tryParse(url);
    if (uri == null) {
      return false;
    }
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String _seenKey(StartupAnnouncement ann) =>
      '$_kSeenAnnouncementPrefix${ann.identityKey}';

  String _signatureOf(StartupAnnouncement ann) =>
      md5.convert(utf8.encode(ann.signatureSource)).toString();
}

/// 今日簽到顯示狀態（設計稿 `.pfsign`）。[points] 為本次獲得積分（0 = 未知/未簽）。
@immutable
class SignInDisplay {
  const SignInDisplay({required this.signedToday, required this.points});

  final bool signedToday;
  final int points;
}

/// 「我的」簽到卡狀態。**先與伺服器確認今日是否已簽**（`autoSignInIfNeeded`，本機今日已記錄則
/// 直接跳過、不重打），再讀本機記錄顯示。修正：啟動自動簽到跑在「尚未登入」之前 →
/// 登入後本機從未記錄 → 卡片一直停在「簽到中」且伺服器已有紀錄簽不了。已簽到（201/訊息）會被
/// `autoSignInIfNeeded` 記為今日 → 卡片顯示「已簽到」。§7.0：sign_in 每日僅一次（本機去重）。
@riverpod
Future<SignInDisplay> profileSignIn(Ref ref) async {
  final int? uid = await ref.watch(currentOwnerUidProvider.future);
  if (uid == null) {
    return const SignInDisplay(signedToday: false, points: 0);
  }
  // 與伺服器確認（本機今日未記錄時才實際打 sign_in；已簽到亦記為今日、不再重試）。
  await ref.read(systemStartupProvider.notifier).autoSignInIfNeeded();
  final SharedPreferences prefs = ref.watch(sharedPreferencesProvider);
  final bool signed =
      prefs.getString(SystemStartup.signInDayKey(uid)) ==
      SystemStartup.todayYmd();
  final int points = prefs.getInt(SystemStartup.signInPointsKey(uid)) ?? 0;
  return SignInDisplay(signedToday: signed, points: points);
}

/// 意見回饋送出（`feedback/submit`）。狀態變更端點（§7.0），僅使用者主動觸發。
@riverpod
class FeedbackActions extends _$FeedbackActions {
  @override
  void build() {}

  Future<ApiResult<int>> submit({
    required FeedbackSort sort,
    required FeedbackType type,
    required String title,
    required String content,
  }) => ref
      .read(systemRepositoryProvider)
      .submitFeedback(sort: sort, type: type, title: title, content: content);
}
