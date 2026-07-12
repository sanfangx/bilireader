import 'package:bilireader/features/reader/domain/reader_split_support.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('mapReaderVisibleOffsetToOriginalText（§6.7）', () {
    test('純文字 → 恆等', () {
      expect(mapReaderVisibleOffsetToOriginalText('abcdef', 0), 0);
      expect(mapReaderVisibleOffsetToOriginalText('abcdef', 3), 3);
    });

    test('未知標籤：可見 offset 跳過標籤', () {
      // '<b>a' → 可見 1（'a'）對應原始 offset 4（'<b>a' 之後）。
      expect(mapReaderVisibleOffsetToOriginalText('<b>ab', 1), 4);
    });

    test('ruby：base 計可見長度，映到整個 ruby 之後', () {
      const String s = '<ruby>字<rt>じ</rt></ruby>後';
      expect(mapReaderVisibleOffsetToOriginalText(s, 1), 24); // '後' 之前
      expect(mapReaderVisibleOffsetToOriginalText(s, 2), 25); // '後' 之後
    });

    test('sup：遞迴映射', () {
      const String s = 'a<sup>bc</sup>d';
      expect(mapReaderVisibleOffsetToOriginalText(s, 3), 14); // 'd' 之前
      expect(mapReaderVisibleOffsetToOriginalText(s, 2), 7); // 'c' 之前
    });

    test('br 計 1 可見字', () {
      // 'a<br>b' → 可見 'a\nb'；offset 2 → '<br>' 之後（'b' 之前）。
      expect(mapReaderVisibleOffsetToOriginalText('a<br>b', 2), 5);
    });
  });

  group('activeSplittableInlineTagsAt', () {
    test('單一 small 開啟中', () {
      final List<SplittableTag> a = activeSplittableInlineTagsAt(
        '<small>abc</small>',
        9,
      );
      expect(a, <SplittableTag>[const SplittableTag('small', '<small>')]);
    });

    test('巢狀 sup > small', () {
      final List<SplittableTag> a = activeSplittableInlineTagsAt(
        '<sup><small>x</small></sup>',
        12,
      );
      expect(a.map((SplittableTag t) => t.name), <String>['sup', 'small']);
    });

    test('已閉合的不計入', () {
      final List<SplittableTag> a = activeSplittableInlineTagsAt(
        '<small>a</small>bc',
        18,
      );
      expect(a, isEmpty);
    });

    test('非可分割標籤（span）不追蹤', () {
      final List<SplittableTag> a = activeSplittableInlineTagsAt(
        '<span color="red">abc',
        20,
      );
      expect(a, isEmpty);
    });
  });

  group('readerInlineTagBalanceForSplit（§6.4）', () {
    test('single small：前半補閉合、後半補開啟', () {
      final (String close, String open) = readerInlineTagBalanceForSplit(
        '<small>abc</small>',
        9,
      );
      expect(close, '</small>');
      expect(open, '<small>');
    });

    test('巢狀：閉合反序、開啟原序（保留原始開標籤）', () {
      final (String close, String open) = readerInlineTagBalanceForSplit(
        '<sup><small class="x">y</small></sup>',
        24,
      );
      expect(close, '</small></sup>');
      expect(open, '<sup><small class="x">'); // 保留屬性
    });

    test('無開啟標籤 → 空', () {
      final (String close, String open) = readerInlineTagBalanceForSplit(
        'plain text',
        4,
      );
      expect(close, '');
      expect(open, '');
    });
  });
}
