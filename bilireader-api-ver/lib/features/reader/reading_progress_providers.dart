import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/di/infra_providers.dart';
import '../../core/router/auth_controller.dart';
import '../../core/storage/database/database_providers.dart';
import 'data/reading_progress_local_data_source.dart';
import 'data/reading_progress_repository_impl.dart';
import 'domain/reading_progress.dart';
import 'domain/reading_progress_repository.dart';

part 'reading_progress_providers.g.dart';

/// 閱讀進度本地資料來源（drift）。
@Riverpod(keepAlive: true)
ReadingProgressLocalDataSource readingProgressLocalDataSource(Ref ref) =>
    ReadingProgressLocalDataSource(ref.watch(readingProgressDaoProvider));

/// 閱讀進度 repository（本地）。書架「繼續閱讀」與閱讀器共用同一 seam（§5.5）。
@Riverpod(keepAlive: true)
ReadingProgressRepository readingProgressRepository(Ref ref) =>
    ReadingProgressRepositoryImpl(
      ref.watch(readingProgressLocalDataSourceProvider),
    );

/// 目前登入使用者 uid（owner-scoped 本地資料的 key）。未登入為 null。
/// 依賴 [authControllerProvider]，登入/登出/401·666 後自動重讀（§6.3）。
@riverpod
Future<int?> currentOwnerUid(Ref ref) async {
  ref.watch(authControllerProvider);
  return ref.watch(sessionStoreProvider).readUid();
}

/// 書架「繼續閱讀」串流：觀察本地 reading progress，閱讀器寫入後即時刷新（§5.5、§6.2）。
/// 未登入時回傳空清單。
@riverpod
Stream<List<ReadingProgress>> continueReading(Ref ref) async* {
  final int? uid = await ref.watch(currentOwnerUidProvider.future);
  if (uid == null) {
    yield const <ReadingProgress>[];
    return;
  }
  yield* ref.watch(readingProgressRepositoryProvider).watchAll(uid);
}
