import 'package:bilireader/core/common_widgets/bili_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// F-29 骨架無障礙：載入骨架須向讀屏播報「載入中」（取代原 BiliLoadingView 的訊息），
/// 否則以純灰塊取代轉圈會靜默丟失載入狀態語意（批 4 a11y 基線）。
void main() {
  Future<void> pump(WidgetTester tester, Widget child) =>
      tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));

  testWidgets('HorizontalBooksSkeleton 播報「載入中」', (WidgetTester tester) async {
    await pump(tester, const HorizontalBooksSkeleton(count: 2));
    expect(find.bySemanticsLabel('載入中'), findsOneWidget);
  });

  testWidgets('RankListSkeleton 播報「載入中」', (WidgetTester tester) async {
    await pump(tester, const RankListSkeleton(count: 2));
    expect(find.bySemanticsLabel('載入中'), findsOneWidget);
  });
}
