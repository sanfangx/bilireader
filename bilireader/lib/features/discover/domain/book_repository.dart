import '../../../core/network/api_result.dart';
import 'carousel_slide.dart';
import 'novel_summary.dart';
import 'ranking_options.dart';

/// 書城首頁 / 榜單 / 詳情 / 推薦 repository 介面（規範 §4.2）。
///
/// 所有回傳的顯示文字（書名、作者、簡介、標籤、輪播描述、熱門詞）皆已於
/// 實作層經 OpenCC 轉繁（§5.0）。列表類端點用 `page`/`limit`（由 1 起）。
abstract interface class BookRepository {
  /// 首頁輪播 Banner（`novel/getCarousel`）。
  Future<ApiResult<List<CarouselSlide>>> carousel();

  /// 榜單（`novel/getRanking`）。[period]/[sort] 依 [type] 需要而定（見 [RankingType]）。
  Future<ApiResult<List<NovelSummary>>> ranking({
    required RankingType type,
    RankingPeriod? period,
    NewBookSort? sort,
    int page,
    int limit,
  });

  /// 本週熱門（`novel/getweekhot`）。
  Future<ApiResult<List<NovelSummary>>> weekHot({int page, int limit});

  /// 小說詳情（`novel/getNovelInfo`，[countVisit] 計瀏覽）。
  Future<ApiResult<NovelSummary>> novelDetail(int articleId, {bool countVisit});

  /// 同作者作品（`novel/sameAuthor`）。
  Future<ApiResult<List<NovelSummary>>> sameAuthor(int articleId);

  /// 同譯者作品（`novel/sameTranslator`）。
  Future<ApiResult<List<NovelSummary>>> sameTranslator(int articleId);

  /// 也在看推薦（`novel/alsoReading`）。
  Future<ApiResult<List<NovelSummary>>> alsoReading(int articleId);

  /// 熱門搜尋關鍵字（`novel/hotSearch`）。
  Future<ApiResult<List<String>>> hotSearch({int limit});

  /// 所有可用標籤（`novel/tags`）。
  Future<ApiResult<List<String>>> tags();
}
