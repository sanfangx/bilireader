/// 書架分類 / 排序選項（doc 11 §5.3、§6，值皆已驗證）。
/// [label] 為 App 自有繁體 UI 文案（不經 OpenCC）；[value] 為後端 wire 值。
library;

/// 書架分類（`classid`，doc 11 §6 `CLASS_NAMES`，index == classid）。
/// -1=全部（僅篩選用）；0-5 為實際分類。加入書架預設 0「正在閱讀」。
enum BookcaseClass {
  all(-1, '全部'),
  reading(0, '正在閱讀'),
  following(1, '新書關注'),
  later(2, '以後再看'),
  finished(3, '已經看完'),
  dropped(4, '看不下去'),
  classic(5, '經典作品');

  const BookcaseClass(this.value, this.label);

  final int value;
  final String label;

  /// 書架預設篩選 = 全部（BookshelfFragment.java:182）。
  static const BookcaseClass defaultFilter = BookcaseClass.all;

  /// 加入書架預設分類 = 正在閱讀（AddBookcaseRequest classid 預設 0）。
  static const BookcaseClass defaultAdd = BookcaseClass.reading;

  /// 由 classid 取顯示名（越界退回「正在閱讀」，doc 11 getDisplayName）。
  static String displayName(int classid) {
    for (final BookcaseClass c in BookcaseClass.values) {
      if (c.value == classid) {
        return c.label;
      }
    }
    return BookcaseClass.reading.label;
  }
}

/// 書架排序（`sortorder`，doc 11 §5.3，本地排序字串）。
enum BookshelfSort {
  lastUpdate('lastupdate', '最後更新'),
  joinDate('joindate', '最近收藏'),
  lastVisit('lastvisit', '最近閱讀');

  const BookshelfSort(this.value, this.label);

  final String value;
  final String label;

  /// 預設「最後更新」（currentSortorder，BookshelfFragment.java:183）。
  static const BookshelfSort defaultValue = BookshelfSort.lastUpdate;
}
