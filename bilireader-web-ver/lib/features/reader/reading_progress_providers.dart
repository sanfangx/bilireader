import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/session/auth_controller.dart';
import '../../core/storage/database/database_providers.dart';
import 'data/bookmark_local_data_source.dart';
import 'data/reading_progress_local_data_source.dart';
import 'data/reading_progress_repository_impl.dart';
import 'domain/reading_progress.dart';
import 'domain/reading_progress_repository.dart';

part 'reading_progress_providers.g.dart';

/// 閱讀進度本地資料來源（drift）。
@Riverpod(keepAlive: true)
ReadingProgressLocalDataSource readingProgressLocalDataSource(Ref ref) =>
    ReadingProgressLocalDataSource(ref.watch(readingProgressDaoProvider));

/// 閱讀進度 repository（本地）。書架「繼續閱讀」與閱讀器共用同一 seam。
@Riverpod(keepAlive: true)
ReadingProgressRepository readingProgressRepository(Ref ref) =>
    ReadingProgressRepositoryImpl(
      ref.watch(readingProgressLocalDataSourceProvider),
    );

/// 書籤本地資料來源（drift）。閱讀器書籤面板與加入/移除共用。
@Riverpod(keepAlive: true)
BookmarkLocalDataSource bookmarkLocalDataSource(Ref ref) =>
    BookmarkLocalDataSource(ref.watch(bookmarkDaoProvider));

/// 目前使用者 uid（owner-scoped 本地資料的 key）。
///
/// web 適配：api-ver 由 `sessionStore.readUid()`（Riverpod）取；web-ver 從 [AuthController]
/// 單例的 `session.profile.userId`（String，/user.php 解析）轉 int，訪客/未登入 → 0。
/// 非 Riverpod-reactive；登入/登出後如需即時刷新，呼叫端自行 invalidate 相關 provider。
int readerOwnerUid() {
  final String? uid = AuthController.instance.session?.profile?.userId;
  return int.tryParse(uid ?? '') ?? 0;
}

/// 書架「繼續閱讀」串流：觀察本地 reading progress，閱讀器寫入後即時刷新。
@riverpod
Stream<List<ReadingProgress>> continueReading(Ref ref) =>
    ref.watch(readingProgressRepositoryProvider).watchAll(readerOwnerUid());
