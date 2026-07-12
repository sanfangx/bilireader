/// 分類選項(對齊實測解碼的 linovelib 體系)。
class Taxon {
  const Taxon(this.label, this.value);
  final String label;
  final Object value; // String(order/metric) 或 int(rgroupid/tagid)
}

class Taxonomy {
  Taxonomy._();

  /// 文庫排序(URL 前綴)
  static const List<Taxon> orders = [
    Taxon('月點擊', 'monthvisit'),
    Taxon('推薦', 'monthvote'),
    Taxon('鮮花', 'monthflower'),
    Taxon('收藏', 'goodnum'),
    Taxon('字數', 'words'),
    Taxon('更新', 'lastupdate'),
  ];

  /// 來源 rgroupid
  static const List<Taxon> sources = [
    Taxon('不限', 0),
    Taxon('日本輕小說', 1),
    Taxon('華文', 2),
    Taxon('Web', 3),
    Taxon('輕改漫畫', 4),
    Taxon('韓國', 5),
  ];

  /// 題材 tagid
  static const List<Taxon> genres = [
    Taxon('不限', 0),
    Taxon('戀愛', 64),
    Taxon('校園', 63),
    Taxon('異世界', 47),
    Taxon('轉生', 26),
    Taxon('後宮', 48),
    Taxon('百合', 27),
    Taxon('奇幻', 15),
    Taxon('冒險', 61),
    Taxon('魔法', 96),
    Taxon('青春', 67),
  ];

  /// 標籤頁的完整題材雲(tagid)
  static const List<Taxon> allTags = [
    Taxon('戀愛', 64),
    Taxon('異世界', 47),
    Taxon('校園', 63),
    Taxon('轉生', 26),
    Taxon('後宮', 48),
    Taxon('百合', 27),
    Taxon('奇幻', 15),
    Taxon('冒險', 61),
    Taxon('魔法', 96),
    Taxon('青春', 67),
    Taxon('女性視角', 231),
    Taxon('龍傲天', 219),
    Taxon('歡樂向', 222),
  ];

  /// 排行榜維度(metric;週/月由前綴 week/month 組合,goodnum/newhot 無前綴)
  static const List<Taxon> rankMetrics = [
    Taxon('點擊榜', 'visit'),
    Taxon('推薦榜', 'vote'),
    Taxon('鮮花榜', 'flower'),
    Taxon('收藏榜', 'goodnum'),
    Taxon('新書榜', 'newhot'),
  ];
}
