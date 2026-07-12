/// 書評排序（`book_review/list` 的 `sortBy`）。設計稿分段為「最新 / 最熱」。
///
/// 注意：doc 未列舉 `sortBy` 的實際 wire 值；此處以設計稿標籤的英文語意推得
/// `latest` / `hot`（與圈子 `category=latest` 慣例一致）。若伺服器不識別，會退回
/// 預設排序（不致錯誤資料）。預設「最新」。
enum BookReviewSort {
  latest('latest', '最新'),
  hot('hot', '最熱');

  const BookReviewSort(this.value, this.label);

  final String value;
  final String label;

  static const BookReviewSort defaultValue = BookReviewSort.latest;
}
