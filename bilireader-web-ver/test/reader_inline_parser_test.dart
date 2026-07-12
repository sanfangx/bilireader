import 'package:bilireader_app/features/reader/inline/reader_inline_node.dart';
import 'package:bilireader_app/features/reader/inline/reader_inline_parser.dart';
import 'package:flutter_test/flutter_test.dart';

/// 閱讀器 parity 增量 2：行內解析器。
void main() {
  const p = ReaderInlineParser();

  test('ruby → RubyRun(base, rt)', () {
    expect(p.parse('<ruby>漢字<rt>かんじ</rt></ruby>'),
        <InlineNode>[const RubyRun('漢字', 'かんじ')]);
  });

  test('ruby 含 <rp> fallback → rp 內容被丟棄', () {
    expect(p.parse('<ruby>漢<rp>(</rp><rt>か</rt><rp>)</rp></ruby>'),
        <InlineNode>[const RubyRun('漢', 'か')]);
  });

  test('color（style / 具名 / #縮寫）', () {
    expect(p.parse('<span style="color:#ff0000">紅</span>'),
        <InlineNode>[const TextRun('紅', color: 0xFFFF0000)]);
    expect(p.parse('<font color="red">紅</font>'),
        <InlineNode>[const TextRun('紅', color: 0xFFFF0000)]);
    expect(p.parse('<span style="color:#f00">紅</span>'),
        <InlineNode>[const TextRun('紅', color: 0xFFFF0000)]);
  });

  test('sup 標記 superscript', () {
    expect(p.parse('x<sup>2</sup>'), <InlineNode>[
      const TextRun('x'),
      const TextRun('2', superscript: true),
    ]);
  });

  test('small → smallLevel 1', () {
    expect(p.parse('a<small>b</small>c'), <InlineNode>[
      const TextRun('a'),
      const TextRun('b', smallLevel: 1),
      const TextRun('c'),
    ]);
  });

  test('heimu：<heimu> 標籤與 span.class 皆包成 HeimuRun', () {
    expect(p.parse('<heimu>祕密</heimu>'),
        <InlineNode>[HeimuRun(<InlineNode>[const TextRun('祕密')])]);
    expect(p.parse('<span class="heimu">祕密</span>'),
        <InlineNode>[HeimuRun(<InlineNode>[const TextRun('祕密')])]);
  });

  test('傍点 class（config 驅動）', () {
    expect(p.parse('<span class="underdot">重點</span>'),
        <InlineNode>[const TextRun('重點', emphasis: ReaderEmphasis.underDot)]);
  });

  test('<br> → LineBreakRun', () {
    expect(p.parse('a<br>b'), <InlineNode>[
      const TextRun('a'),
      const LineBreakRun(),
      const TextRun('b'),
    ]);
  });

  test('HTML 實體解碼', () {
    expect(p.parse('A&amp;B&lt;C&gt;D&#65;'),
        <InlineNode>[const TextRun('A&B<C>DA')]);
  });

  test('未知標籤：剝除標籤、相鄰文字併入同一 run', () {
    expect(p.parse('<b>粗</b>字'), <InlineNode>[const TextRun('粗字')]);
  });

  test('visibleText 對解析結果（ruby 只留 base）', () {
    final nodes = p.parse('序<ruby>漢<rt>か</rt></ruby><br>尾');
    expect(visibleText(nodes), '序漢\n尾');
  });
}
