import 'package:bilireader/features/bookshelf/domain/bookcase_options.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookcaseClass', () {
    test('classid 值對映 index（0-5）＋全部 -1', () {
      expect(BookcaseClass.all.value, -1);
      expect(BookcaseClass.reading.value, 0);
      expect(BookcaseClass.following.value, 1);
      expect(BookcaseClass.later.value, 2);
      expect(BookcaseClass.finished.value, 3);
      expect(BookcaseClass.dropped.value, 4);
      expect(BookcaseClass.classic.value, 5);
    });

    test('預設篩選＝全部、加入預設＝正在閱讀', () {
      expect(BookcaseClass.defaultFilter, BookcaseClass.all);
      expect(BookcaseClass.defaultAdd, BookcaseClass.reading);
    });

    test('displayName：越界退回「正在閱讀」', () {
      expect(BookcaseClass.displayName(3), '已經看完');
      expect(BookcaseClass.displayName(99), '正在閱讀');
      expect(BookcaseClass.displayName(-1), '全部');
    });
  });

  group('BookshelfSort', () {
    test('wire 值與預設', () {
      expect(BookshelfSort.lastUpdate.value, 'lastupdate');
      expect(BookshelfSort.joinDate.value, 'joindate');
      expect(BookshelfSort.lastVisit.value, 'lastvisit');
      expect(BookshelfSort.defaultValue, BookshelfSort.lastUpdate);
    });
  });
}
