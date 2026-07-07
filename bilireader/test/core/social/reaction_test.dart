import 'package:bilireader/core/social/reaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromValue：0/1/2 → none/like/bad，其餘 none', () {
    expect(Reaction.fromValue(0), Reaction.none);
    expect(Reaction.fromValue(1), Reaction.like);
    expect(Reaction.fromValue(2), Reaction.bad);
    expect(Reaction.fromValue(null), Reaction.none);
    expect(Reaction.fromValue(9), Reaction.none);
  });

  test('toggledRequestValue：點已選送 0（取消）、否則送該值', () {
    // 目前未反應 → 點讚送 1。
    expect(Reaction.like.toggledRequestValue(Reaction.none), 1);
    // 目前已讚 → 再點讚送 0（取消）。
    expect(Reaction.like.toggledRequestValue(Reaction.like), 0);
    // 目前已讚 → 點倒讚送 2（切換）。
    expect(Reaction.bad.toggledRequestValue(Reaction.like), 2);
  });
}
