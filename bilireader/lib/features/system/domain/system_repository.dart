import '../../../core/network/api_result.dart';
import 'feedback_options.dart';
import 'system_entities.dart';

/// 系統 / 任務 / 版本 / 公告 / 回饋 repository。顯示文字於實作層轉繁（§5.0）；
/// 使用者輸入（回饋標題/內容）保留原文送出。
///
/// [signIn]（每日簽到）與 [submitFeedback] 為狀態變更端點（§7.0）——僅由 App 啟動一次/日
/// 自動簽到與使用者主動送出回饋觸發，不做破壞性自動測試。
abstract interface class SystemRepository {
  /// 每日簽到（`task/sign_in`）。需登入。
  Future<ApiResult<SignInResult>> signIn();

  /// 版本檢查（`version/check`）。網路失敗時 fail-open（不強更）。
  Future<VersionCheck> checkVersion();

  /// 更新日誌（`version/changelog`）。
  Future<ApiResult<List<VersionLog>>> changelog();

  /// 啟動公告（`system/startupAnnouncement`）。無公告回 null。
  Future<ApiResult<StartupAnnouncement?>> startupAnnouncement();

  /// 提交意見回饋（`feedback/submit`）。需登入。回傳 reportId。
  Future<ApiResult<int>> submitFeedback({
    required FeedbackSort sort,
    required FeedbackType type,
    required String title,
    required String content,
  });
}
