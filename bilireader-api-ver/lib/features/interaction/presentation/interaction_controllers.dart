import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/router/auth_controller.dart';
import '../data/interaction_providers.dart';
import '../domain/gift_models.dart';
import '../domain/vote_stats.dart';

part 'interaction_controllers.g.dart';

/// 互動端點需登入；未登入直接以 unauthorized 短路（避免 401 觸發登入態刷新迴圈）。
void _requireLogin(Ref ref) {
  if (!ref.watch(authControllerProvider).isLoggedIn) {
    throw ErrorMapper.fromBusinessCode(code: ApiConstants.codeTokenInvalid);
  }
}

/// 我對此書的評分（`rating/myRating`）。0 = 未評分。
@riverpod
Future<int> myRating(Ref ref, int articleId) async {
  _requireLogin(ref);
  return (await ref.watch(interactionRepositoryProvider).myRating(articleId))
      .dataOrThrow();
}

/// 投票統計（`vote/getNovelVotes`）。
@riverpod
Future<VoteStats> voteStats(Ref ref, int articleId) async {
  _requireLogin(ref);
  return (await ref.watch(interactionRepositoryProvider).novelVotes(articleId))
      .dataOrThrow();
}

/// 禮物餘額（`gift/balance`）。
@riverpod
Future<GiftBalance> giftBalance(Ref ref) async {
  _requireLogin(ref);
  return (await ref.watch(interactionRepositoryProvider).giftBalance())
      .dataOrThrow();
}

/// 送花統計（`gift/novel_stat`）。
@riverpod
Future<FlowerStat> flowerStat(Ref ref, int articleId) async {
  _requireLogin(ref);
  return (await ref.watch(interactionRepositoryProvider).flowerStat(articleId))
      .dataOrThrow();
}

/// 互動異動（評分 / 投票 / 送花）。皆為狀態變更端點（§7.0），僅供實際使用者操作，
/// 不做破壞性自動測試。成功後 invalidate 對應讀取 provider。
@riverpod
class InteractionMutations extends _$InteractionMutations {
  @override
  void build() {}

  Future<ApiResult<int>> submitRating({
    required int articleId,
    required int rating,
  }) async {
    final ApiResult<int> result = await ref
        .read(interactionRepositoryProvider)
        .submitRating(articleId: articleId, rating: rating);
    if (result is ApiSuccess<int>) {
      ref.invalidate(myRatingProvider(articleId));
    }
    return result;
  }

  Future<ApiResult<String>> addVote({
    required int articleId,
    int votes = 1,
  }) async {
    final ApiResult<String> result = await ref
        .read(interactionRepositoryProvider)
        .addVote(articleId: articleId, votes: votes);
    if (result is ApiSuccess<String>) {
      ref.invalidate(voteStatsProvider(articleId));
    }
    return result;
  }

  Future<ApiResult<GiftSendResult>> sendGift({
    required int articleId,
    required int count,
  }) async {
    final ApiResult<GiftSendResult> result = await ref
        .read(interactionRepositoryProvider)
        .sendGift(articleId: articleId, count: count);
    if (result is ApiSuccess<GiftSendResult>) {
      ref
        ..invalidate(giftBalanceProvider)
        ..invalidate(flowerStatProvider(articleId));
    }
    return result;
  }
}
