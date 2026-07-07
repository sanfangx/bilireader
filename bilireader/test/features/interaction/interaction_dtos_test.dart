import 'package:bilireader/features/interaction/data/dto/interaction_dtos.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('NovelVotesDto：駝峰 wire key', () {
    final NovelVotesDto d = NovelVotesDto.fromJson(<String, dynamic>{
      'allVote': 128,
      'articleid': 7,
      'dayVote': 3,
      'weekVote': 20,
      'monthVote': 88,
      'todayVoted': true,
      'userVoted': true,
    });
    expect(d.allVote, 128);
    expect(d.dayVote, 3);
    expect(d.weekVote, 20);
    expect(d.monthVote, 88);
    expect(d.todayVoted, isTrue);
    expect(d.userVoted, isTrue);
  });

  test('GiftBalanceDto：egold/flowerStock/flowerUnitPrice/score', () {
    final GiftBalanceDto d = GiftBalanceDto.fromJson(<String, dynamic>{
      'egold': 1280,
      'flowerStock': 12,
      'flowerUnitPrice': 10,
      'score': 3460,
    });
    expect(d.egold, 1280);
    expect(d.flowerStock, 12);
    expect(d.flowerUnitPrice, 10);
    expect(d.score, 3460);
  });

  test('GiftSendDto：送出後庫存＋累計鮮花', () {
    final GiftSendDto d = GiftSendDto.fromJson(<String, dynamic>{
      'flowerStock': 7,
      'novelAllFlower': 999,
    });
    expect(d.flowerStock, 7);
    expect(d.novelAllFlower, 999);
  });

  test('FlowerStatDto：全小寫 wire key', () {
    final FlowerStatDto d = FlowerStatDto.fromJson(<String, dynamic>{
      'allflower': 500,
      'dayflower': 5,
      'weekflower': 30,
      'monthflower': 120,
      'lastflower': 1,
    });
    expect(d.allflower, 500);
    expect(d.dayflower, 5);
    expect(d.weekflower, 30);
    expect(d.monthflower, 120);
    expect(d.lastflower, 1);
  });

  test('缺欄位以預設 0/false 補齊', () {
    final NovelVotesDto v = NovelVotesDto.fromJson(<String, dynamic>{});
    expect(v.allVote, 0);
    expect(v.todayVoted, isFalse);
    final GiftBalanceDto g = GiftBalanceDto.fromJson(<String, dynamic>{});
    expect(g.flowerStock, 0);
  });
}
