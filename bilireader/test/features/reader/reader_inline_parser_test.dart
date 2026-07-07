import 'package:bilireader/features/reader/domain/reader_inline_node.dart';
import 'package:bilireader/features/reader/domain/reader_inline_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const ReaderInlineParser p = ReaderInlineParser();

  test('純文字 → 單一 TextRun', () {
    expect(p.parse('你好世界'), <InlineNode>[const TextRun('你好世界')]);
  });

  group('ruby', () {
    test('base + rt → RubyRun', () {
      expect(p.parse('<ruby>字<rt>じ</rt></ruby>'), <InlineNode>[
        const RubyRun('字', 'じ'),
      ]);
    });
    test('前後文字保序', () {
      expect(p.parse('漢<ruby>字<rt>じ</rt></ruby>後'), <InlineNode>[
        const TextRun('漢'),
        const RubyRun('字', 'じ'),
        const TextRun('後'),
      ]);
    });
    test('無 rt → base 以原樣式呈現（非 ruby）', () {
      expect(p.parse('<ruby>字</ruby>'), <InlineNode>[const TextRun('字')]);
    });
    test('rp fallback 括號被丟棄', () {
      expect(
        p.parse('<ruby>字<rp>(</rp><rt>じ</rt><rp>)</rp></ruby>'),
        <InlineNode>[const RubyRun('字', 'じ')],
      );
    });
  });

  group('顏色（span/font）', () {
    test('style color:#RGB 展開', () {
      expect(p.parse('<span style="color:#f00">紅</span>'), <InlineNode>[
        const TextRun('紅', color: 0xFFFF0000),
      ]);
    });
    test('attr color 具名色', () {
      expect(p.parse('<span color="red">紅</span>'), <InlineNode>[
        const TextRun('紅', color: 0xFFFF0000),
      ]);
    });
    test('font color 具名色', () {
      expect(p.parse('<font color="blue">藍</font>'), <InlineNode>[
        const TextRun('藍', color: 0xFF0000FF),
      ]);
    });
    test('巢狀同名 span：naive findClosingTag 配對 → 外層色生效（忠實於 App）', () {
      // App 的 findClosingTag 取「第一個」</span>，故內層 <span> 未配到閉合而被跳過，
      // x 繼承外層 red。這是原 App 的實際行為（非 bug 修正）。
      expect(
        p.parse('<span color="red"><span color="blue">x</span></span>'),
        <InlineNode>[const TextRun('x', color: 0xFFFF0000)],
      );
    });
  });

  group('傍点 class（§5.2）', () {
    test('underdot → 圓點·字下', () {
      expect(p.parse('<span class="underdot">強</span>'), <InlineNode>[
        const TextRun('強', emphasis: ReaderEmphasis.underDot),
      ]);
    });
    test('oversesame → 芝麻點·字上', () {
      expect(p.parse('<span class="oversesame">強</span>'), <InlineNode>[
        const TextRun('強', emphasis: ReaderEmphasis.overSesame),
      ]);
    });
    test('overdot → 圓點·字上', () {
      expect(p.parse('<span class="overdot">強</span>'), <InlineNode>[
        const TextRun('強', emphasis: ReaderEmphasis.overDot),
      ]);
    });
    test('顏色 + 傍点併存', () {
      expect(
        p.parse('<span style="color:red" class="overdot">x</span>'),
        <InlineNode>[
          const TextRun(
            'x',
            color: 0xFFFF0000,
            emphasis: ReaderEmphasis.overDot,
          ),
        ],
      );
    });
  });

  group('sup / small', () {
    test('sup → superscript', () {
      expect(p.parse('x<sup>2</sup>'), <InlineNode>[
        const TextRun('x'),
        const TextRun('2', superscript: true),
      ]);
    });
    test('small → smallLevel 1', () {
      expect(p.parse('<small>小</small>'), <InlineNode>[
        const TextRun('小', smallLevel: 1),
      ]);
    });
    test('sup + small 巢狀（不同標籤）疊加', () {
      expect(p.parse('<sup><small>x</small></sup>'), <InlineNode>[
        const TextRun('x', superscript: true, smallLevel: 1),
      ]);
    });
  });

  test('heimu → HeimuRun（保留內層樣式）', () {
    expect(p.parse('<heimu>祕密</heimu>'), <InlineNode>[
      const HeimuRun(<InlineNode>[TextRun('祕密')]),
    ]);
    expect(p.parse('<heimu><span color="red">祕</span></heimu>'), <InlineNode>[
      const HeimuRun(<InlineNode>[TextRun('祕', color: 0xFFFF0000)]),
    ]);
  });

  test('br → LineBreakRun', () {
    expect(p.parse('a<br>b'), <InlineNode>[
      const TextRun('a'),
      const LineBreakRun(),
      const TextRun('b'),
    ]);
  });

  group('HTML 實體', () {
    test('具名實體', () {
      expect(p.parse('a&gt;b&lt;c&amp;d&quot;e&apos;f'), <InlineNode>[
        const TextRun('a>b<c&d"e\'f'),
      ]);
    });
    test('數字實體（十進位 / 十六進位）', () {
      expect(p.parse('&#65;&#x4E00;'), <InlineNode>[const TextRun('A一')]);
    });
    test('無效實體保留 &', () {
      expect(p.parse('a&nope b'), <InlineNode>[const TextRun('a&nope b')]);
    });
  });

  test('未知標籤跳過、保留內容', () {
    expect(p.parse('<b>粗</b>體'), <InlineNode>[const TextRun('粗體')]);
  });

  test('巢狀 color + small', () {
    expect(
      p.parse('<span style="color:red"><small>小</small></span>'),
      <InlineNode>[const TextRun('小', color: 0xFFFF0000, smallLevel: 1)],
    );
  });

  group('visibleText（§5.4）', () {
    test('ruby 只留 base、br→換行、heimu 留內容', () {
      final List<InlineNode> nodes = p.parse(
        '漢<ruby>字<rt>じ</rt></ruby><br><heimu>祕</heimu>',
      );
      expect(visibleText(nodes), '漢字\n祕');
    });
  });

  group('smallTextScale（§5.3）', () {
    test('f5<=0 → 1.0', () => expect(smallTextScale(60, 0), 1.0));
    test('一般：max(f4-f5, 0.6*f4)/f4', () {
      // f4=60, f5=12 → max(48, 36)/60 = 0.8
      expect(smallTextScale(60, 12), closeTo(0.8, 1e-9));
      // f4=60, f5=30 → max(30, 36)/60 = 0.6（下限）
      expect(smallTextScale(60, 30), closeTo(0.6, 1e-9));
    });
  });
}
