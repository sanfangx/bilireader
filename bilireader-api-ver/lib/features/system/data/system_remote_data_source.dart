import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/base_response.dart';
import '../../../core/network/error_mapper.dart';
import '../domain/system_entities.dart';
import 'dto/system_dtos.dart';

/// 系統 / 任務 / 版本 / 公告 / 回饋端點（API.md §8.6-8.9 + system/feedback）。
///
/// sign_in / version/* / startupAnnouncement 皆無參數 POST；feedback/submit 為 Body。
/// version/check 特別以寬鬆 validateStatus 讀取 501 與 `appUrl`（強更判定不可被錯誤映射吞掉）。
class SystemRemoteDataSource {
  const SystemRemoteDataSource(this._dio);

  final Dio _dio;

  /// 回傳簽到資料 + 是否「今日已簽」。**「已簽到」＝與伺服器確認的既定狀態，非錯誤**：
  /// code==201，或**任何非成功回應（code!=200）其訊息提及「簽到/签到」**→ alreadySigned
  /// （不拋、不視為失敗；比照 `AutoSignInManager`，並放寬以涵蓋伺服器實際回覆之各種措辭，
  /// 如「今日已经签到」「重复签到」等——修正重裝後簽不了卻一直重試的問題）。其餘非 200 才拋。
  Future<({SignInResponseDto data, bool alreadySigned})> signIn() async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.taskSignIn,
    );
    final BaseResponse<SignInResponseDto> base = _base(
      resp,
      (Object? d) => SignInResponseDto.fromJson(_map(d)),
    );
    final String message = base.message;
    final bool mentionsSignIn =
        message.contains('签到') || message.contains('簽到');
    if (base.code == ApiConstants.codeSignedInAlready ||
        (base.code != ApiConstants.codeSuccess && mentionsSignIn)) {
      return (data: const SignInResponseDto(), alreadySigned: true);
    }
    _ensure(base);
    return (data: base.data ?? const SignInResponseDto(), alreadySigned: false);
  }

  /// `version/check`：讀 HTTP 狀態 / body.code 是否 501（強更），並取動態 Map 的 `appUrl`。
  Future<VersionCheck> checkVersion() async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.versionCheck,
      options: Options(
        validateStatus: (int? s) => s != null && s >= 200 && s < 600,
      ),
    );
    final Map<String, dynamic> body = _map(resp.data);
    final int? bodyCode = (body['code'] as num?)?.toInt();
    final bool need =
        resp.statusCode == ApiConstants.codeUpdateRequired ||
        bodyCode == ApiConstants.codeUpdateRequired;
    final Map<String, dynamic> data = _map(body['data']);
    final Object? url = data['appUrl'];
    return VersionCheck(
      needUpdate: need,
      appUrl: url is String && url.isNotEmpty ? url : null,
    );
  }

  Future<List<VersionLogItemDto>> changelog() async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.versionChangelog,
    );
    final BaseResponse<List<VersionLogItemDto>> base = _base(resp, (Object? d) {
      final List<dynamic> list = d is List ? d : const <dynamic>[];
      return list
          .whereType<Map<String, dynamic>>()
          .map(VersionLogItemDto.fromJson)
          .toList();
    });
    _ensure(base);
    return base.data ?? const <VersionLogItemDto>[];
  }

  /// `system/startupAnnouncement`：無公告時 data 為 null → 回 null。
  Future<AppStartupAnnouncementDto?> startupAnnouncement() async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.startupAnnouncement,
    );
    final BaseResponse<AppStartupAnnouncementDto?> base = _base(resp, (
      Object? d,
    ) {
      return d is Map<String, dynamic> && d.isNotEmpty
          ? AppStartupAnnouncementDto.fromJson(d)
          : null;
    });
    _ensure(base);
    return base.data;
  }

  /// `feedback/submit`（Body）→ {reportId}。需登入。
  Future<FeedbackSubmitResponseDto> submitFeedback({
    required int reportSort,
    required int reportType,
    required String title,
    required String content,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.feedbackSubmit,
      data: <String, dynamic>{
        'reportSort': reportSort,
        'reportType': reportType,
        'title': title,
        'content': content,
      },
    );
    final BaseResponse<FeedbackSubmitResponseDto> base = _base(
      resp,
      (Object? d) => FeedbackSubmitResponseDto.fromJson(_map(d)),
    );
    _ensure(base);
    return base.data ?? const FeedbackSubmitResponseDto();
  }

  // ---- helpers ----

  Map<String, dynamic> _map(Object? d) =>
      d is Map<String, dynamic> ? d : const <String, dynamic>{};

  BaseResponse<T> _base<T>(
    Response<dynamic> resp,
    T Function(Object? data) fromData,
  ) {
    final Object? body = resp.data;
    final Map<String, dynamic> map = body is Map<String, dynamic>
        ? body
        : const <String, dynamic>{};
    return BaseResponse<T>.fromJson(map, fromData);
  }

  void _ensure<T>(BaseResponse<T> base) {
    if (base.code != ApiConstants.codeSuccess) {
      throw ErrorMapper.fromBusinessCode(
        code: base.code,
        serverMessage: base.message,
      );
    }
  }
}
