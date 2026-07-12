import 'package:flutter/foundation.dart';

import '../../../core/social/reaction.dart';

/// 章節評論（顯示用；文字已轉繁，§5.0）。無設計稿——presentation 為閱讀器內嵌面板，
/// 隨 Phase 5 閱讀器建置（本階段僅 data/domain）。`addtime` 為伺服器字串（非秒級 int）。
@immutable
class ChapterComment {
  const ChapterComment({
    required this.commentId,
    required this.content,
    required this.commenterName,
    this.commenterLevel,
    this.avatarUrl,
    this.likeNum = 0,
    this.badNum = 0,
    this.myReaction = Reaction.none,
    this.addtime,
    this.isSpoiler = false,
    this.isHot = false,
    this.parentId = 0,
  });

  final int commentId;
  final String content;
  final String commenterName;
  final String? commenterLevel;
  final String? avatarUrl;
  final int likeNum;
  final int badNum;
  final Reaction myReaction;

  /// 伺服器提供的顯示時間字串（例：日期）；非數值時間戳。
  final String? addtime;
  final bool isSpoiler;
  final bool isHot;

  /// 樓層/父留言（0 = 頂層）。
  final int parentId;
}

/// 一頁章節評論。
@immutable
class ChapterCommentPage {
  const ChapterCommentPage({
    required this.comments,
    required this.pageNum,
    required this.pages,
    required this.total,
  });

  final List<ChapterComment> comments;
  final int pageNum;
  final int pages;
  final int total;

  bool get hasMore => pageNum < pages;
}
