import 'package:bilireader/features/interaction/domain/gift_models.dart';
import 'package:bilireader/features/interaction/presentation/gift_sheet.dart';
import 'package:bilireader/features/interaction/presentation/interaction_controllers.dart';
import 'package:bilireader/features/interaction/presentation/rating_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 迴歸：詳情互動抽屜渲染不得崩潰（送花 quick chip 選中曾因 Material 同時給
/// shape+borderRadius 觸發 assertion）；評分為 1–5 星（伺服器實測範圍）。
Widget _host(void Function(BuildContext) onOpen) {
  return MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (BuildContext context) => ElevatedButton(
          onPressed: () => onOpen(context),
          child: const Text('open'),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('送花抽屜開啟不崩潰（預設數量 5 的 quick chip 選中）', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          giftBalanceProvider.overrideWith(
            (ref) async => const GiftBalance(
              egold: 100,
              score: 3,
              flowerStock: 12,
              flowerUnitPrice: 10,
            ),
          ),
        ],
        child: _host((context) => showGiftSheet(context, articleId: 1)),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('鮮花庫存'), findsOneWidget);
    expect(find.textContaining('送出'), findsWidgets);
  });

  testWidgets('評分抽屜為 1–5 星（非 1–10）', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [myRatingProvider(1).overrideWith((ref) async => 0)],
        child: _host((context) => showRatingSheet(context, articleId: 1)),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('點選 1–5 星'), findsOneWidget);
    expect(find.byIcon(Icons.star_border_rounded), findsNWidgets(5));
  });
}
