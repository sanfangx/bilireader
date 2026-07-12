/// tw.linovelib.com 書架的**網站原生固定分組**（classid）。
///
/// 實地確認自 `bookcase.php` 的 `select[name=classlist]`（2026-07-12 真實 Chrome）：
/// 書架列表 `GET /bookcase.php?classid={0-5}&sortorder=`；指派分組
/// `POST addbookcase.php` body `checkid&newclassid&act=move`。classid 0 為預設組。
enum ShelfClass {
  reading(0, '正在閱讀'),
  watching(1, '新書關注'),
  later(2, '以後再看'),
  finished(3, '已經看完'),
  dropped(4, '看不下去'),
  classic(5, '經典作品');

  const ShelfClass(this.classid, this.label);

  /// 網站 classid（0-5）。
  final int classid;

  /// 顯示名稱。
  final String label;

  static ShelfClass fromClassid(int id) =>
      ShelfClass.values.firstWhere((c) => c.classid == id,
          orElse: () => ShelfClass.reading);
}

/// 書架排序（對應 `sortorder` 參數）。
enum ShelfSort {
  lastUpdate('lastupdate', '最近更新'),
  joinDate('joindate', '最近收藏');

  const ShelfSort(this.wire, this.label);
  final String wire;
  final String label;
}
