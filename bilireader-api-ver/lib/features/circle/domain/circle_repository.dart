import 'package:cross_file/cross_file.dart';

import '../../../core/network/api_result.dart';
import '../../../core/social/reaction.dart';
import 'circle_entities.dart';

/// 圈子 repository（API.md §8.2 circle/*）。需登入。顯示文字於實作層轉繁（§5.0）。
///
/// 讀取（sections/list/detail/replies）可安全查詢；like/replyLike/publish/reply/edit
/// 為狀態變更端點（§7.0），僅供實際使用者操作、不做破壞性自動測試。
/// publish/reply 為 Multipart🔒（BNUP2 簽章，doc 04）。
abstract interface class CircleRepository {
  /// 版塊清單（`circle/sections`）。
  Future<ApiResult<List<CircleSection>>> sections();

  /// 貼文列表（`circle/list`，category 預設 latest）。
  Future<ApiResult<CircleFeed>> list({
    String category,
    int? sectionId,
    String? keyword,
    int page,
  });

  /// 貼文詳情（`circle/detail`）。
  Future<ApiResult<CirclePost>> detail(int topicId);

  /// 貼文回覆列表（`circle/replies`，分頁）。
  Future<ApiResult<CircleReplyPage>> replies({required int topicId, int page});

  /// 貼文按讚/倒讚（`circle/like`）。type：讚1/倒讚2/取消0。
  Future<ApiResult<ReactionCounts>> like({
    required int topicId,
    required int type,
  });

  /// 回覆按讚/倒讚（`circle/reply_like`）。
  Future<ApiResult<ReactionCounts>> replyLike({
    required int postId,
    required int type,
  });

  /// 發表貼文（`circle/publish`，Multipart🔒 BNUP2）。回傳新 topicId。
  /// [images] 為使用者選取的圖片附件（`images`），可空。
  Future<ApiResult<int>> publish({
    required int sectionId,
    required String title,
    required String content,
    List<XFile> images,
  });

  /// 回覆貼文（`circle/reply`，Multipart🔒 BNUP2）。回傳新回覆。
  Future<ApiResult<CircleReply>> reply({
    required int topicId,
    required String posttext,
    int? replyPid,
    List<XFile> images,
  });
}
