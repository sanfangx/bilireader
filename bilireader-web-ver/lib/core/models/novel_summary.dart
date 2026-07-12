import '../app_config.dart';

/// 書目摘要（列表/排行/書架卡片用）。
class NovelSummary {
  const NovelSummary({
    required this.id,
    required this.title,
    this.author,
    this.coverPath,
    this.intro,
    this.rank,
    this.tags = const [],
  });

  final String id;
  final String title;
  final String? author;
  final String? coverPath; // 相對 /files/... 或絕對 URL
  final String? intro;
  final int? rank;
  final List<String> tags;

  String? get coverUrl {
    final p = coverPath;
    if (p == null || p.isEmpty) return null;
    if (p.startsWith('http')) return p;
    if (p.startsWith('//')) return 'https:$p';
    return '${AppConfig.origin}$p';
  }

  String get infoUrl => '${AppConfig.origin}/novel/$id.html';
}
