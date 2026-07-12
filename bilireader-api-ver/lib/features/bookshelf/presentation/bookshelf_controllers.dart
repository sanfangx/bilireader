import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_result.dart';
import '../data/bookshelf_providers.dart';
import '../domain/bookcase_options.dart';
import '../domain/bookshelf_entry.dart';

part 'bookshelf_controllers.g.dart';

/// 書架目前的分類篩選與排序（doc 11 §5.3、§6）。改變任一值會觸發清單重載。
typedef BookshelfQuery = ({BookcaseClass cls, BookshelfSort sort});

@riverpod
class BookshelfFilter extends _$BookshelfFilter {
  @override
  BookshelfQuery build() =>
      (cls: BookcaseClass.defaultFilter, sort: BookshelfSort.defaultValue);

  void setClass(BookcaseClass cls) {
    if (cls == state.cls) {
      return;
    }
    state = (cls: cls, sort: state.sort);
  }

  void setSort(BookshelfSort sort) {
    if (sort == state.sort) {
      return;
    }
    state = (cls: state.cls, sort: sort);
  }
}

/// 書架清單（`bookcase/list`，依 [bookshelfFilterProvider] 的分類 + 排序）。
/// 空清單為正常狀態；業務錯誤以 [AppError] 拋出交由頁面呈現。
@riverpod
Future<List<BookshelfEntry>> bookshelfList(Ref ref) async {
  final BookshelfQuery query = ref.watch(bookshelfFilterProvider);
  final ApiResult<List<BookshelfEntry>> result = await ref
      .watch(bookcaseRepositoryProvider)
      .list(classFilter: query.cls, sort: query.sort);
  return switch (result) {
    ApiSuccess<List<BookshelfEntry>>(:final List<BookshelfEntry> data) => data,
    ApiFailure<List<BookshelfEntry>>(:final error) => throw error,
  };
}

/// 書架異動（移除 / 變更分類）。皆為狀態變更端點（§7.0），僅供實際使用者操作，
/// 不做破壞性自動測試。成功後 invalidate 清單以重新載入。
@riverpod
class BookshelfMutations extends _$BookshelfMutations {
  @override
  void build() {}

  Future<ApiResult<String>> remove(int caseId) async {
    final ApiResult<String> result = await ref
        .read(bookcaseRepositoryProvider)
        .delete(caseId);
    if (result is ApiSuccess<String>) {
      ref.invalidate(bookshelfListProvider);
    }
    return result;
  }

  Future<ApiResult<String>> moveClass({
    required int caseId,
    required BookcaseClass cls,
  }) async {
    final ApiResult<String> result = await ref
        .read(bookcaseRepositoryProvider)
        .updateClass(caseId: caseId, classFilter: cls);
    if (result is ApiSuccess<String>) {
      ref.invalidate(bookshelfListProvider);
    }
    return result;
  }
}
