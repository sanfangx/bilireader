import 'package:bilireader/core/common_widgets/app_badge.dart';
import 'package:bilireader/core/common_widgets/app_capsule_button.dart';
import 'package:bilireader/core/common_widgets/app_chip.dart';
import 'package:bilireader/core/common_widgets/brand_header.dart';
import 'package:bilireader/core/common_widgets/reaction_pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

SemanticsData dataOf(WidgetTester tester, Finder finder) =>
    tester.getSemantics(finder).getSemanticsData();

void main() {
  group('F-12 共用元件無障礙語意', () {
    testWidgets('BrandIconButton 可點：名稱 + button + 點擊動作', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        host(
          BrandIconButton(
            icon: Icons.edit_outlined,
            semanticLabel: '發表',
            onTap: () {},
          ),
        ),
      );
      final SemanticsData d = dataOf(tester, find.byType(BrandIconButton));
      expect(d.label, '發表');
      expect(d.flagsCollection.isButton, isTrue);
      expect(d.hasAction(SemanticsAction.tap), isTrue);
      handle.dispose();
    });

    testWidgets('BrandIconButton 純裝飾：僅語意名、無 button/點擊', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        host(const BrandIconButton(icon: Icons.search, semanticLabel: '搜尋')),
      );
      final SemanticsData d = dataOf(tester, find.byType(BrandIconButton));
      expect(d.label, '搜尋');
      expect(d.flagsCollection.isButton, isFalse);
      expect(d.hasAction(SemanticsAction.tap), isFalse);
      handle.dispose();
    });

    testWidgets('ReactionPill 選中：selected + button + 名稱(含計數) + 點擊', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        host(
          ReactionPill(
            icon: Icons.thumb_up_alt_outlined,
            label: '12',
            selected: true,
            semanticLabel: '讚',
            onTap: () {},
          ),
        ),
      );
      final SemanticsData d = dataOf(tester, find.byType(ReactionPill));
      expect(d.flagsCollection.isButton, isTrue);
      expect(d.flagsCollection.isSelected.toBoolOrNull(), isTrue);
      expect(d.hasAction(SemanticsAction.tap), isTrue);
      expect(d.label, contains('讚'));
      expect(d.label, contains('12'));
      handle.dispose();
    });

    testWidgets(
      'ReactionPill 空計數 + semanticLabel → 語意名非空（circle badNum==0 迴歸）',
      (WidgetTester tester) async {
        final SemanticsHandle handle = tester.ensureSemantics();
        await tester.pumpWidget(
          host(
            ReactionPill(
              icon: Icons.thumb_down_alt_outlined,
              label: '',
              semanticLabel: '倒讚',
              onTap: () {},
            ),
          ),
        );
        final SemanticsData d = dataOf(tester, find.byType(ReactionPill));
        expect(d.label, '倒讚'); // 非無名按鈕
        expect(d.flagsCollection.isButton, isTrue);
        expect(d.hasAction(SemanticsAction.tap), isTrue);
        handle.dispose();
      },
    );

    testWidgets('AppChip 選中：selected + button + 點擊', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        host(AppChip(label: '全部', selected: true, onTap: () {})),
      );
      final SemanticsData d = dataOf(tester, find.byType(AppChip));
      expect(d.label, '全部');
      expect(d.flagsCollection.isButton, isTrue);
      expect(d.flagsCollection.isSelected.toBoolOrNull(), isTrue);
      expect(d.hasAction(SemanticsAction.tap), isTrue);
      handle.dispose();
    });

    testWidgets('AppBadge semanticLabel 覆蓋裸數字（3 → 3 則未讀）', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        host(
          const AppBadge(
            label: '3',
            variant: AppBadgeVariant.danger,
            pill: true,
            semanticLabel: '3 則未讀',
          ),
        ),
      );
      expect(find.bySemanticsLabel('3 則未讀'), findsOneWidget);
      expect(find.bySemanticsLabel('3'), findsNothing);
      handle.dispose();
    });
  });

  group('F-13 觸控目標 44×44', () {
    testWidgets('BrandIconButton 可點命中區 ≥ 44×44（視覺仍 34）', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          BrandIconButton(
            icon: Icons.edit_outlined,
            semanticLabel: '發表',
            onTap: () {},
          ),
        ),
      );
      final Size size = tester.getSize(find.byType(BrandIconButton));
      expect(size.width, greaterThanOrEqualTo(44));
      expect(size.height, greaterThanOrEqualTo(44));
    });

    testWidgets('BrandIconButton 純裝飾維持 34（不放大）', (WidgetTester tester) async {
      await tester.pumpWidget(
        host(const BrandIconButton(icon: Icons.search, semanticLabel: '搜尋')),
      );
      expect(tester.getSize(find.byType(BrandIconButton)), const Size(34, 34));
    });
  });

  group('F-20 觸覺回饋', () {
    List<MethodCall> spyPlatform(WidgetTester tester) {
      final List<MethodCall> calls = <MethodCall>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (MethodCall call) async {
          calls.add(call);
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      return calls;
    }

    testWidgets('AppCapsuleButton tap 發 selectionClick', (
      WidgetTester tester,
    ) async {
      final List<MethodCall> calls = spyPlatform(tester);
      await tester.pumpWidget(
        host(AppCapsuleButton(label: '主要', onPressed: () {})),
      );
      await tester.tap(find.byType(AppCapsuleButton));
      expect(
        calls.where(
          (MethodCall c) =>
              c.method == 'HapticFeedback.vibrate' &&
              c.arguments == 'HapticFeedbackType.selectionClick',
        ),
        isNotEmpty,
      );
    });

    testWidgets('AppCapsuleButton disabled 不發觸覺', (WidgetTester tester) async {
      final List<MethodCall> calls = spyPlatform(tester);
      await tester.pumpWidget(host(const AppCapsuleButton(label: '停用')));
      await tester.tap(find.byType(AppCapsuleButton), warnIfMissed: false);
      expect(
        calls.where((MethodCall c) => c.method == 'HapticFeedback.vibrate'),
        isEmpty,
      );
    });
  });
}
