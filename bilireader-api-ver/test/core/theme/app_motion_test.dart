import 'package:bilireader/core/theme/app_motion.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppMotion', () {
    test('時長常數符合 §5.1.2 token（fast/normal/page）', () {
      expect(AppMotion.fast, const Duration(milliseconds: 150));
      expect(AppMotion.normal, const Duration(milliseconds: 240));
      expect(AppMotion.page, const Duration(milliseconds: 320));
    });

    testWidgets('reduceMotion=false → durationOf 回原時長', (
      WidgetTester tester,
    ) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(),
          child: Builder(
            builder: (BuildContext context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );
      expect(AppMotion.reduceMotion(ctx), isFalse);
      expect(AppMotion.durationOf(ctx, AppMotion.page), AppMotion.page);
    });

    testWidgets('reduceMotion=true → durationOf 折為 Duration.zero（F-22）', (
      WidgetTester tester,
    ) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Builder(
            builder: (BuildContext context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );
      expect(AppMotion.reduceMotion(ctx), isTrue);
      expect(AppMotion.durationOf(ctx, AppMotion.page), Duration.zero);
      expect(AppMotion.durationOf(ctx, AppMotion.fast), Duration.zero);
    });
  });
}
