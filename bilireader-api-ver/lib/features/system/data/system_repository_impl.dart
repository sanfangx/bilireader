import 'package:dio/dio.dart';

import '../../../core/network/api_result.dart';
import '../../../core/network/app_error.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/text/chinese_converter.dart';
import '../domain/feedback_options.dart';
import '../domain/system_entities.dart';
import '../domain/system_repository.dart';
import 'dto/system_dtos.dart';
import 'system_remote_data_source.dart';

/// [SystemRepository] 實作。伺服器顯示文字（公告 / 更新日誌）轉繁（§5.0）；
/// 使用者回饋標題/內容保留原文送出。
class SystemRepositoryImpl implements SystemRepository {
  SystemRepositoryImpl({
    required SystemRemoteDataSource remote,
    required ChineseConverter converter,
  }) : _remote = remote,
       _converter = converter;

  final SystemRemoteDataSource _remote;
  final ChineseConverter _converter;

  @override
  Future<ApiResult<SignInResult>> signIn() => _guard(() async {
    final ({SignInResponseDto data, bool alreadySigned}) r = await _remote
        .signIn();
    return SignInResult(
      points: r.data.points,
      totalScore: r.data.totalScore,
      alreadySigned: r.alreadySigned,
    );
  });

  @override
  Future<VersionCheck> checkVersion() async {
    // 網路失敗時 fail-open：不因暫時性錯誤把使用者鎖在強更畫面。
    try {
      return await _remote.checkVersion();
    } on Object {
      return const VersionCheck(needUpdate: false);
    }
  }

  @override
  Future<ApiResult<List<VersionLog>>> changelog() => _guard(() async {
    final List<VersionLogItemDto> list = await _remote.changelog();
    return list
        .map(
          (VersionLogItemDto e) => VersionLog(
            versionName: e.versionName ?? '',
            updateContent: _tw(e.updateContent),
            isCurrent: e.current,
          ),
        )
        .toList();
  });

  @override
  Future<ApiResult<StartupAnnouncement?>> startupAnnouncement() => _guard(
    () async {
      final AppStartupAnnouncementDto? d = await _remote.startupAnnouncement();
      if (d == null) {
        return null;
      }
      return StartupAnnouncement(
        bid: d.bid,
        title: _twNullable(d.title),
        content: _twNullable(d.content),
        actionText: _twNullable(d.actionText),
        actionUrl: d.actionUrl,
        dismissKey: d.dismissKey,
        description: _twNullable(d.description),
        latestVersionName: d.latestVersionName,
        latestVersionCode: d.latestVersionCode,
        latestUpdateContent: _twNullable(d.latestUpdateContent),
      );
    },
  );

  @override
  Future<ApiResult<int>> submitFeedback({
    required FeedbackSort sort,
    required FeedbackType type,
    required String title,
    required String content,
  }) => _guard(() async {
    final FeedbackSubmitResponseDto d = await _remote.submitFeedback(
      reportSort: sort.value,
      reportType: type.value,
      title: title,
      content: content,
    );
    return d.reportId;
  });

  // ---- helpers ----

  String _tw(String? text) =>
      (text == null || text.isEmpty) ? '' : _converter.toTraditionalTw(text);

  String? _twNullable(String? text) =>
      (text == null || text.isEmpty) ? text : _converter.toTraditionalTw(text);

  Future<ApiResult<T>> _guard<T>(Future<T> Function() body) async {
    try {
      await _converter.ensureLoaded();
      return ApiSuccess<T>(await body());
    } on DioException catch (e) {
      return ApiFailure<T>(ErrorMapper.fromDio(e));
    } on AppError catch (e) {
      return ApiFailure<T>(e);
    } on Object catch (e) {
      return ApiFailure<T>(ErrorMapper.parse(e));
    }
  }
}
