import 'package:bilireader/core/network/api_result.dart';
import 'package:bilireader/features/discover/domain/book_repository.dart';
import 'package:bilireader/features/discover/domain/carousel_slide.dart';
import 'package:bilireader/features/discover/domain/novel_summary.dart';
import 'package:bilireader/features/discover/domain/ranking_options.dart';

/// 測試用 [BookRepository]：所有端點回傳空成功結果，讓書城首頁在 widget/golden 測試
/// 中不觸網、以確定性空狀態渲染。
class FakeBookRepository implements BookRepository {
  const FakeBookRepository();

  @override
  Future<ApiResult<List<CarouselSlide>>> carousel() async =>
      const ApiSuccess<List<CarouselSlide>>(<CarouselSlide>[]);

  @override
  Future<ApiResult<List<NovelSummary>>> ranking({
    required RankingType type,
    RankingPeriod? period,
    NewBookSort? sort,
    int page = 1,
    int limit = 20,
  }) async => const ApiSuccess<List<NovelSummary>>(<NovelSummary>[]);

  @override
  Future<ApiResult<List<NovelSummary>>> weekHot({
    int page = 1,
    int limit = 12,
  }) async => const ApiSuccess<List<NovelSummary>>(<NovelSummary>[]);

  @override
  Future<ApiResult<NovelSummary>> novelDetail(
    int articleId, {
    bool countVisit = true,
  }) async =>
      const ApiSuccess<NovelSummary>(NovelSummary(articleId: 0, title: ''));

  @override
  Future<ApiResult<List<NovelSummary>>> sameAuthor(int articleId) async =>
      const ApiSuccess<List<NovelSummary>>(<NovelSummary>[]);

  @override
  Future<ApiResult<List<NovelSummary>>> sameTranslator(int articleId) async =>
      const ApiSuccess<List<NovelSummary>>(<NovelSummary>[]);

  @override
  Future<ApiResult<List<NovelSummary>>> alsoReading(int articleId) async =>
      const ApiSuccess<List<NovelSummary>>(<NovelSummary>[]);

  @override
  Future<ApiResult<List<String>>> hotSearch({int limit = 12}) async =>
      const ApiSuccess<List<String>>(<String>[]);

  @override
  Future<ApiResult<List<String>>> tags() async =>
      const ApiSuccess<List<String>>(<String>[]);
}
