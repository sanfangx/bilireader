import 'package:bilireader_app/features/reader/inline/reader_inline_node.dart';
import 'package:flutter_test/flutter_test.dart';

/// 閱讀器 parity 增量 1：行內 AST 的可見文字與尺寸常數。
void main() {
  group('visibleText', () {
    test('TextRun 直接輸出；RubyRun 只留 base；LineBreakRun→\\n', () {
      final nodes = <InlineNode>[
        const TextRun('日本語'),
        const RubyRun('漢字', 'かんじ'),
        const LineBreakRun(),
        const TextRun('尾'),
      ];
      expect(visibleText(nodes), '日本語漢字\n尾');
    });

    test('HeimuRun 遞迴留內容（可見文字含被遮住的字）', () {
      final nodes = <InlineNode>[
        const TextRun('真相是'),
        HeimuRun(<InlineNode>[const TextRun('凶手是他')]),
      ];
      expect(visibleText(nodes), '真相是凶手是他');
    });

    test('巢狀 heimu', () {
      final nodes = <InlineNode>[
        HeimuRun(<InlineNode>[
          const TextRun('a'),
          HeimuRun(<InlineNode>[const TextRun('b')]),
        ]),
      ];
      expect(visibleText(nodes), 'ab');
    });
  });

  group('smallTextScale', () {
    test('任一參數 ≤0 → 1.0（不縮放）', () {
      expect(smallTextScale(0, 4), 1.0);
      expect(smallTextScale(20, 0), 1.0);
    });

    test('取 max(f4-f5, 0.6*f4)/f4；有下限 0.6', () {
      // f4=20,f5=4 → (16) vs (12) → 16/20 = 0.8
      expect(smallTextScale(20, 4), closeTo(0.8, 1e-9));
      // f4=20,f5=16 → (4) vs (12) → 取 12 → 12/20 = 0.6（下限）
      expect(smallTextScale(20, 16), closeTo(0.6, 1e-9));
    });
  });

  group('值相等', () {
    test('TextRun 與 RubyRun 依欄位相等', () {
      expect(const TextRun('a', superscript: true),
          const TextRun('a', superscript: true));
      expect(const RubyRun('漢', 'か'), const RubyRun('漢', 'か'));
      expect(const TextRun('a') == const TextRun('b'), isFalse);
    });
  });
}
