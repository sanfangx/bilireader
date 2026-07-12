import 'package:bilireader_app/features/reader/domain/bookmark.dart';
import 'package:bilireader_app/features/reader/domain/reader_anchor.dart';
import 'package:bilireader_app/features/reader/domain/reading_progress.dart';
import 'package:flutter_test/flutter_test.dart';

/// 忠實移植 Step 2：freezed domain models 的 JSON round-trip
/// （drift 以 anchorJson 持久化，序列化正確性是資料完整性關鍵）。
void main() {
  test('ReaderAnchor round-trip 保欄位', () {
    const a = ReaderAnchor(
      articleId: 2013,
      chapterId: 317878,
      chapterName: '序章',
      sourceTextOffset: 42,
      visibleTextOffset: 40,
      blockIndex: 3,
      textQuote: '眼前是懸崖',
      progressInChapter: 0.1,
      updatedAt: 123,
    );
    final back = ReaderAnchor.fromJson(a.toJson());
    expect(back, a);
    expect(back.sourceTextOffset, 42);
    expect(back.textQuote, '眼前是懸崖');
  });

  // ⚠️ 重要（移植筆記）：api-ver drift 將 ReadingProgress/Bookmark **拆成欄位 + anchorJson**
  // （anchorJson 只存 leaf ReaderAnchor），**不整體 toJson**。故 repository 移植時序列化的是
  // `anchor.toJson()`，不是整個 ReadingProgress/Bookmark（後者的 nested toJson 未啟用
  // explicit_to_json，會壞——但實際路徑不走它）。以下測真實持久化路徑：
  test('ReadingProgress/Bookmark 的 anchor 各自可 round-trip（真實 anchorJson 路徑）', () {
    const anchor = ReaderAnchor(
      articleId: 2013,
      chapterId: 1,
      chapterName: '序章',
      sourceTextOffset: 5,
      textQuote: '片段',
    );
    const p =
        ReadingProgress(ownerUid: 1, anchor: anchor, articleName: '無職轉生');
    const b = Bookmark(
        ownerUid: 1, anchor: anchor, articleName: '無職轉生', id: 7);

    expect(ReaderAnchor.fromJson(p.anchor.toJson()), anchor);
    expect(ReaderAnchor.fromJson(b.anchor.toJson()), anchor);
    expect(p.articleName, '無職轉生');
    expect(b.id, 7);
  });
}
