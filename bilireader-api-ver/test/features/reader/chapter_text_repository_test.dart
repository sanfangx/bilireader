import 'package:bilireader/core/network/api_result.dart';
import 'package:bilireader/core/storage/database/app_database.dart';
import 'package:bilireader/features/reader/data/chapter_text_remote_data_source.dart';
import 'package:bilireader/features/reader/data/chapter_text_repository_impl.dart';
import 'package:bilireader/features/reader/data/dto/text_request_entity.dart';
import 'package:bilireader/features/reader/domain/chapter_text.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// 假 remote：記錄呼叫次數，回固定 TextRequestEntity。不觸網。
class _FakeChapterTextRemote implements ChapterTextRemoteDataSource {
  _FakeChapterTextRemote(this.entity);

  final TextRequestEntity entity;
  int calls = 0;

  @override
  Future<TextRequestEntity> getNovelText({
    required int articleId,
    required int chapterId,
  }) async {
    calls++;
    return entity;
  }
}

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() async => db.close());

  const TextRequestEntity sample = TextRequestEntity(
    articleId: 7,
    chapterId: 3,
    chapterName: '雨夜來客',
    text: '第一段\n<img src="x">',
    images: <ChapterImageDto>[
      ChapterImageDto(
        path: 'https://img3.readpai.com/2020/a.jpg',
        aspectRatio: 1.5,
      ),
    ],
    isbody: 1,
  );

  test('網路未命中 → fetch + 寫永久快取 + 映射（img3→img2/attachment）', () async {
    final remote = _FakeChapterTextRemote(sample);
    final repo = ChapterTextRepositoryImpl(
      remote: remote,
      cacheDao: db.chapterCacheDao,
      clockMs: () => 0,
    );
    final ChapterText t =
        ((await repo.getChapterText(articleId: 7, chapterId: 3))
                as ApiSuccess<ChapterText>)
            .data;
    expect(remote.calls, 1);
    expect(t.chapterName, '雨夜來客');
    expect(t.text, '第一段\n<img src="x">'); // 原文保留（OpenCC 於顯示層）
    expect(
      t.images.single.url,
      'https://img2.readpai.com/attachment/2020/a.jpg',
    );
    expect(t.images.single.aspectRatio, 1.5);
    // 已寫入永久快取。
    expect(await db.chapterCacheDao.getChapterContent(7, 3), isNotNull);
  });

  test('第二次 → 永久快取命中，不再打網路', () async {
    final remote = _FakeChapterTextRemote(sample);
    final repo = ChapterTextRepositoryImpl(
      remote: remote,
      cacheDao: db.chapterCacheDao,
      clockMs: () => 0,
    );
    await repo.getChapterText(articleId: 7, chapterId: 3);
    await repo.getChapterText(articleId: 7, chapterId: 3);
    expect(remote.calls, 1); // 第二次走快取
  });

  test('downloadChapter：已快取則略過網路；isCached 反映狀態', () async {
    final remote = _FakeChapterTextRemote(sample);
    final repo = ChapterTextRepositoryImpl(
      remote: remote,
      cacheDao: db.chapterCacheDao,
      clockMs: () => 0,
    );
    expect(await repo.isCached(articleId: 7, chapterId: 3), isFalse);
    await repo.downloadChapter(articleId: 7, chapterId: 3);
    expect(remote.calls, 1);
    expect(await repo.isCached(articleId: 7, chapterId: 3), isTrue);
    await repo.downloadChapter(articleId: 7, chapterId: 3);
    expect(remote.calls, 1); // 已快取，不重打
  });
}
