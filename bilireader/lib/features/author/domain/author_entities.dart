import 'package:flutter/foundation.dart';

/// 作者作品（`author/novel/list` 的 `NovelResponseEntity`，顯示文字已轉繁 §5.0）。
///
/// 依實際回應欄位呈現：狀態由 [isFinished]（fullflag）推得，字數 [words]，
/// 推薦票 [voteCount]（allvote）、鮮花 [flowerCount]（allflower）。清單端點不含
/// 「章數 / 收藏數」，故不虛構（§No Mock Data）；章數於進入章節樹後由 flat 計得。
@immutable
class AuthorNovel {
  const AuthorNovel({
    required this.articleId,
    required this.title,
    this.coverUrl,
    this.intro,
    this.keywords,
    this.isFinished = false,
    this.progress = 0,
    this.rGroup = 0,
    this.fullFlag = 0,
    this.words = 0,
    this.voteCount = 0,
    this.flowerCount = 0,
    this.goodNum = 0,
    this.totalVisits = 0,
  });

  final int articleId;
  final String title;
  final String? coverUrl;
  final String? intro;
  final String? keywords;
  final bool isFinished;
  final int progress;
  final int rGroup;
  final int fullFlag;
  final int words;
  final int voteCount;
  final int flowerCount;
  final int goodNum;
  final int totalVisits;

  /// 狀態標籤（連載中 / 已完結）。
  String get statusLabel => isFinished ? '已完結' : '連載中';
}

/// 作者章節樹（`author/chapter/tree`）：卷 [volumes] + 扁平章節 [flat]。
@immutable
class AuthorChapterTree {
  const AuthorChapterTree({
    required this.articleId,
    required this.articleName,
    this.volumes = const <AuthorVolume>[],
    this.flat = const <AuthorChapter>[],
  });

  final int articleId;
  final String articleName;
  final List<AuthorVolume> volumes;
  final List<AuthorChapter> flat;

  /// 依卷分組（用卷名對照 [volumes]；未知卷名者以 volumeId 分組保留原順序）。
  List<AuthorVolumeChapters> get grouped {
    final Map<int, String> names = <int, String>{
      for (final AuthorVolume v in volumes) v.volumeId: v.volumeName,
    };
    final List<AuthorVolumeChapters> out = <AuthorVolumeChapters>[];
    final Map<int, int> indexOf = <int, int>{};
    for (final AuthorChapter c in flat) {
      final int? at = indexOf[c.volumeId];
      if (at == null) {
        indexOf[c.volumeId] = out.length;
        out.add(
          AuthorVolumeChapters(
            volumeId: c.volumeId,
            volumeName: names[c.volumeId] ?? '',
            chapters: <AuthorChapter>[c],
          ),
        );
      } else {
        out[at].chapters.add(c);
      }
    }
    return out;
  }
}

/// 卷（volumeId + 顯示名，已轉繁）。
@immutable
class AuthorVolume {
  const AuthorVolume({required this.volumeId, required this.volumeName});

  final int volumeId;
  final String volumeName;
}

/// 卷 + 其章節（[AuthorChapterTree.grouped] 產物）。
@immutable
class AuthorVolumeChapters {
  const AuthorVolumeChapters({
    required this.volumeId,
    required this.volumeName,
    required this.chapters,
  });

  final int volumeId;
  final String volumeName;
  final List<AuthorChapter> chapters;
}

/// 作者章節列（`AuthorChapterRow`，已轉繁）。
@immutable
class AuthorChapter {
  const AuthorChapter({
    required this.chapterId,
    required this.articleId,
    required this.volumeId,
    required this.chapterName,
    this.chapterOrder = 0,
    this.chapterType = 0,
    this.words = 0,
  });

  final int chapterId;
  final int articleId;
  final int volumeId;
  final String chapterName;
  final int chapterOrder;
  final int chapterType;
  final int words;
}

/// 作者端章節正文（`author/chapter/text`，已轉繁）。
@immutable
class AuthorChapterText {
  const AuthorChapterText({
    required this.articleId,
    required this.chapterId,
    required this.chapterName,
    required this.text,
    this.isBody = 1,
  });

  final int articleId;
  final int chapterId;
  final String chapterName;
  final String text;
  final int isBody;
}

/// 草稿（`AuthorDraftItem`，已轉繁）。
@immutable
class AuthorDraft {
  const AuthorDraft({
    required this.draftId,
    required this.articleId,
    required this.volumeId,
    required this.chapterName,
    this.chapterContent = '',
    this.words = 0,
    this.lastUpdate = 0,
    this.isPub = false,
    this.isBody = 1,
  });

  final int draftId;
  final int articleId;
  final int volumeId;
  final String chapterName;
  final String chapterContent;
  final int words;
  final int lastUpdate;
  final bool isPub;
  final int isBody;
}

/// 插圖上傳結果（`ChapterAttachUploadData`）。[insertHtml]/[insertToken] 用於把
/// 圖片插入正文（伺服器產生的佔位與權杖，不可自造）。
@immutable
class ChapterAttachResult {
  const ChapterAttachResult({
    required this.attachId,
    this.previewUrl,
    this.insertHtml,
    this.insertToken,
    this.fileName,
    this.size = 0,
  });

  final int attachId;
  final String? previewUrl;
  final String? insertHtml;
  final String? insertToken;
  final String? fileName;
  final int size;
}
