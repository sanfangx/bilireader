import 'package:bilireader_app/features/reader/inline/reader_inline_node.dart';
import 'package:bilireader_app/features/reader/inline/reader_inline_parser.dart';
import 'package:flutter_test/flutter_test.dart';

/// 迴歸測試：同名行內標籤巢狀時，必須配對到**正確**的結束標籤（P1-10）。
///
/// 坑：`_findClosingTag` 原本直接取「第一個 `</name>`」、沒有深度計數。站方正文常見
/// `<span class="heimu">…<span>…</span>…</span>` 這種同名巢狀，取第一個等於讓外層提早收尾：
///   • 外層 heimu → 剩下的內容掉到 HeimuRun **之外** → **劇透以明文顯示**；
///   • 內層 heimu → 內層被當成未閉合而丟掉樣式 → **同樣把劇透攤開**。
/// 兩種情況畫面上都看不出是 bug（只是「這段沒被遮住」），屬於最難察覺的一類缺陷。
void main() {
  const ReaderInlineParser p = ReaderInlineParser();

  /// 這串節點裡，**沒有**被 HeimuRun 包住的可見文字（＝會直接被讀者看到的部分）。
  String exposedText(List<InlineNode> nodes) {
    final StringBuffer sb = StringBuffer();
    for (final InlineNode n in nodes) {
      switch (n) {
        case TextRun(:final String text):
          sb.write(text);
        case RubyRun(:final String base):
          sb.write(base);
        case LineBreakRun():
          sb.write('\n');
        case HeimuRun():
          break; // 已遮住 → 不算外洩
      }
    }
    return sb.toString();
  }

  group('黑幕（劇透遮罩）不得因巢狀而外洩', () {
    test('外層 heimu、內含普通 span → 整段都在遮罩內', () {
      final List<InlineNode> out =
          p.parse('<span class="heimu">前段<span>中段</span>後段</span>');

      expect(exposedText(out), isEmpty,
          reason: '外層 heimu 的任何一部分都不該露在 HeimuRun 之外');
      expect(visibleText(out), '前段中段後段');
      expect(out.whereType<HeimuRun>().length, 1);
    });

    test('外層普通 span、內層才是 heimu → 內層確實被遮住', () {
      final List<InlineNode> out =
          p.parse('<span>外層<span class="heimu">劇透內容</span>結尾</span>');

      expect(exposedText(out), '外層結尾');
      expect(
        out.whereType<HeimuRun>().map((HeimuRun h) => visibleText(h.children)).join(),
        '劇透內容',
        reason: '內層 heimu 被當成未閉合丟掉樣式 → 劇透直接變明文',
      );
    });

    test('三層同名巢狀，最外層為 heimu → 全部仍在遮罩內', () {
      final List<InlineNode> out = p.parse(
        '<span class="heimu">a<span>b<span>c</span>d</span>e</span>',
      );

      expect(exposedText(out), isEmpty);
      expect(visibleText(out), 'abcde');
    });

    test('<heimu> 標籤自身的巢狀', () {
      final List<InlineNode> out =
          p.parse('<heimu>外<heimu>內</heimu>尾</heimu>');

      expect(exposedText(out), isEmpty);
      expect(visibleText(out), '外內尾');
    });
  });

  group('其他同名巢狀標籤的樣式也要配對正確', () {
    test('font 巢狀：顏色就近生效，外層尾段回到外層顏色', () {
      final List<InlineNode> out = p.parse(
        '<font color="red">紅<font color="blue">藍</font>紅尾</font>',
      );

      final List<TextRun> runs = out.whereType<TextRun>().toList();
      expect(runs.map((TextRun r) => r.text).toList(), <String>['紅', '藍', '紅尾']);
      expect(runs[0].color, 0xFFFF0000);
      expect(runs[1].color, 0xFF0000FF);
      expect(runs[2].color, 0xFFFF0000,
          reason: '外層尾段若配對錯誤會掉出 font 而失去顏色');
    });

    test('small 巢狀：smallLevel 逐層累加、離開內層後回到外層層級', () {
      final List<InlineNode> out =
          p.parse('<small>一<small>二</small>三</small>');

      final List<TextRun> runs = out.whereType<TextRun>().toList();
      expect(runs.map((TextRun r) => r.text).toList(), <String>['一', '二', '三']);
      expect(runs.map((TextRun r) => r.smallLevel).toList(), <int>[1, 2, 1]);
    });
  });

  group('邊界情形不得當機或吞內容', () {
    test('未閉合的巢狀標籤：不當機，文字仍保留', () {
      final List<InlineNode> out = p.parse('<span class="heimu">未閉合<span>內');
      expect(visibleText(out), contains('未閉合'));
      expect(visibleText(out), contains('內'));
    });

    test('自閉合 <span/> 不影響配對', () {
      final List<InlineNode> out =
          p.parse('<span class="heimu">前<span/>後</span>');

      expect(exposedText(out), isEmpty,
          reason: '自閉合標籤沒有對應的結束標籤，不該讓深度計數失衡');
      expect(visibleText(out), '前後');
    });

    test('大小寫混雜的標籤照樣配對', () {
      final List<InlineNode> out =
          p.parse('<SPAN class="heimu">前<Span>中</SPAN>後</span>');

      expect(exposedText(out), isEmpty);
      expect(visibleText(out), '前中後');
    });

    test('不同名的內層標籤不影響外層配對（既有行為不變）', () {
      final List<InlineNode> out =
          p.parse('<span class="heimu">前<font color="red">中</font>後</span>');

      expect(exposedText(out), isEmpty);
      expect(visibleText(out), '前中後');
    });
  });
}
