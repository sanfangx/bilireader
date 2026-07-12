import 'package:bilireader_app/core/models/shelf_class.dart';
import 'package:flutter_test/flutter_test.dart';

/// 書架伺服器分組（classid）契約——對映需與 tw.linovelib.com 原生 classlist 一致。
void main() {
  test('ShelfClass classid ↔ label 對映（實地確認自 bookcase.php）', () {
    expect(ShelfClass.values.length, 6);
    expect(ShelfClass.reading.classid, 0);
    expect(ShelfClass.reading.label, '正在閱讀');
    expect(ShelfClass.watching.classid, 1);
    expect(ShelfClass.watching.label, '新書關注');
    expect(ShelfClass.later.classid, 2);
    expect(ShelfClass.later.label, '以後再看');
    expect(ShelfClass.finished.classid, 3);
    expect(ShelfClass.finished.label, '已經看完');
    expect(ShelfClass.dropped.classid, 4);
    expect(ShelfClass.dropped.label, '看不下去');
    expect(ShelfClass.classic.classid, 5);
    expect(ShelfClass.classic.label, '經典作品');
    // classid 連續 0..5
    expect(ShelfClass.values.map((e) => e.classid).toList(),
        [0, 1, 2, 3, 4, 5]);
  });

  test('fromClassid 反查；未知 → 預設 reading', () {
    expect(ShelfClass.fromClassid(3), ShelfClass.finished);
    expect(ShelfClass.fromClassid(99), ShelfClass.reading);
  });

  test('ShelfSort wire 值對映 sortorder 參數', () {
    expect(ShelfSort.lastUpdate.wire, 'lastupdate');
    expect(ShelfSort.joinDate.wire, 'joindate');
  });
}
