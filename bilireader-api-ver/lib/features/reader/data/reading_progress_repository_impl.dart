import '../domain/reading_progress.dart';
import '../domain/reading_progress_repository.dart';
import 'reading_progress_local_data_source.dart';

/// [ReadingProgressRepository] 實作：委派本地 drift 資料來源（規範 §5.5）。
/// 純本地，不觸網；顯示文字於寫入前已為繁體（閱讀器來源已轉繁）。
class ReadingProgressRepositoryImpl implements ReadingProgressRepository {
  const ReadingProgressRepositoryImpl(this._local);

  final ReadingProgressLocalDataSource _local;

  @override
  Stream<List<ReadingProgress>> watchAll(int ownerUid) =>
      _local.watchAll(ownerUid);

  @override
  Future<List<ReadingProgress>> getAll(int ownerUid) => _local.getAll(ownerUid);

  @override
  Future<ReadingProgress?> get(int ownerUid, int articleId) =>
      _local.get(ownerUid, articleId);

  @override
  Future<void> save(ReadingProgress progress) => _local.save(progress);
}
