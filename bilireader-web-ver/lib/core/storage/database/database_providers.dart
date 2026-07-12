import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_database.dart';

part 'database_providers.g.dart';

/// 全域 [AppDatabase]。正式環境開啟檔案型資料庫；測試以 override 本 provider。
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final AppDatabase db = AppDatabase.open();
  ref.onDispose(db.close);
  return db;
}

@Riverpod(keepAlive: true)
ChapterCacheDao chapterCacheDao(Ref ref) =>
    ref.watch(appDatabaseProvider).chapterCacheDao;

@Riverpod(keepAlive: true)
BookmarkDao bookmarkDao(Ref ref) => ref.watch(appDatabaseProvider).bookmarkDao;

@Riverpod(keepAlive: true)
ReadingProgressDao readingProgressDao(Ref ref) =>
    ref.watch(appDatabaseProvider).readingProgressDao;
