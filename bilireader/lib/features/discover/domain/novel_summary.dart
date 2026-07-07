import 'package:flutter/foundation.dart';

/// 小說摘要 domain entity（規範 §4.3）。首頁清單 / 搜尋 / 榜單 / 詳情共用；
/// 顯示文字（[title]/[author]/[intro]/[tags] 等）已於 data 層經 OpenCC 轉繁（§5.0）。
///
/// 數值統計（評分、字數、瀏覽等）供卡片與詳情頁呈現；後端只給 rateSum/rateNum，
/// [rating] 已在 data 層算好平均。
@immutable
class NovelSummary {
  const NovelSummary({
    required this.articleId,
    required this.title,
    this.author,
    this.translator,
    this.illustrator,
    this.coverUrl,
    this.intro,
    this.keywords,
    this.tags = const <String>[],
    this.lastVolume,
    this.isFinished = false,
    this.rating = 0,
    this.ratingCount = 0,
    this.wordCount = 0,
    this.totalVisits = 0,
    this.totalFlowers = 0,
    this.hot = 0,
  });

  final int articleId;
  final String title;
  final String? author;
  final String? translator;
  final String? illustrator;
  final String? coverUrl;
  final String? intro;

  /// 原始 keywords 字串（繁化後）；細分標籤見 [tags]。
  final String? keywords;
  final List<String> tags;
  final String? lastVolume;
  final bool isFinished;

  /// 平均評分（0-10 區間，後端 sum/num 已算好）；0 代表尚無評分。
  final double rating;
  final int ratingCount;
  final int wordCount;
  final int totalVisits;
  final int totalFlowers;
  final int hot;
}
