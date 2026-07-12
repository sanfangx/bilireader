import '../app_config.dart';

/// 章節。
class Chapter {
  const Chapter({
    required this.title,
    this.url,
    this.vip = false,
    this.volumeName,
  });

  final String title;
  final String? url; // 絕對 URL；javascript: / 空 → null
  final bool vip;

  /// 所屬卷名。攤平 [Catalog] 成單一清單（供閱讀器 index-based 導覽）時貼上，
  /// 讓閱讀器內建目錄仍能依卷分組顯示。**不參與 toJson/fromJson**——卷名由
  /// [Volume] 持有，drift 快取還原後重新 [Catalog.flattened] 即帶回。
  final String? volumeName;

  String? get id {
    final u = url;
    if (u == null) return null;
    return RegExp(r'/novel/\d+/(\d+)(?:_\d+)?\.html').firstMatch(u)?.group(1);
  }

  Map<String, dynamic> toJson() => {
        't': title,
        if (url != null) 'u': url,
        if (vip) 'v': 1,
      };

  static Chapter fromJson(Map<String, dynamic> j) => Chapter(
        title: j['t'] as String? ?? '',
        url: j['u'] as String?,
        vip: (j['v'] as int? ?? 0) == 1,
      );
}

/// 卷。
class Volume {
  Volume({required this.name, this.coverPath, List<Chapter>? chapters})
      : chapters = chapters ?? [];

  final String name;
  String? coverPath;
  final List<Chapter> chapters;

  String? get coverUrl {
    final p = coverPath;
    if (p == null || p.isEmpty) return null;
    if (p.startsWith('http')) return p;
    if (p.startsWith('//')) return 'https:$p';
    return '${AppConfig.origin}$p';
  }

  Map<String, dynamic> toJson() => {
        'n': name,
        if (coverPath != null) 'cp': coverPath,
        'c': chapters.map((e) => e.toJson()).toList(),
      };

  static Volume fromJson(Map<String, dynamic> j) => Volume(
        name: j['n'] as String? ?? '',
        coverPath: j['cp'] as String?,
        chapters: (j['c'] as List? ?? const [])
            .map((e) => Chapter.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

/// 目錄。
class Catalog {
  const Catalog({required this.volumes});
  final List<Volume> volumes;

  int get chapterCount =>
      volumes.fold(0, (sum, v) => sum + v.chapters.length);

  /// 攤平成全書閱讀順序的單一章節清單，每章貼上所屬卷名（[Chapter.volumeName]），
  /// 供閱讀器收單一清單、內建目錄仍能分卷。每章為帶卷名的新實例，故呼叫端不可再
  /// 依 identity（`indexOf`）反查原始 [Volume.chapters]，改以位置累加計算攤平索引。
  List<Chapter> flattened() => <Chapter>[
        for (final Volume v in volumes)
          for (final Chapter c in v.chapters)
            Chapter(
              title: c.title,
              url: c.url,
              vip: c.vip,
              volumeName: v.name.isEmpty ? null : v.name,
            ),
      ];

  Map<String, dynamic> toJson() =>
      {'vol': volumes.map((e) => e.toJson()).toList()};

  static Catalog fromJson(Map<String, dynamic> j) => Catalog(
        volumes: (j['vol'] as List? ?? const [])
            .map((e) => Volume.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
