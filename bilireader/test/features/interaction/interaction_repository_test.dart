import 'dart:io';

import 'package:bilireader/core/network/api_result.dart';
import 'package:bilireader/core/text/chinese_converter.dart';
import 'package:bilireader/features/interaction/data/dto/interaction_dtos.dart';
import 'package:bilireader/features/interaction/data/interaction_remote_data_source.dart';
import 'package:bilireader/features/interaction/data/interaction_repository_impl.dart';
import 'package:bilireader/features/interaction/domain/gift_models.dart';
import 'package:bilireader/features/interaction/domain/vote_stats.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeInteractionRemote implements InteractionRemoteDataSource {
  NovelVotesDto votes = const NovelVotesDto();
  GiftBalanceDto balance = const GiftBalanceDto();
  GiftSendDto sent = const GiftSendDto();
  FlowerStatDto stat = const FlowerStatDto();
  int rating = 0;
  String voteMsg = '';

  @override
  Future<int> myRating(int articleId) async => rating;

  @override
  Future<int> submitRating({
    required int articleId,
    required int rating,
  }) async => rating;

  @override
  Future<NovelVotesDto> novelVotes(int articleId) async => votes;

  @override
  Future<String> addVote({required int articleId, int votes = 1}) async =>
      voteMsg;

  @override
  Future<GiftBalanceDto> giftBalance() async => balance;

  @override
  Future<GiftSendDto> sendGift({
    required int articleId,
    required int count,
  }) async => sent;

  @override
  Future<GiftExchangeDto> exchange({
    required String currency,
    required int count,
  }) async => const GiftExchangeDto();

  @override
  Future<FlowerStatDto> flowerStat(int articleId) async => stat;
}

void main() {
  late ChineseConverter converter;

  setUpAll(() async {
    converter = ChineseConverter(loader: (String k) => File(k).readAsString());
    await converter.ensureLoaded();
  });

  InteractionRepositoryImpl build(_FakeInteractionRemote remote) =>
      InteractionRepositoryImpl(remote: remote, converter: converter);

  test('novelVotes：DTO → VoteStats', () async {
    final _FakeInteractionRemote remote = _FakeInteractionRemote()
      ..votes = const NovelVotesDto(
        allVote: 128,
        dayVote: 3,
        weekVote: 20,
        monthVote: 88,
        todayVoted: true,
        userVoted: true,
      );
    final VoteStats s =
        ((await build(remote).novelVotes(7)) as ApiSuccess<VoteStats>).data;
    expect(s.allVote, 128);
    expect(s.weekVote, 20);
    expect(s.todayVoted, isTrue);
  });

  test('giftBalance / sendGift / flowerStat：DTO → domain', () async {
    final _FakeInteractionRemote remote = _FakeInteractionRemote()
      ..balance = const GiftBalanceDto(
        egold: 1280,
        flowerStock: 12,
        flowerUnitPrice: 10,
        score: 3460,
      )
      ..sent = const GiftSendDto(flowerStock: 7, novelAllFlower: 999)
      ..stat = const FlowerStatDto(allflower: 500, dayflower: 5);
    final InteractionRepositoryImpl repo = build(remote);

    final GiftBalance b =
        ((await repo.giftBalance()) as ApiSuccess<GiftBalance>).data;
    expect(b.egold, 1280);
    expect(b.flowerUnitPrice, 10);

    final GiftSendResult r =
        ((await repo.sendGift(articleId: 7, count: 5))
                as ApiSuccess<GiftSendResult>)
            .data;
    expect(r.flowerStock, 7);
    expect(r.novelAllFlower, 999);

    final FlowerStat f =
        ((await repo.flowerStat(7)) as ApiSuccess<FlowerStat>).data;
    expect(f.allFlower, 500);
    expect(f.dayFlower, 5);
  });

  test('submitRating：透傳伺服器評分', () async {
    final _FakeInteractionRemote remote = _FakeInteractionRemote();
    final int r =
        ((await build(remote).submitRating(articleId: 7, rating: 8))
                as ApiSuccess<int>)
            .data;
    expect(r, 8);
  });

  test('addVote：伺服器訊息轉繁（§5.0）', () async {
    final _FakeInteractionRemote remote = _FakeInteractionRemote()
      ..voteMsg = '软件投票成功'; // 简体 → 繁体
    final String msg =
        ((await build(remote).addVote(articleId: 7)) as ApiSuccess<String>)
            .data;
    expect(msg, '軟體投票成功');
  });
}
