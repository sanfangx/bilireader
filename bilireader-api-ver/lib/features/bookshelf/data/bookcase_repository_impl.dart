import 'package:dio/dio.dart';

import '../../../core/network/api_result.dart';
import '../../../core/network/app_error.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/text/chinese_converter.dart';
import '../domain/bookcase_options.dart';
import '../domain/bookcase_repository.dart';
import '../domain/bookshelf_entry.dart';
import 'bookcase_remote_data_source.dart';
import 'dto/bookshelf_item.dart';

/// [BookcaseRepository] 實作：呼叫 [BookcaseRemoteDataSource]，顯示文字轉繁（§5.0）。
/// 書架資料不快取（下拉即時反映收藏/移除）。
class BookcaseRepositoryImpl implements BookcaseRepository {
  BookcaseRepositoryImpl({
    required BookcaseRemoteDataSource remote,
    required ChineseConverter converter,
  }) : _remote = remote,
       _converter = converter;

  final BookcaseRemoteDataSource _remote;
  final ChineseConverter _converter;

  @override
  Future<ApiResult<List<BookshelfEntry>>> list({
    BookcaseClass classFilter = BookcaseClass.defaultFilter,
    BookshelfSort sort = BookshelfSort.defaultValue,
  }) => _guard(() async {
    final List<BookshelfItem> items = await _remote.list(
      classFilter: classFilter,
      sort: sort,
    );
    return items.map(_toEntry).toList();
  });

  @override
  Future<ApiResult<String>> add({
    required int articleId,
    required String articleName,
    BookcaseClass classFilter = BookcaseClass.defaultAdd,
    int? chapterId,
    String? chapterName,
    int? chapterOrder,
    int? pageId,
  }) => _guard(
    () => _remote.add(
      articleId: articleId,
      articleName: articleName,
      classId: classFilter.value,
      chapterId: chapterId,
      chapterName: chapterName,
      chapterOrder: chapterOrder,
      pageId: pageId,
    ),
  );

  @override
  Future<ApiResult<String>> delete(int caseId) =>
      _guard(() => _remote.delete(caseId));

  @override
  Future<ApiResult<String>> updateClass({
    required int caseId,
    required BookcaseClass classFilter,
  }) => _guard(
    () => _remote.updateClass(caseId: caseId, classId: classFilter.value),
  );

  @override
  Future<ApiResult<bool>> check(int articleId) =>
      _guard(() async => _inShelf(await _remote.check(articleId)));

  BookshelfEntry _toEntry(BookshelfItem e) => BookshelfEntry(
    caseId: e.caseid,
    articleId: e.articleid,
    title: _tw(e.articlename),
    author: _twNullable(e.author),
    coverUrl: e.poster,
    classId: e.classid,
    chapterId: e.chapterid,
    chapterName: _twNullable(e.chaptername),
    chapterOrder: e.chapterorder,
    progress: e.progress,
    lastVisit: e.lastvisit,
    lastUpdate: e.lastupdate,
    words: e.words,
  );

  /// `bookcase/check` 回傳 Map 語意原始碼未明確（doc 標「Map，是否已收藏等」）；
  /// 防禦性解讀：有正的 caseid 或任一「已收藏」旗標為真即視為已在書架。
  static bool _inShelf(Map<String, dynamic> data) {
    final Object? caseid = data['caseid'];
    if (caseid is num && caseid > 0) {
      return true;
    }
    for (final String k in <String>[
      'inBookcase',
      'incase',
      'isCase',
      'inShelf',
      'exist',
      'existed',
      'collected',
      'isCollect',
    ]) {
      final Object? v = data[k];
      if (v == true || (v is num && v != 0) || v == '1' || v == 'true') {
        return true;
      }
    }
    return false;
  }

  Future<ApiResult<T>> _guard<T>(Future<T> Function() body) async {
    try {
      await _converter.ensureLoaded();
      return ApiSuccess<T>(await body());
    } on DioException catch (e) {
      return ApiFailure<T>(ErrorMapper.fromDio(e));
    } on AppError catch (e) {
      return ApiFailure<T>(e);
    } on Object catch (e) {
      return ApiFailure<T>(ErrorMapper.parse(e));
    }
  }

  String _tw(String? text) =>
      (text == null || text.isEmpty) ? '' : _converter.toTraditionalTw(text);

  String? _twNullable(String? text) =>
      (text == null || text.isEmpty) ? text : _converter.toTraditionalTw(text);
}
