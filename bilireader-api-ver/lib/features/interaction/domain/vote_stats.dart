/// 小說推薦票統計（`vote/getNovelVotes`，doc 10 §12.1）。純 Dart（§4.2）。
class VoteStats {
  const VoteStats({
    this.allVote = 0,
    this.dayVote = 0,
    this.weekVote = 0,
    this.monthVote = 0,
    this.todayVoted = false,
    this.userVoted = false,
  });

  final int allVote;
  final int dayVote;
  final int weekVote;
  final int monthVote;

  /// 今日是否已投票（用於停用今日投票按鈕）。
  final bool todayVoted;

  /// 使用者是否曾投過票。
  final bool userVoted;
}
