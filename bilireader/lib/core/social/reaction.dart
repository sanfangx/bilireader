/// 社群按讚/倒讚語意（書評、章評、圈子共用，規範 §5.1.1）。
///
/// wire 值：0=無、1=讚、2=倒讚（doc 09/10：`myReaction` 與 like 端點 `type` 同語意）。
library;

enum Reaction {
  none(0),
  like(1),
  bad(2);

  const Reaction(this.value);

  final int value;

  static Reaction fromValue(int? v) => switch (v) {
    1 => Reaction.like,
    2 => Reaction.bad,
    _ => Reaction.none,
  };

  /// 點擊已選的反應會取消（送出 0）；否則送出該反應值（樂觀更新用）。
  int toggledRequestValue(Reaction current) =>
      current == this ? Reaction.none.value : value;
}

/// 反應計數 + 目前使用者反應（like/reply_like 回應與清單項共用）。
class ReactionCounts {
  const ReactionCounts({
    this.likeNum = 0,
    this.badNum = 0,
    this.myReaction = Reaction.none,
  });

  final int likeNum;
  final int badNum;
  final Reaction myReaction;
}
