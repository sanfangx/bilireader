import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/base_response.dart';
import '../../../core/network/error_mapper.dart';
import 'dto/interaction_dtos.dart';

/// 詳情互動端點（Rating / Vote / Gift ApiService，API.md §8.1/§8.4/§8.5）。
/// 全部 POST：Body 參數用 `data`、Query 參數用 `queryParameters`（與全站一致）。需登入。
class InteractionRemoteDataSource {
  const InteractionRemoteDataSource(this._dio);

  final Dio _dio;

  // ---- 評分（Body）----

  /// `rating/myRating`（Body articleid）→ `{rating}`。未評分回 0。
  Future<int> myRating(int articleId) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.ratingMy,
      data: <String, dynamic>{'articleid': articleId},
    );
    return _ratingOf(resp);
  }

  /// `rating/submit`（Body articleid + rating）→ `{rating}`。
  Future<int> submitRating({
    required int articleId,
    required int rating,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.ratingSubmit,
      data: <String, dynamic>{'articleid': articleId, 'rating': rating},
    );
    return _ratingOf(resp);
  }

  // ---- 投票（Body）----

  /// `vote/getNovelVotes`（Body articleid）。
  Future<NovelVotesDto> novelVotes(int articleId) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.voteGetNovelVotes,
      data: <String, dynamic>{'articleid': articleId},
    );
    final BaseResponse<NovelVotesDto> base = _base(
      resp,
      (Object? d) => NovelVotesDto.fromJson(_map(d)),
    );
    _ensure(base);
    return base.data ?? const NovelVotesDto();
  }

  /// `vote/addVote`（Body articleid + votes）→ `{msg}`。
  Future<String> addVote({required int articleId, int votes = 1}) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.voteAdd,
      data: <String, dynamic>{'articleid': articleId, 'votes': votes},
    );
    final BaseResponse<String> base = _base(
      resp,
      (Object? d) => _map(d)['msg']?.toString() ?? '',
    );
    _ensure(base);
    return base.data ?? base.message;
  }

  // ---- 禮物 / 鮮花（gift/balance 無參數；其餘 Query）----

  /// `gift/balance`（無參數）。
  Future<GiftBalanceDto> giftBalance() async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.giftBalance,
    );
    final BaseResponse<GiftBalanceDto> base = _base(
      resp,
      (Object? d) => GiftBalanceDto.fromJson(_map(d)),
    );
    _ensure(base);
    return base.data ?? const GiftBalanceDto();
  }

  /// `gift/send`（Query articleid + count）。
  Future<GiftSendDto> sendGift({
    required int articleId,
    required int count,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.giftSend,
      queryParameters: <String, dynamic>{
        'articleid': articleId,
        'count': count,
      },
    );
    final BaseResponse<GiftSendDto> base = _base(
      resp,
      (Object? d) => GiftSendDto.fromJson(_map(d)),
    );
    _ensure(base);
    return base.data ?? const GiftSendDto();
  }

  /// `gift/exchange`（Query currency + count）。
  Future<GiftExchangeDto> exchange({
    required String currency,
    required int count,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.giftExchange,
      queryParameters: <String, dynamic>{'currency': currency, 'count': count},
    );
    final BaseResponse<GiftExchangeDto> base = _base(
      resp,
      (Object? d) => GiftExchangeDto.fromJson(_map(d)),
    );
    _ensure(base);
    return base.data ?? const GiftExchangeDto();
  }

  /// `gift/novel_stat`（Query articleid）。
  Future<FlowerStatDto> flowerStat(int articleId) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.giftNovelStat,
      queryParameters: <String, dynamic>{'articleid': articleId},
    );
    final BaseResponse<FlowerStatDto> base = _base(
      resp,
      (Object? d) => FlowerStatDto.fromJson(_map(d)),
    );
    _ensure(base);
    return base.data ?? const FlowerStatDto();
  }

  // ---- helpers ----

  int _ratingOf(Response<dynamic> resp) {
    final BaseResponse<int> base = _base(resp, (Object? d) {
      final Object? v = _map(d)['rating'];
      return v is num ? v.toInt() : int.tryParse('${v ?? ''}') ?? 0;
    });
    _ensure(base);
    return base.data ?? 0;
  }

  Map<String, dynamic> _map(Object? d) =>
      d is Map<String, dynamic> ? d : const <String, dynamic>{};

  BaseResponse<T> _base<T>(
    Response<dynamic> resp,
    T Function(Object? data) fromData,
  ) {
    final Object? body = resp.data;
    final Map<String, dynamic> map = body is Map<String, dynamic>
        ? body
        : const <String, dynamic>{};
    return BaseResponse<T>.fromJson(map, fromData);
  }

  void _ensure<T>(BaseResponse<T> base) {
    if (base.code != ApiConstants.codeSuccess) {
      throw ErrorMapper.fromBusinessCode(
        code: base.code,
        serverMessage: base.message,
      );
    }
  }
}
