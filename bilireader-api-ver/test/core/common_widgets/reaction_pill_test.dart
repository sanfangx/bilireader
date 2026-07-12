import 'package:bilireader/core/common_widgets/reaction_pill.dart';
import 'package:bilireader/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// 共用 reaction pill（設計稿 `.rvd-rb`，§5.1.1）：圖示 + 計數；選中換色 + 描邊；可點。
void main() {
  Widget host(Widget child) => MaterialApp(
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets('顯示圖示與標籤，點擊觸發 onTap', (WidgetTester tester) async {
    int taps = 0;
    await tester.pumpWidget(
      host(
        ReactionPill(
          icon: Icons.thumb_up_alt_outlined,
          label: '32',
          onTap: () => taps++,
        ),
      ),
    );
    expect(find.text('32'), findsOneWidget);
    expect(find.byIcon(Icons.thumb_up_alt_outlined), findsOneWidget);

    await tester.tap(find.byType(ReactionPill));
    expect(taps, 1);
  });

  testWidgets('label 為空時只顯示圖示', (WidgetTester tester) async {
    await tester.pumpWidget(
      host(const ReactionPill(icon: Icons.thumb_down_alt_outlined, label: '')),
    );
    expect(find.byIcon(Icons.thumb_down_alt_outlined), findsOneWidget);
    expect(find.byType(Text), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('選中狀態：底色 cov（設計稿 .rvd-rb.on）', (WidgetTester tester) async {
    await tester.pumpWidget(
      host(
        const ReactionPill(
          icon: Icons.thumb_up_alt_outlined,
          label: '讚',
          selected: true,
        ),
      ),
    );
    final Material material = tester.widget<Material>(
      find.descendant(
        of: find.byType(ReactionPill),
        matching: find.byType(Material),
      ),
    );
    expect(material.color, AppColors.cov);
    expect(material.shape, isA<StadiumBorder>());
    expect(tester.takeException(), isNull);
  });
}
