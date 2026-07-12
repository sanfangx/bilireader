import 'package:html/parser.dart' as html_parser;

import '../app_config.dart';

/// 圈子貼文摘要（唯讀爬取自 `/alltopics`）。與書評同一 DOM 家族，另有標題與分類。
class Topic {
  const Topic({
    required this.id,
    required this.title,
    this.avatarUrl,
    this.meta = '',
    this.likes = 0,
    this.replies = 0,
    this.preview = '',
    this.detailUrl = '',
  });

  /// 貼文 id（`showtopic/{id}_{page}`）。
  final String id;
  final String title;
  final String? avatarUrl;

  /// 分類 + 時間（站方原樣，如「生活雜談 | 07-10 16:06」）。
  final String meta;
  final int likes;
  final int replies;
  final String preview;

  /// 貼文詳情絕對 URL。
  final String detailUrl;
}

/// 解析圈子列表 HTML（`ol.book-ol-comment > li`）。純函式、可測。
/// 標題 `h4.book-title`、頭像 `img.book-author-avatar`（data-src ?? src）、分類/時間
/// `.book-author`、讚/回覆 `.book-meta-r .tag-small`（「41/1」）、預覽 `.book-comment-p`、
/// 詳情連結 `a[href*=/showtopic/{id}_{page}]`。
List<Topic> parseTopicList(String html) {
  final doc = html_parser.parse(html);
  final out = <Topic>[];
  for (final li
      in doc.querySelectorAll('ol.book-ol-comment > li, #list_content > li')) {
    final href = li.querySelector('a')?.attributes['href'] ?? '';
    final id = RegExp(r'showtopic/(\d+)').firstMatch(href)?.group(1) ?? '';
    final title = li.querySelector('.book-title')?.text.trim() ?? '';
    final img = li.querySelector('img.book-author-avatar');
    final avatar = img?.attributes['data-src'] ?? img?.attributes['src'];
    final meta = li.querySelector('.book-author')?.text.trim() ?? '';
    final tag = li.querySelector('.book-meta-r .tag-small')?.text.trim() ??
        li.querySelector('.book-meta-r')?.text.trim() ??
        '';
    final m = RegExp(r'(\d+)\s*/\s*(\d+)').firstMatch(tag);
    final preview = li.querySelector('.book-comment-p')?.text.trim() ?? '';
    if (id.isEmpty && title.isEmpty && preview.isEmpty) continue;
    out.add(Topic(
      id: id,
      title: title,
      avatarUrl: avatar == null
          ? null
          : (avatar.startsWith('http')
              ? avatar
              : '${AppConfig.origin}$avatar'),
      meta: meta,
      likes: int.tryParse(m?.group(1) ?? '') ?? 0,
      replies: int.tryParse(m?.group(2) ?? '') ?? 0,
      preview: preview,
      detailUrl: href.startsWith('http')
          ? href
          : (href.isEmpty ? '' : '${AppConfig.origin}$href'),
    ));
  }
  return out;
}
