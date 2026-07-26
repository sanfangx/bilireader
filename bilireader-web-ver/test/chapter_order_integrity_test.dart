import 'package:bilireader_app/features/reader/chapter_extractor.dart';
import 'package:flutter_test/flutter_test.dart';

/// 段落順序還原判定（靜默壞掉防線）。
///
/// 背景（2026-07-11 Chrome 實測）：tw.linovelib 伺服器對 navigation 與 XHR 都送出
/// **固定打亂**的 `#acontent` 段落（前 ~20 段固定、其餘為以章節為種子的排列），
/// 由站方 JS 於執行期還原。若在還原完成前擷取，會拿到亂序內容且無任何錯誤徵兆，
/// 還會被寫進 drift 快取／離線檔永久固化 → 必須主動判定。
void main() {
  group('classifyOrder', () {
    test('DOM 順序 == 伺服器打亂順序 → 尚未還原（應重試/不快取）', () {
      expect(
        ChapterExtractor.classifyOrder(
          liveCount: 109,
          servedCount: 109,
          identical: true,
        ),
        OrderCheck.unrestored,
      );
    });

    test('DOM 順序 != 伺服器順序 → 已還原（可擷取）', () {
      expect(
        ChapterExtractor.classifyOrder(
          liveCount: 109,
          servedCount: 109,
          identical: false,
        ),
        OrderCheck.restored,
      );
    });

    test('拿不到伺服器對照（servedCount < 0）→ 無法判別，不阻擋擷取', () {
      expect(
        ChapterExtractor.classifyOrder(
          liveCount: 109,
          servedCount: -1,
          identical: false,
        ),
        OrderCheck.indeterminate,
      );
    });

    test('段落數過少（打亂不生效）→ 無法判別，不阻擋擷取', () {
      // 前 ~20 段本就固定，短章節「順序相同」屬正常，不可誤判為壞掉。
      expect(
        ChapterExtractor.classifyOrder(
          liveCount: 12,
          servedCount: 12,
          identical: true,
        ),
        OrderCheck.indeterminate,
      );
    });

    test('剛好在判定門檻上下的邊界', () {
      expect(
        ChapterExtractor.classifyOrder(
          liveCount: ChapterExtractor.kMinParasToJudge - 1,
          servedCount: 30,
          identical: true,
        ),
        OrderCheck.indeterminate,
      );
      expect(
        ChapterExtractor.classifyOrder(
          liveCount: ChapterExtractor.kMinParasToJudge,
          servedCount: 30,
          identical: true,
        ),
        OrderCheck.unrestored,
      );
    });

    test('空章（0 段）→ 無法判別（交由既有的空內容偵測處理）', () {
      expect(
        ChapterExtractor.classifyOrder(
          liveCount: 0,
          servedCount: 0,
          identical: false,
        ),
        OrderCheck.indeterminate,
      );
    });
  });

  test('ChapterOrderNotRestoredException 帶出問題 URL 供診斷', () {
    const e = ChapterOrderNotRestoredException(
      'https://tw.linovelib.com/novel/2013/72034.html',
    );
    expect(e.toString(), contains('72034'));
  });
}
