import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../core/network/api_result.dart';
import '../../../core/network/app_error.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/storage/database/app_database.dart';
import '../../../core/storage/in_flight_deduper.dart';
import '../../../core/text/chinese_converter.dart';
import '../domain/catalog_repository.dart';
import '../domain/novel_catalog.dart';
import 'catalog_remote_data_source.dart';
import 'dto/chapter_data.dart';
import 'novel_mapper.dart';

/// [CatalogRepository] 實作：目錄走 `novel_read_cache.db` **永久快取**（規範 §7.5），
/// 快取未命中才打網路；並以 in-flight dedupe 合併同書並發請求（§7.5）。
/// 顯示卷/章名由 [NovelMapper] 轉繁（§5.0）。
class CatalogRepositoryImpl implements CatalogRepository {
  CatalogRepositoryImpl({
    required CatalogRemoteDataSource remote,
    required ChapterCacheDao cacheDao,
    required ChineseConverter converter,
    int Function()? clockMs,
  }) : _remote = remote,
       _cacheDao = cacheDao,
       _mapper = NovelMapper(converter),
       _converter = converter,
       _clockMs = clockMs;

  final CatalogRemoteDataSource _remote;
  final ChapterCacheDao _cacheDao;
  final NovelMapper _mapper;
  final ChineseConverter _converter;
  final int Function()? _clockMs;

  final InFlightDeduper<int, ChapterData> _dedupe =
      InFlightDeduper<int, ChapterData>();

  @override
  Future<ApiResult<NovelCatalog>> catalog(int articleId) async {
    try {
      await _converter.ensureLoaded();

      // 1. 永久快取（drift）優先。
      final ChapterCatalogRow? row = await _cacheDao.getCatalog(articleId);
      if (row != null) {
        final ChapterData cached = ChapterData.fromJson(
          jsonDecode(row.payload) as Map<String, dynamic>,
        );
        return ApiSuccess<NovelCatalog>(_mapper.toCatalog(cached));
      }

      // 2. 網路（dedupe 同書並發），成功即寫入永久快取。
      final ChapterData data = await _dedupe.run(
        articleId,
        () => _remote.getChapterCatalog(articleId),
      );
      await _cacheDao.saveCatalog(
        articleId: articleId,
        articleName: data.articlename ?? '',
        payload: jsonEncode(data.toJson()),
        updatedAt: _now(),
      );
      return ApiSuccess<NovelCatalog>(_mapper.toCatalog(data));
    } on DioException catch (e) {
      return ApiFailure<NovelCatalog>(ErrorMapper.fromDio(e));
    } on AppError catch (e) {
      return ApiFailure<NovelCatalog>(e);
    } on Object catch (e) {
      return ApiFailure<NovelCatalog>(ErrorMapper.parse(e));
    }
  }

  int _now() => _clockMs?.call() ?? DateTime.now().millisecondsSinceEpoch;
}
