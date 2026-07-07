import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../core/network/api_result.dart';
import '../../../core/network/app_error.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/network/image_headers.dart';
import '../../../core/storage/database/app_database.dart';
import '../../../core/storage/in_flight_deduper.dart';
import '../domain/chapter_text.dart';
import '../domain/chapter_text_repository.dart';
import 'chapter_text_remote_data_source.dart';
import 'dto/text_request_entity.dart';

/// [ChapterTextRepository] 實作：`novel_chapter_content` 永久快取優先（§7.5），未命中才
/// 打網路並寫回；in-flight dedupe 合併同章並發。快取**存原文**；OpenCC 於顯示層依設定套用。
/// 插圖 URL 於映射時做 img3→img2/attachment 改寫（[ImageHeaders]）。
class ChapterTextRepositoryImpl implements ChapterTextRepository {
  ChapterTextRepositoryImpl({
    required ChapterTextRemoteDataSource remote,
    required ChapterCacheDao cacheDao,
    int Function()? clockMs,
  }) : _remote = remote,
       _cacheDao = cacheDao,
       _clockMs = clockMs;

  final ChapterTextRemoteDataSource _remote;
  final ChapterCacheDao _cacheDao;
  final int Function()? _clockMs;

  final InFlightDeduper<String, TextRequestEntity> _dedupe =
      InFlightDeduper<String, TextRequestEntity>();

  @override
  Future<ApiResult<ChapterText>> getChapterText({
    required int articleId,
    required int chapterId,
  }) async {
    try {
      final TextRequestEntity dto = await _load(
        articleId: articleId,
        chapterId: chapterId,
      );
      return ApiSuccess<ChapterText>(_toDomain(dto));
    } on DioException catch (e) {
      return ApiFailure<ChapterText>(ErrorMapper.fromDio(e));
    } on AppError catch (e) {
      return ApiFailure<ChapterText>(e);
    } on Object catch (e) {
      return ApiFailure<ChapterText>(ErrorMapper.parse(e));
    }
  }

  @override
  Future<ApiResult<void>> downloadChapter({
    required int articleId,
    required int chapterId,
  }) async {
    try {
      if (await isCached(articleId: articleId, chapterId: chapterId)) {
        return const ApiSuccess<void>(null);
      }
      await _fetchAndCache(articleId: articleId, chapterId: chapterId);
      return const ApiSuccess<void>(null);
    } on DioException catch (e) {
      return ApiFailure<void>(ErrorMapper.fromDio(e));
    } on AppError catch (e) {
      return ApiFailure<void>(e);
    } on Object catch (e) {
      return ApiFailure<void>(ErrorMapper.parse(e));
    }
  }

  @override
  Future<bool> isCached({
    required int articleId,
    required int chapterId,
  }) async {
    final ChapterContentRow? row = await _cacheDao.getChapterContent(
      articleId,
      chapterId,
    );
    return row != null;
  }

  /// 永久快取優先；未命中打網路（dedupe）並寫回。
  Future<TextRequestEntity> _load({
    required int articleId,
    required int chapterId,
  }) async {
    final ChapterContentRow? row = await _cacheDao.getChapterContent(
      articleId,
      chapterId,
    );
    if (row != null) {
      return TextRequestEntity.fromJson(
        jsonDecode(row.payload) as Map<String, dynamic>,
      );
    }
    return _fetchAndCache(articleId: articleId, chapterId: chapterId);
  }

  Future<TextRequestEntity> _fetchAndCache({
    required int articleId,
    required int chapterId,
  }) {
    return _dedupe.run('$articleId:$chapterId', () async {
      final TextRequestEntity dto = await _remote.getNovelText(
        articleId: articleId,
        chapterId: chapterId,
      );
      await _cacheDao.saveChapterContent(
        articleId: articleId,
        chapterId: chapterId,
        payload: jsonEncode(dto.toJson()), // 存原文
        updatedAt: _now(),
      );
      return dto;
    });
  }

  ChapterText _toDomain(TextRequestEntity d) => ChapterText(
    articleId: d.articleId,
    chapterId: d.chapterId,
    chapterName: d.chapterName ?? '',
    text: d.text ?? '',
    images: d.images
        .map(
          (ChapterImageDto p) => ChapterImage(
            url: ImageHeaders.rewriteCdn(p.path ?? ''),
            aspectRatio: p.aspectRatio,
          ),
        )
        .toList(),
    isImage: d.isImage,
    isbody: d.isbody,
  );

  int _now() => _clockMs?.call() ?? DateTime.now().millisecondsSinceEpoch;
}
