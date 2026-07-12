import 'package:flutter/foundation.dart';

/// 書架條目 domain entity（規範 §4.3）。顯示文字（[title]/[author]/[chapterName]）
/// 已於 data 層經 OpenCC 轉繁（§5.0）。[caseId] 為刪除 / 變更分類的主鍵。
@immutable
class BookshelfEntry {
  const BookshelfEntry({
    required this.caseId,
    required this.articleId,
    required this.title,
    this.author,
    this.coverUrl,
    this.classId = 0,
    this.chapterId = 0,
    this.chapterName,
    this.chapterOrder = 0,
    this.progress = 0,
    this.lastVisit = 0,
    this.lastUpdate = 0,
    this.words = 0,
  });

  final int caseId;
  final int articleId;
  final String title;
  final String? author;
  final String? coverUrl;
  final int classId;

  /// 進度章節（server 端書架進度）。
  final int chapterId;
  final String? chapterName;
  final int chapterOrder;

  /// 章內進度百分比 0-100。
  final int progress;

  // 秒級時間戳。
  final int lastVisit;
  final int lastUpdate;
  final int words;

  /// 進度比例 0.0-1.0（供進度條）。
  double get progressRatio => (progress.clamp(0, 100)) / 100;
}
