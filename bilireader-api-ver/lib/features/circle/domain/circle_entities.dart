import 'package:flutter/foundation.dart';

import '../../../core/social/reaction.dart';

/// 圈子貼文（顯示用；文字已於 data 層轉繁，§5.0）。純值物件（§4.3）。
@immutable
class CirclePost {
  const CirclePost({
    required this.topicId,
    required this.title,
    required this.content,
    required this.authorName,
    this.authorLevel,
    this.avatarUrl,
    this.sectionName,
    this.likeNum = 0,
    this.badNum = 0,
    this.myReaction = Reaction.none,
    this.replies = 0,
    this.views = 0,
    this.postTime = 0,
    this.imageUrls = const <String>[],
    this.articleId,
    this.articleName,
  });

  /// 詳情/互動主鍵（`circle/detail` 用 topicId；清單項以 topicId ?? id 推得）。
  final int topicId;
  final String title;
  final String content;
  final String authorName;
  final String? authorLevel;
  final String? avatarUrl;
  final String? sectionName;
  final int likeNum;
  final int badNum;
  final Reaction myReaction;
  final int replies;
  final int views;
  final int postTime;
  final List<String> imageUrls;
  final int? articleId;
  final String? articleName;

  /// 更新讚/倒讚（跨頁同步用；其餘欄位不變）。供 feed 單筆 upsert，避免整列重抓
  /// 而重置捲動/已載分頁（UX F-05，體驗不變量#1）。
  CirclePost copyWithReaction({
    required int likeNum,
    required int badNum,
    required Reaction myReaction,
  }) => CirclePost(
    topicId: topicId,
    title: title,
    content: content,
    authorName: authorName,
    authorLevel: authorLevel,
    avatarUrl: avatarUrl,
    sectionName: sectionName,
    likeNum: likeNum,
    badNum: badNum,
    myReaction: myReaction,
    replies: replies,
    views: views,
    postTime: postTime,
    imageUrls: imageUrls,
    articleId: articleId,
    articleName: articleName,
  );
}

/// 圈子版塊（分區）。
@immutable
class CircleSection {
  const CircleSection({
    required this.sectionId,
    required this.sectionName,
    this.categoryName = '',
    this.postCount = 0,
    this.topicCount = 0,
  });

  final int sectionId;
  final String sectionName;
  final String categoryName;
  final int postCount;
  final int topicCount;
}

/// 圈子貼文回覆。
@immutable
class CircleReply {
  const CircleReply({
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
    this.imageUrls = const <String>[],
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
  final List<String> imageUrls;
}

/// 一頁貼文（含分頁資訊）。
@immutable
class CircleFeed {
  const CircleFeed({
    required this.posts,
    required this.pageNum,
    required this.pages,
    required this.total,
  });

  final List<CirclePost> posts;
  final int pageNum;
  final int pages;
  final int total;

  bool get hasMore => pageNum < pages;
}

/// 一頁回覆（含分頁資訊）。
@immutable
class CircleReplyPage {
  const CircleReplyPage({
    required this.replies,
    required this.pageNum,
    required this.pages,
  });

  final List<CircleReply> replies;
  final int pageNum;
  final int pages;

  bool get hasMore => pageNum < pages;
}
