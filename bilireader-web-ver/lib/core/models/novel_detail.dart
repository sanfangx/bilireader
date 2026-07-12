import '../app_config.dart';

/// 書籍詳情。
class NovelDetail {
  const NovelDetail({
    required this.id,
    required this.title,
    this.author,
    this.coverPath,
    this.summary,
    this.score,
    this.wordCount,
    this.status,
    this.animated = false,
    this.lastUpdate,
    this.tags = const [],
    this.shelved = false,
  });

  final String id;
  final String title;
  final String? author;
  final String? coverPath;
  final String? summary;
  final String? score; // 例 "9.9"
  final String? wordCount; // 例 "707.6 萬字"
  final String? status; // 連載 / 完結
  final bool animated; // 已動畫化
  final String? lastUpdate;
  final List<String> tags;

  /// 已在書架（伺服器狀態）。解析自詳情頁收藏鈕：已收藏 `#a_delbookcase`、
  /// 未收藏 `#a_addbookcase`；未登入/解析不到 → false。
  final bool shelved;

  String? get coverUrl {
    final p = coverPath;
    if (p == null || p.isEmpty) return null;
    if (p.startsWith('http')) return p;
    if (p.startsWith('//')) return 'https:$p';
    return '${AppConfig.origin}$p';
  }

  String get catalogUrl => '${AppConfig.origin}/novel/$id/catalog';
}
