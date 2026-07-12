import '../../../core/network/api_result.dart';
import 'notification_entities.dart';

/// 通知 repository（API.md §8.6 notification/*）。需登入。文字轉繁（§5.0）。
///
/// list/unreadCount 為讀取；readAll/read/readByTopic 為狀態變更端點（§7.0），僅供
/// 使用者操作、不做破壞性自動測試。即時新通知另由 notice WebSocket 推送（doc 08）。
abstract interface class NotificationRepository {
  /// 通知列表（`notification/list`，依分類 type）。
  Future<ApiResult<NotificationPage>> list({
    required NotificationTab tab,
    int page,
  });

  /// 未讀通知數（`notification/unread_count`）。
  Future<ApiResult<int>> unreadCount({NotificationTab? tab});

  /// 全部標為已讀（`notification/read_all`）。
  Future<ApiResult<void>> readAll({NotificationTab? tab});

  /// 單則標為已讀（`notification/read`）。
  Future<ApiResult<void>> read(int notifyId);
}
