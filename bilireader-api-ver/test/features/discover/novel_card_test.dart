import 'package:bilireader/features/discover/domain/novel_summary.dart';
import 'package:bilireader/features/discover/presentation/widgets/novel_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// 迴歸：首頁「強力推薦」(.hbook) 與詳情「也在看」(.reco) 書卡在其固定高度捲動列中
/// 不得溢位（曾出現 BOTTOM OVERFLOWED）。以長書名 + 空封面（走 fallback、不觸網）測。
void main() {
  const NovelSummary novel = NovelSummary(
    articleId: 1,
    title: '非常非常長的書名用來測試單行省略與高度不溢位的情況',
    author: '某位作者名',
  );

  Widget wrap(Widget child) => MaterialApp(
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets('hbook 變體（寬 88、含作者）在高 178 列中不溢位', (WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(
        const SizedBox(height: 178, width: 88, child: NovelCard(novel: novel)),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('reco 變體（寬 70、無作者）在高 134 列中不溢位', (WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(
        const SizedBox(
          height: 134,
          width: 70,
          child: NovelCard(
            novel: novel,
            width: 70,
            titleSize: 10,
            showAuthor: false,
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    // reco 變體不顯示作者。
    expect(find.text('某位作者名'), findsNothing);
  });
}
