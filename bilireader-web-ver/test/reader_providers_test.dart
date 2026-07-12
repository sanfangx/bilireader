import 'package:bilireader_app/core/models/catalog.dart';
import 'package:bilireader_app/core/storage/database/app_database.dart';
import 'package:bilireader_app/core/storage/database/database_providers.dart';
import 'package:bilireader_app/features/reader/content_block.dart';
import 'package:bilireader_app/features/reader/data/chapter_content_source.dart';
import 'package:bilireader_app/features/reader/data/chapter_text_providers.dart';
import 'package:bilireader_app/features/reader/domain/reader_block.dart';
import 'package:bilireader_app/features/reader/presentation/reader_providers.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 忠實移植 Step 6：readerChapterContent 編排（repository 快取 → ReaderContentBuilder → blocks），
/// 以 ProviderContainer + in-memory drift + 假來源驗證全鏈路。
class _FakeSource implements ChapterContentSource {
  _FakeSource(this.content);

  final ChapterContent content;
  int loadCount = 0;

  @override
  Future<ChapterContent> load(String url) async {
    loadCount++;
    return content;
  }
}

ProviderContainer _containerWith(AppDatabase db, _FakeSource src) {
  final ProviderContainer c = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      chapterContentSourceProvider.overrideWithValue(src),
    ],
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  test('擷取 → 合成 → 建構 blocks（章名優先擷取 title、文字/圖片交錯）', () async {
    final AppDatabase db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final _FakeSource src = _FakeSource(
      ChapterContent(
        title: '序章',
        blocks: <ContentBlock>[
          ContentBlock.text('第一段'),
          ContentBlock.image('https://tw.linovelib.com/i/a.jpg'),
          ContentBlock.text('第二段'),
        ],
      ),
    );
    final ProviderContainer c = _containerWith(db, src);

    final ReaderChapterContent r = await c.read(
      readerChapterContentProvider(
        const ChapterRef(
          articleId: 2013,
          chapterId: 1,
          url: 'https://tw.linovelib.com/novel/2013/1.html',
          chapterName: '備援章名',
        ),
      ).future,
    );

    expect(r.chapterName, '序章'); // 擷取 title 優先
    expect(r.blocks.whereType<ParagraphBlock>().length, 2);
    expect(r.blocks.whereType<ImageBlock>().length, 1);
    expect(src.loadCount, 1);
  });

  test('第二次讀走 drift 快取（不重擷取）', () async {
    final AppDatabase db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final _FakeSource src = _FakeSource(
      ChapterContent(
        title: '章',
        blocks: <ContentBlock>[ContentBlock.text('內文')],
      ),
    );
    const ChapterRef ref = ChapterRef(
      articleId: 7,
      chapterId: 3,
      url: 'u',
      chapterName: 'c',
    );

    final ProviderContainer c1 = _containerWith(db, src);
    await c1.read(readerChapterContentProvider(ref).future);
    expect(src.loadCount, 1);

    // 另開 container（provider 快取重置），但同一 db → 走 drift 快取。
    final ProviderContainer c2 = _containerWith(db, src);
    final ReaderChapterContent r2 =
        await c2.read(readerChapterContentProvider(ref).future);
    expect(src.loadCount, 1); // 未再擷取
    expect(r2.blocks.whereType<ParagraphBlock>().length, 1);
  });

  group('chapterNavAt', () {
    final List<Chapter> chapters = <Chapter>[
      const Chapter(title: 'c0', url: 'u0'),
      const Chapter(title: 'c1', url: 'u1'),
      const Chapter(title: 'c2', url: 'u2'),
    ];

    test('中間章：前後皆有', () {
      final ChapterNav nav = chapterNavAt(chapters, 1);
      expect(nav.index, 1);
      expect(nav.count, 3);
      expect(nav.hasPrev, isTrue);
      expect(nav.hasNext, isTrue);
      expect(nav.prev!.url, 'u0');
      expect(nav.next!.url, 'u2');
    });

    test('首章無前、末章無後', () {
      expect(chapterNavAt(chapters, 0).hasPrev, isFalse);
      expect(chapterNavAt(chapters, 0).hasNext, isTrue);
      expect(chapterNavAt(chapters, 2).hasNext, isFalse);
      expect(chapterNavAt(chapters, 2).hasPrev, isTrue);
    });

    test('越界索引 → index -1', () {
      expect(chapterNavAt(chapters, 9).index, -1);
      expect(chapterNavAt(chapters, -1).index, -1);
    });
  });
}
