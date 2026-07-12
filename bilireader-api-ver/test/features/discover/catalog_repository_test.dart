import 'dart:io';

import 'package:bilireader/core/network/api_result.dart';
import 'package:bilireader/core/storage/database/app_database.dart';
import 'package:bilireader/core/text/chinese_converter.dart';
import 'package:bilireader/features/discover/data/catalog_remote_data_source.dart';
import 'package:bilireader/features/discover/data/catalog_repository_impl.dart';
import 'package:bilireader/features/discover/data/dto/chapter_data.dart';
import 'package:bilireader/features/discover/domain/novel_catalog.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// 回傳固定目錄樹，並記錄呼叫次數（驗證永久快取只打一次網路）。
class _FakeCatalogRemote implements CatalogRemoteDataSource {
  _FakeCatalogRemote(this.data);

  final ChapterData data;
  int calls = 0;

  @override
  Future<ChapterData> getChapterCatalog(int articleId) async {
    calls++;
    return data;
  }
}

void main() {
  late ChineseConverter converter;
  late AppDatabase db;

  setUpAll(() async {
    converter = ChineseConverter(loader: (String k) => File(k).readAsString());
    await converter.ensureLoaded();
  });

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  const ChapterData tree = ChapterData(
    articleid: 5,
    articlename: '测试小说',
    chapters: <ChapterRequestEntity>[
      ChapterRequestEntity(
        chapterid: 100,
        chaptername: '第一卷',
        chapterList: <ChapterRequestEntity>[
          ChapterRequestEntity(chapterid: 1, chaptername: '开始'),
          ChapterRequestEntity(chapterid: 2, chaptername: '战斗', chaptertype: 1),
        ],
      ),
    ],
  );

  test('目錄樹 → NovelCatalog，卷/章名轉繁、VIP 依 chaptertype', () async {
    final _FakeCatalogRemote remote = _FakeCatalogRemote(tree);
    final CatalogRepositoryImpl repo = CatalogRepositoryImpl(
      remote: remote,
      cacheDao: db.chapterCacheDao,
      converter: converter,
      clockMs: () => 123,
    );

    final ApiResult<NovelCatalog> result = await repo.catalog(5);
    final NovelCatalog catalog = (result as ApiSuccess<NovelCatalog>).data;

    expect(catalog.articleName, '測試小說');
    expect(catalog.volumes.single.title, '第一卷');
    expect(catalog.chapterCount, 2);
    final List<CatalogChapter> chapters = catalog.volumes.single.chapters;
    expect(chapters[0].title, '開始');
    expect(chapters[0].isVip, isFalse);
    expect(chapters[1].title, '戰鬥');
    expect(chapters[1].isVip, isTrue); // chaptertype != 0
  });

  test('永久快取：第二次呼叫不再打網路（drift 命中）', () async {
    final _FakeCatalogRemote remote = _FakeCatalogRemote(tree);
    final CatalogRepositoryImpl repo = CatalogRepositoryImpl(
      remote: remote,
      cacheDao: db.chapterCacheDao,
      converter: converter,
      clockMs: () => 123,
    );

    await repo.catalog(5);
    await repo.catalog(5);
    expect(remote.calls, 1);
  });
}
