import '../chapter_extractor.dart';
import '../content_block.dart';

/// 章節內容來源抽象：由章節 URL 取回擷取後的 [ChapterContent]。
///
/// 抽象化以便倉儲單元測試（可注入假來源）與正式 WebView 擷取解耦 —— 對應 api-ver 的
/// `ChapterTextRemoteDataSource`（唯內容源從 readpai getNovelText 換成 WebView 擷取）。
abstract class ChapterContentSource {
  Future<ChapterContent> load(String url);
}

/// 正式來源：以 [ChapterExtractor]（無頭 WebView + chapterlog.js 還原 + #acontent 擷取）載入。
class WebViewChapterContentSource implements ChapterContentSource {
  const WebViewChapterContentSource();

  @override
  Future<ChapterContent> load(String url) => ChapterExtractor().load(url);
}
