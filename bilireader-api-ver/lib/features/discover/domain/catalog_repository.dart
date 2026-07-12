import '../../../core/network/api_result.dart';
import 'novel_catalog.dart';

/// 章節目錄 repository 介面（規範 §4.2）。卷/章名已於實作層轉繁（§5.0）。
abstract interface class CatalogRepository {
  /// 取章節目錄（`novel/getchapter`，Body `articleid`）。
  Future<ApiResult<NovelCatalog>> catalog(int articleId);
}
