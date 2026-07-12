/// 禮物 / 鮮花相關 domain 值物件（`gift/*`，doc 10 §12.2、§12.3）。純 Dart（§4.2）。
library;

/// 禮物餘額（`gift/balance`）。egold＝輕嗶哩幣，score＝積分，flowerStock＝鮮花庫存，
/// flowerUnitPrice＝鮮花單價（egold）。
class GiftBalance {
  const GiftBalance({
    this.egold = 0,
    this.flowerStock = 0,
    this.flowerUnitPrice = 0,
    this.score = 0,
  });

  final int egold;
  final int flowerStock;
  final int flowerUnitPrice;
  final int score;
}

/// 送花結果（`gift/send`）。flowerStock＝送出後剩餘鮮花，novelAllFlower＝該小說累計鮮花。
class GiftSendResult {
  const GiftSendResult({this.flowerStock = 0, this.novelAllFlower = 0});

  final int flowerStock;
  final int novelAllFlower;
}

/// 小說送花統計（`gift/novel_stat`）。
class FlowerStat {
  const FlowerStat({
    this.allFlower = 0,
    this.dayFlower = 0,
    this.weekFlower = 0,
    this.monthFlower = 0,
    this.lastFlower = 0,
  });

  final int allFlower;
  final int dayFlower;
  final int weekFlower;
  final int monthFlower;
  final int lastFlower;
}
