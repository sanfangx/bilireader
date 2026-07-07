import 'package:bilireader/features/reader/domain/reader_inline_parser.dart';
import 'package:bilireader/features/reader/domain/reader_settings.dart';
import 'package:bilireader/features/reader/domain/reader_theme.dart';
import 'package:bilireader/features/reader/presentation/render/reader_span_builder.dart';
import 'package:bilireader/features/reader/presentation/render/reader_style.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const ReaderInlineParser parser = ReaderInlineParser();
  const ReaderSpanBuilder builder = ReaderSpanBuilder();
  final ReaderStyle style = ReaderStyle.from(
    const ReaderSettings(),
    kBuiltInReaderThemes.first,
  );

  List<InlineSpan> childrenOf(
    String html, {
    Set<int> revealed = const <int>{},
  }) {
    final TextSpan root =
        builder.build(parser.parse(html), style, revealedHeimu: revealed)
            as TextSpan;
    return root.children ?? <InlineSpan>[];
  }

  test('文字 + ruby：TextSpan / WidgetSpan 結構保序', () {
    final List<InlineSpan> kids = childrenOf('a<ruby>字<rt>じ</rt></ruby>b');
    expect(kids.length, 3);
    expect(kids[0], isA<TextSpan>());
    expect(kids[1], isA<WidgetSpan>()); // ruby
    expect(kids[2], isA<TextSpan>());
  });

  test('傍点：逐字 WidgetSpan（可換行）', () {
    final List<InlineSpan> kids = childrenOf(
      '<span class="underdot">強調</span>',
    );
    expect(kids.length, 2); // 強 / 調
    expect(kids.every((InlineSpan s) => s is WidgetSpan), isTrue);
  });

  test('heimu：單一 WidgetSpan', () {
    final List<InlineSpan> kids = childrenOf('前<heimu>祕密</heimu>後');
    expect(kids.length, 3);
    expect(kids[1], isA<WidgetSpan>());
  });

  testWidgets('渲染不崩潰：ruby base/rt 可見', (WidgetTester tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: Text.rich(
            builder.build(parser.parse('漢<ruby>字<rt>じ</rt></ruby>強'), style),
          ),
        ),
      ),
    );
    expect(find.text('字'), findsOneWidget); // ruby base
    expect(find.text('じ'), findsOneWidget); // ruby rt
  });

  testWidgets('heimu 點擊觸發揭露回呼', (WidgetTester tester) async {
    int? tapped;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: Text.rich(
            builder.build(
              parser.parse('<heimu>祕</heimu>'),
              style,
              onHeimuTap: (int i) => tapped = i,
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(GestureDetector));
    expect(tapped, 0);
  });

  testWidgets('heimu 揭露後顯示原文', (WidgetTester tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: Text.rich(
            builder.build(
              parser.parse('<heimu>祕密</heimu>'),
              style,
              revealedHeimu: const <int>{0},
            ),
          ),
        ),
      ),
    );
    expect(find.text('祕密'), findsOneWidget);
  });
}
