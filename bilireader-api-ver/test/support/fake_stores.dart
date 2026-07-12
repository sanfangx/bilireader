import 'package:bilireader/core/network/api_result.dart';
import 'package:bilireader/core/storage/session_store.dart';
import 'package:bilireader/core/storage/token_store.dart';
import 'package:bilireader/features/system/domain/feedback_options.dart';
import 'package:bilireader/features/system/domain/system_entities.dart';
import 'package:bilireader/features/system/domain/system_repository.dart';

/// 記憶體版 TokenStore，供單元測試注入。
class FakeTokenStore implements TokenStore {
  String? token;

  @override
  Future<String?> read() async => token;

  @override
  Future<void> write(String value) async {
    token = value;
  }

  @override
  Future<void> delete() async {
    token = null;
  }
}

/// 記憶體版 SessionStore，套用與正式實作相同的 uid<=0 / groupId<0 過濾。
class FakeSessionStore implements SessionStore {
  int? uid;
  int? groupId;

  @override
  Future<int?> readUid() async => (uid == null || uid! <= 0) ? null : uid;

  @override
  Future<void> writeUid(int value) async {
    uid = value;
  }

  @override
  Future<int?> readGroupId() async =>
      (groupId == null || groupId! < 0) ? null : groupId;

  @override
  Future<void> writeGroupId(int value) async {
    groupId = value;
  }

  @override
  Future<void> clear() async {
    uid = null;
    groupId = null;
  }
}

/// 無網路版 SystemRepository，供 shell / golden / smoke 測試：啟動流程（版本檢查 /
/// 啟動公告 / 自動簽到）走安全預設，不觸網、不彈公告、不需更新。
class FakeSystemRepository implements SystemRepository {
  const FakeSystemRepository();

  @override
  Future<ApiResult<SignInResult>> signIn() async =>
      const ApiSuccess<SignInResult>(SignInResult(points: 0, totalScore: 0));

  @override
  Future<VersionCheck> checkVersion() async =>
      const VersionCheck(needUpdate: false);

  @override
  Future<ApiResult<List<VersionLog>>> changelog() async =>
      const ApiSuccess<List<VersionLog>>(<VersionLog>[]);

  @override
  Future<ApiResult<StartupAnnouncement?>> startupAnnouncement() async =>
      const ApiSuccess<StartupAnnouncement?>(null);

  @override
  Future<ApiResult<int>> submitFeedback({
    required FeedbackSort sort,
    required FeedbackType type,
    required String title,
    required String content,
  }) async => const ApiSuccess<int>(0);
}
