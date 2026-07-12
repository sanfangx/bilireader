import 'package:bilireader/core/storage/database/app_database.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('ChapterCacheDao', () {
    test('cache miss → null；save → hit；replace 覆蓋', () async {
      final ChapterCacheDao dao = db.chapterCacheDao;
      expect(await dao.getChapterContent(1, 1), isNull);

      await dao.saveChapterContent(
        articleId: 1,
        chapterId: 1,
        payload: 'p1',
        updatedAt: 100,
      );
      expect((await dao.getChapterContent(1, 1))?.payload, 'p1');

      await dao.saveChapterContent(
        articleId: 1,
        chapterId: 1,
        payload: 'p2',
        updatedAt: 200,
      );
      expect((await dao.getChapterContent(1, 1))?.payload, 'p2');
    });

    test('guard：article/chapter id <= 0 不寫入也不回傳', () async {
      final ChapterCacheDao dao = db.chapterCacheDao;
      await dao.saveChapterContent(
        articleId: -1,
        chapterId: 1,
        payload: 'x',
        updatedAt: 1,
      );
      expect(await dao.getChapterContent(-1, 1), isNull);
      expect(await dao.getChapterContent(0, 0), isNull);
    });

    test(
      'catalog save/get 與 getAllCatalogArticleIds 依 updatedAt 由新到舊',
      () async {
        final ChapterCacheDao dao = db.chapterCacheDao;
        await dao.saveCatalog(
          articleId: 5,
          articleName: '書A',
          payload: 'c5',
          updatedAt: 100,
        );
        await dao.saveCatalog(
          articleId: 9,
          articleName: '書B',
          payload: 'c9',
          updatedAt: 300,
        );
        await dao.saveCatalog(
          articleId: 7,
          articleName: '書C',
          payload: 'c7',
          updatedAt: 200,
        );
        expect((await dao.getCatalog(9))?.articleName, '書B');
        expect(await dao.getAllCatalogArticleIds(), <int>[9, 7, 5]);
      },
    );
  });

  group('PrivateMessageDao（owner-scoped）', () {
    test(
      'upsert + getMessages 依 postDate/messageId 排序；clearOwner 只清該 owner',
      () async {
        final PrivateMessageDao dao = db.privateMessageDao;
        await dao.upsertMessages(<PrivateMessagesCompanion>[
          PrivateMessagesCompanion.insert(
            ownerUid: 1,
            messageId: 2,
            peerId: 9,
            postDate: const Value<int>(200),
          ),
          PrivateMessagesCompanion.insert(
            ownerUid: 1,
            messageId: 1,
            peerId: 9,
            postDate: const Value<int>(100),
          ),
          PrivateMessagesCompanion.insert(
            ownerUid: 2,
            messageId: 3,
            peerId: 9,
            postDate: const Value<int>(50),
          ),
        ]);

        final List<PrivateMessageRow> msgs = await dao.getMessages(1, 9);
        expect(msgs.map((PrivateMessageRow m) => m.messageId).toList(), <int>[
          1,
          2,
        ]);

        await dao.clearOwner(1);
        expect(await dao.getMessages(1, 9), isEmpty);
        expect((await dao.getMessages(2, 9)).length, 1);
      },
    );

    test('shouldSync + markSynced', () async {
      final PrivateMessageDao dao = db.privateMessageDao;
      expect(await dao.shouldSync(1, 9, maxAgeMs: 1000, nowMs: 5000), isTrue);
      await dao.markSynced(1, 9, 5000);
      expect(await dao.shouldSync(1, 9, maxAgeMs: 1000, nowMs: 5500), isFalse);
      expect(await dao.shouldSync(1, 9, maxAgeMs: 1000, nowMs: 6500), isTrue);
    });
  });
}
