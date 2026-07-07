import 'package:dio/dio.dart';

import '../../../core/network/api_result.dart';
import '../../../core/network/app_error.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/text/chinese_converter.dart';
import '../domain/gift_models.dart';
import '../domain/interaction_repository.dart';
import '../domain/vote_stats.dart';
import 'dto/interaction_dtos.dart';
import 'interaction_remote_data_source.dart';

/// [InteractionRepository] 實作。DTO→domain 映射；伺服器訊息（投票 msg）轉繁（§5.0）。
class InteractionRepositoryImpl implements InteractionRepository {
  InteractionRepositoryImpl({
    required InteractionRemoteDataSource remote,
    required ChineseConverter converter,
  }) : _remote = remote,
       _converter = converter;

  final InteractionRemoteDataSource _remote;
  final ChineseConverter _converter;

  @override
  Future<ApiResult<int>> myRating(int articleId) =>
      _guard(() => _remote.myRating(articleId));

  @override
  Future<ApiResult<int>> submitRating({
    required int articleId,
    required int rating,
  }) =>
      _guard(() => _remote.submitRating(articleId: articleId, rating: rating));

  @override
  Future<ApiResult<VoteStats>> novelVotes(int articleId) => _guard(() async {
    final NovelVotesDto d = await _remote.novelVotes(articleId);
    return VoteStats(
      allVote: d.allVote,
      dayVote: d.dayVote,
      weekVote: d.weekVote,
      monthVote: d.monthVote,
      todayVoted: d.todayVoted,
      userVoted: d.userVoted,
    );
  });

  @override
  Future<ApiResult<String>> addVote({required int articleId, int votes = 1}) =>
      _guard(() async {
        final String msg = await _remote.addVote(
          articleId: articleId,
          votes: votes,
        );
        return msg.isEmpty ? msg : _converter.toTraditionalTw(msg);
      });

  @override
  Future<ApiResult<GiftBalance>> giftBalance() => _guard(() async {
    final GiftBalanceDto d = await _remote.giftBalance();
    return GiftBalance(
      egold: d.egold,
      flowerStock: d.flowerStock,
      flowerUnitPrice: d.flowerUnitPrice,
      score: d.score,
    );
  });

  @override
  Future<ApiResult<GiftSendResult>> sendGift({
    required int articleId,
    required int count,
  }) => _guard(() async {
    final GiftSendDto d = await _remote.sendGift(
      articleId: articleId,
      count: count,
    );
    return GiftSendResult(
      flowerStock: d.flowerStock,
      novelAllFlower: d.novelAllFlower,
    );
  });

  @override
  Future<ApiResult<GiftBalance>> exchangeFlowers({
    required String currency,
    required int count,
  }) => _guard(() async {
    final GiftExchangeDto d = await _remote.exchange(
      currency: currency,
      count: count,
    );
    // exchange 回應不含 flowerUnitPrice；此欄位由呼叫端沿用先前 balance。
    return GiftBalance(
      egold: d.egold,
      flowerStock: d.flowerStock,
      score: d.score,
    );
  });

  @override
  Future<ApiResult<FlowerStat>> flowerStat(int articleId) => _guard(() async {
    final FlowerStatDto d = await _remote.flowerStat(articleId);
    return FlowerStat(
      allFlower: d.allflower,
      dayFlower: d.dayflower,
      weekFlower: d.weekflower,
      monthFlower: d.monthflower,
      lastFlower: d.lastflower,
    );
  });

  Future<ApiResult<T>> _guard<T>(Future<T> Function() body) async {
    try {
      await _converter.ensureLoaded();
      return ApiSuccess<T>(await body());
    } on DioException catch (e) {
      return ApiFailure<T>(ErrorMapper.fromDio(e));
    } on AppError catch (e) {
      return ApiFailure<T>(e);
    } on Object catch (e) {
      return ApiFailure<T>(ErrorMapper.parse(e));
    }
  }
}
