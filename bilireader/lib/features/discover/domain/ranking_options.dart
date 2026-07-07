/// 榜單型別 / 週期 / 新書排序選項（規範 §5.0、doc 11 §5.2，值皆已驗證）。
///
/// wire 值（int/String）對齊原生常數；[label] 為 App 自有 UI 文案，直接以繁體撰寫
/// （不經 OpenCC，因非後端資料）。
library;

/// 榜單型別（`getRanking` 的 `type`，RankingActivity.java:46-53）。
enum RankingType {
  todayRecommend(0, '今日推薦'),
  click(1, '點擊榜'),
  newBook(2, '新書榜'),
  finished(3, '完本榜'),
  flower(4, '鮮花榜'),
  favorite(5, '收藏榜'),
  recommend(6, '推薦榜'),
  lastUpdate(7, '最近更新');

  const RankingType(this.value, this.label);

  final int value;
  final String label;

  /// 預設點擊榜（RankingActivity.java:66）。
  static const RankingType defaultValue = RankingType.click;

  /// 榜單頁側欄實際列出的型別（design：點擊/新書/完本/鮮花/收藏/推薦）。
  static const List<RankingType> tabs = <RankingType>[
    RankingType.click,
    RankingType.newBook,
    RankingType.finished,
    RankingType.flower,
    RankingType.favorite,
    RankingType.recommend,
  ];

  /// type ∈ {1,6,4}（點擊/推薦/鮮花）才顯示日/週/月週期（RankingActivity.java:468）。
  bool get showsPeriod =>
      this == RankingType.click ||
      this == RankingType.recommend ||
      this == RankingType.flower;

  /// type == 2（新書榜）才顯示新書排序（RankingActivity.java:464）。
  bool get showsNewBookSort => this == RankingType.newBook;
}

/// 榜單週期（`period`，RankingActivity.java:67,72）。
enum RankingPeriod {
  day('day', '日'),
  week('week', '週'),
  month('month', '月');

  const RankingPeriod(this.value, this.label);

  final String value;
  final String label;

  static const RankingPeriod defaultValue = RankingPeriod.week;
}

/// 書庫 / 標籤篩選排序（`GetNovelListRequest.sortBy`，doc 11 §5.1，值皆已驗證）。
/// [label] 為 App 自有繁體 UI 文案；[value] 為後端 wire 值（不轉換）。
enum NovelSortBy {
  postDate('最新入庫', 'postdate'),
  lastUpdate('最近更新', 'lastupdate'),
  weekVisit('週點擊', 'weekvisit'),
  monthVisit('月點擊', 'monthvisit'),
  weekVote('週推薦', 'weekvote'),
  monthVote('月推薦', 'monthvote'),
  goodNum('收藏數', 'goodnum'),
  words('字數', 'words');

  const NovelSortBy(this.label, this.value);

  final String label;
  final String value;

  /// 預設「最新入庫」（DEFAULT_SORT_BY，TagFilterActivity.java:49）。
  static const NovelSortBy defaultValue = NovelSortBy.postDate;
}

/// 新書榜專用排序（`sort`，RankingActivity.java:68,73）。
enum NewBookSort {
  latest('latest', '最新'),
  recommend('recommend', '推薦');

  const NewBookSort(this.value, this.label);

  final String value;
  final String label;

  static const NewBookSort defaultValue = NewBookSort.latest;
}
