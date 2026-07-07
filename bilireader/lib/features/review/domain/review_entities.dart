import 'package:flutter/foundation.dart';

import '../../../core/social/reaction.dart';

/// 書評（顯示用；文字已轉繁，§5.0）。BookReviewItem 無每則評分，故不含星等。
@immutable
class BookReview {
  const BookReview({
    required this.topicId,
    required this.content,
    required this.authorName,
    this.title,
    this.authorLevel,
    this.avatarUrl,
    this.likeNum = 0,
    this.badNum = 0,
    this.myReaction = Reaction.none,
    this.replies = 0,
    this.posttime = 0,
    this.isSpoiler = false,
    this.isGood = false,
    this.isTop = false,
  });

  final int topicId;
  final String content;
  final String authorName;
  final String? title;
  final String? authorLevel;
  final String? avatarUrl;
  final int likeNum;
  final int badNum;
  final Reaction myReaction;
  final int replies;
  final int posttime;
  final bool isSpoiler;
  final bool isGood;
  final bool isTop;

  /// 更新讚/倒讚/回覆數（跨頁同步用；其餘欄位不變）。供書評列表單筆 upsert，避免整列重抓
  /// 而重置捲動/已載分頁（UX F-07，體驗不變量#1）。
  BookReview copyWith({
    int? likeNum,
    int? badNum,
    Reaction? myReaction,
    int? replies,
  }) => BookReview(
    topicId: topicId,
    content: content,
    authorName: authorName,
    title: title,
    authorLevel: authorLevel,
    avatarUrl: avatarUrl,
    likeNum: likeNum ?? this.likeNum,
    badNum: badNum ?? this.badNum,
    myReaction: myReaction ?? this.myReaction,
    replies: replies ?? this.replies,
    posttime: posttime,
    isSpoiler: isSpoiler,
    isGood: isGood,
    isTop: isTop,
  );
}

/// 書評回覆。
@immutable
class BookReviewReply {
  const BookReviewReply({
    required this.postId,
    required this.posttext,
    required this.posterName,
    this.posterLevel,
    this.avatarUrl,
    this.likeNum = 0,
    this.badNum = 0,
    this.myReaction = Reaction.none,
    this.posttime = 0,
    this.replyToPoster,
  });

  final int postId;
  final String posttext;
  final String posterName;
  final String? posterLevel;
  final String? avatarUrl;
  final int likeNum;
  final int badNum;
  final Reaction myReaction;
  final int posttime;
  final String? replyToPoster;
}

/// 一頁書評。
@immutable
class BookReviewPage {
  const BookReviewPage({
    required this.reviews,
    required this.pageNum,
    required this.pages,
    required this.total,
  });

  final List<BookReview> reviews;
  final int pageNum;
  final int pages;
  final int total;

  bool get hasMore => pageNum < pages;
}

/// 一頁書評回覆。
@immutable
class BookReviewReplyList {
  const BookReviewReplyList({
    required this.replies,
    required this.pageNum,
    required this.pages,
  });

  final List<BookReviewReply> replies;
  final int pageNum;
  final int pages;

  bool get hasMore => pageNum < pages;
}
