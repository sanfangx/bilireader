import 'package:html/parser.dart' as html_parser;

import '../app_config.dart';

/// 書評摘要（唯讀爬取自 `/reviews_{aid}_{page}.html`）。
///
/// ★星等/評分是 web（tw.linovelib）相對 api-ver 的優勢（api-ver 因缺欄位放棄書評）；
/// 此處先做唯讀列表，撰寫/回覆需 WebView 提交（follow-up）。
class BookReview {
  const BookReview({
    required this.id,
    required this.author,
    this.avatarUrl,
    this.timeText = '',
    this.likes = 0,
    this.replies = 0,
    this.preview = '',
    this.detailPath = '',
  });

  /// 書評 id（`reviewshow_{id}_1.html`）。
  final String id;
  final String author;

  /// 頭像絕對 URL（來源 `img.book-author-avatar` 的 data-src）。
  final String? avatarUrl;

  /// 顯示時間文字（站方原樣，如 `06-09 01:55`）。
  final String timeText;
  final int likes;
  final int replies;

  /// 內容預覽（站方列表為截斷文字，結尾常帶 `...`）。
  final String preview;

  /// 書評詳情相對路徑（`/reviewshow_{id}_{page}.html`）。
  final String detailPath;

  String get detailUrl => detailPath.isEmpty
      ? ''
      : (detailPath.startsWith('http')
            ? detailPath
            : '${AppConfig.origin}$detailPath');
}

/// 解析書評列表頁 HTML（`ol.book-ol-comment > li` / `#list_content > li`）。純函式、可測。
/// 選擇器對齊實測 DOM：作者 `.book-meta-l > em`、頭像 `img.book-author-avatar[data-src]`、
/// 時間 `.book-comment-time`、讚/回覆 `.book-meta-r`（「66/0」）、預覽 `.book-comment-p`、
/// 詳情連結 `a[href=/reviewshow_{id}_{page}.html]`。
List<BookReview> parseReviewList(String html) {
  final doc = html_parser.parse(html);
  final out = <BookReview>[];
  for (final li
      in doc.querySelectorAll('ol.book-ol-comment > li, #list_content > li')) {
    final href = li.querySelector('a')?.attributes['href'] ?? '';
    final id = RegExp(r'reviewshow_(\d+)_').firstMatch(href)?.group(1) ?? '';
    final img = li.querySelector('img.book-author-avatar');
    final avatar = img?.attributes['data-src'] ?? img?.attributes['src'];
    final author = li.querySelector('.book-meta-l > em')?.text.trim() ?? '';
    final time = li.querySelector('.book-comment-time')?.text.trim() ?? '';
    final metaR = li.querySelector('.book-meta-r')?.text.trim() ?? '';
    final m = RegExp(r'(\d+)\s*/\s*(\d+)').firstMatch(metaR);
    final preview = li.querySelector('.book-comment-p')?.text.trim() ?? '';
    if (id.isEmpty && author.isEmpty && preview.isEmpty) continue;
    out.add(BookReview(
      id: id,
      author: author,
      avatarUrl: avatar == null
          ? null
          : (avatar.startsWith('http')
              ? avatar
              : '${AppConfig.origin}$avatar'),
      timeText: time,
      likes: int.tryParse(m?.group(1) ?? '') ?? 0,
      replies: int.tryParse(m?.group(2) ?? '') ?? 0,
      preview: preview,
      detailPath: href,
    ));
  }
  return out;
}
