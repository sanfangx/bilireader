import '../../../core/network/api_result.dart';
import 'gift_models.dart';
import 'vote_stats.dart';

/// 詳情頁互動 repository（評分 / 推薦票 / 送花，doc 09 §5、doc 10 §12）。需登入。
///
/// 送花 / 投票 / 評分皆為狀態變更端點（§7.0）：僅供實際使用者操作，不做破壞性
/// 自動測試。讀取類（myRating / novelVotes / giftBalance / flowerStat）可安全查詢。
abstract interface class InteractionRepository {
  /// 我對此書的評分（`rating/myRating`）。未評分回 0。
  Future<ApiResult<int>> myRating(int articleId);

  /// 提交評分（`rating/submit`，rating 1–10）。回傳伺服器記錄的評分。
  Future<ApiResult<int>> submitRating({
    required int articleId,
    required int rating,
  });

  /// 查投票統計（`vote/getNovelVotes`）。
  Future<ApiResult<VoteStats>> novelVotes(int articleId);

  /// 投推薦票（`vote/addVote`，votes 預設 1）。回傳伺服器訊息。
  Future<ApiResult<String>> addVote({required int articleId, int votes});

  /// 查禮物餘額（`gift/balance`）。
  Future<ApiResult<GiftBalance>> giftBalance();

  /// 送鮮花（`gift/send`）。回傳送出後庫存與該書累計鮮花。
  Future<ApiResult<GiftSendResult>> sendGift({
    required int articleId,
    required int count,
  });

  /// 以貨幣兌換鮮花（`gift/exchange`，currency = egold/score）。回傳更新後餘額。
  Future<ApiResult<GiftBalance>> exchangeFlowers({
    required String currency,
    required int count,
  });

  /// 小說送花統計（`gift/novel_stat`）。
  Future<ApiResult<FlowerStat>> flowerStat(int articleId);
}
