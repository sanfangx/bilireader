import 'package:bilireader_app/core/storage/database/app_database.dart';
import 'package:bilireader_app/features/reader/content_block.dart';
import 'package:bilireader_app/features/reader/data/chapter_content_source.dart';
import 'package:bilireader_app/features/reader/data/chapter_text_repository.dart';
import 'package:bilireader_app/features/reader/domain/chapter_text.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// Step 3 內容橋接：倉儲層（drift 快取優先 + 擷取寫回 + VIP/空章不快取 + in-flight dedupe）。
///
/// 用可控假來源記錄 load 次數，驗證快取命中不重打、VIP 不污染快取、並發合併為單次擷取。
class _FakeSource implements ChapterContentSource {
  _FakeSource(this._content);

  final ChapterContent Function(String url) _content;
  int loadCount = 0;
  final List<String> urls = <String>[];

  @override
  Future<ChapterContent> load(String url) async {
    loadCount++;
    urls.add(url);
    // 模擬非同步擷取，讓並發 dedupe 有機會合併。
    await Future<void>.delayed(const Duration(milliseconds: 5));
    return _content(url);
  }
}

ChapterContent _body(List<ContentBlock> blocks, {String? title}) =>
    ChapterContent(title: title, blocks: blocks);

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('未命中 → 擷取 + 合成 + 寫回快取', () async {
    final _FakeSource src = _FakeSource(
      (_) => _body(<ContentBlock>[ContentBlock.text('第一段')], title: '序章'),
    );
    final ChapterTextRepository repo = ChapterTextRepository(
      source: src,
      cacheDao: db.chapterCacheDao,
      clockMs: () => 1000,
    );

    final ChapterText t = await repo.getChapterText(
      articleId: 42,
      chapterId: 7,
      url: 'https://tw.linovelib.com/novel/42/7.html',
      chapterName: '備援',
    );
    expect(t.chapterName, '序章'); // 擷取 title 優先
    expect(t.text, '第一段');
    expect(src.loadCount, 1);
    expect(await repo.isCached(articleId: 42, chapterId: 7), isTrue);
  });

  test('命中快取 → 不再擷取', () async {
    final _FakeSource src = _FakeSource(
      (_) => _body(<ContentBlock>[ContentBlock.text('內文')]),
    );
    final ChapterTextRepository repo = ChapterTextRepository(
      source: src,
      cacheDao: db.chapterCacheDao,
    );
    Future<ChapterText> get() => repo.getChapterText(
      articleId: 1,
      chapterId: 2,
      url: 'u',
      chapterName: 'c',
    );
    await get();
    await get(); // 第二次應走快取
    expect(src.loadCount, 1);
  });

  test('VIP/空章 → 拋 ChapterUnavailableException 且不快取', () async {
    final _FakeSource src = _FakeSource((_) => _body(<ContentBlock>[]));
    final ChapterTextRepository repo = ChapterTextRepository(
      source: src,
      cacheDao: db.chapterCacheDao,
    );
    await expectLater(
      repo.getChapterText(articleId: 5, chapterId: 9, url: 'u'),
      throwsA(isA<ChapterUnavailableException>()),
    );
    expect(await repo.isCached(articleId: 5, chapterId: 9), isFalse);
  });

  test('in-flight dedupe：同章並發只擷取一次', () async {
    final _FakeSource src = _FakeSource(
      (_) => _body(<ContentBlock>[ContentBlock.text('x')]),
    );
    final ChapterTextRepository repo = ChapterTextRepository(
      source: src,
      cacheDao: db.chapterCacheDao,
    );
    final List<ChapterText> results = await Future.wait(<Future<ChapterText>>[
      repo.getChapterText(articleId: 1, chapterId: 1, url: 'u'),
      repo.getChapterText(articleId: 1, chapterId: 1, url: 'u'),
      repo.getChapterText(articleId: 1, chapterId: 1, url: 'u'),
    ]);
    expect(results.length, 3);
    expect(src.loadCount, 1); // 三個並發合併為一次擷取
  });

  test('快取 round-trip 保圖片 URL 與交錯順序', () async {
    final _FakeSource src = _FakeSource(
      (_) => _body(<ContentBlock>[
        ContentBlock.text('圖前'),
        ContentBlock.image('https://tw.linovelib.com/i/a.jpg'),
        ContentBlock.text('圖後'),
      ]),
    );
    final ChapterTextRepository repo = ChapterTextRepository(
      source: src,
      cacheDao: db.chapterCacheDao,
    );
    final ChapterText fresh = await repo.getChapterText(
      articleId: 3,
      chapterId: 4,
      url: 'u',
    );
    // 第二次從快取解碼，應與新鮮擷取一致。
    final ChapterText cached = await repo.getChapterText(
      articleId: 3,
      chapterId: 4,
      url: 'u',
    );
    expect(cached.text, fresh.text);
    expect(
      cached.text,
      '圖前\n<img src="https://tw.linovelib.com/i/a.jpg">\n圖後',
    );
    expect(cached.images.single.url, 'https://tw.linovelib.com/i/a.jpg');
  });

  // ---- 下載 bug 修復（2026-07-11）：離線下載內容最優先、不寫 drift ----

  test('離線命中 → 不擷取、不寫 drift（本機圖絕對路徑不得持久化）', () async {
    final _FakeSource src = _FakeSource(
      (_) => _body(<ContentBlock>[ContentBlock.text('線上版')]),
    );
    int offlineCalls = 0;
    final ChapterTextRepository repo = ChapterTextRepository(
      source: src,
      cacheDao: db.chapterCacheDao,
      offlineLookup: (int aid, int cid) async {
        offlineCalls++;
        return ChapterContent(
          title: '離線章名',
          blocks: <ContentBlock>[
            ContentBlock.text('離線段落'),
            ContentBlock.image('/data/user/0/app/offline/42/img/c0_0.jpg'),
          ],
        );
      },
    );

    final ChapterText t = await repo.getChapterText(
      articleId: 42,
      chapterId: 7,
      url: 'https://tw.linovelib.com/novel/42/7.html',
    );
    expect(offlineCalls, 1);
    expect(src.loadCount, 0); // 未走線上擷取
    expect(t.chapterName, '離線章名');
    expect(t.text, contains('離線段落'));
    expect(t.text, contains('/data/user/0/app/offline/42/img/c0_0.jpg'));
    // 不寫 drift：本機絕對路徑不可持久化（iOS 容器路徑會變）。
    expect(await repo.isCached(articleId: 42, chapterId: 7), isFalse);
  });

  test('離線未命中（null）→ 照走線上擷取 + 寫快取', () async {
    final _FakeSource src = _FakeSource(
      (_) => _body(<ContentBlock>[ContentBlock.text('線上版')]),
    );
    final ChapterTextRepository repo = ChapterTextRepository(
      source: src,
      cacheDao: db.chapterCacheDao,
      offlineLookup: (int aid, int cid) async => null,
    );
    final ChapterText t = await repo.getChapterText(
      articleId: 1,
      chapterId: 2,
      url: 'u',
    );
    expect(src.loadCount, 1);
    expect(t.text, '線上版');
    expect(await repo.isCached(articleId: 1, chapterId: 2), isTrue);
  });
}
