import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import 'app_error.dart';

/// 給使用者看的預設訊息（繁體中文）。伺服器回傳的 message 可能為簡體，
/// presentation 顯示前仍須經 OpenCC 轉繁（規範 §5.0）。
abstract final class _Messages {
  static const String timeout = '網路連線逾時，請稍後再試';
  static const String network = '網路連線失敗';
  static const String unknown = '網路錯誤';
  static const String tokenInvalid = '登入狀態已失效，請重新登入';
  static const String accountBanned = '帳號已被封禁，請聯絡管理員';
  static const String updateRequired = '請更新至最新版本後再繼續使用';
  static const String operationFailed = '操作失敗';
  static const String emptyData = '資料為空';
}

/// 將 [DioException]、HTTP 狀態與業務碼統一映射為 [AppError]（規範 §7.2）。
/// 不得讓 raw Dio exception / raw JSON / HTTP 細節直接進入 UI。
abstract final class ErrorMapper {
  /// 從 Dio 例外映射。`cancel` 視為靜默取消（規範 §7.0）。
  static AppError fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.cancel:
        return AppError(kind: AppErrorKind.cancelled, message: '', cause: e);
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.transformTimeout:
        return AppError(
          kind: AppErrorKind.timeout,
          message: _Messages.timeout,
          cause: e,
        );
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
        return AppError(
          kind: AppErrorKind.network,
          message: _Messages.network,
          cause: e,
        );
      case DioExceptionType.badResponse:
        return fromResponse(
          statusCode: e.response?.statusCode,
          body: e.response?.data,
          cause: e,
        );
      case DioExceptionType.unknown:
        return AppError(
          kind: AppErrorKind.unknown,
          message: _Messages.unknown,
          cause: e,
        );
    }
  }

  /// 從 HTTP 回應（狀態碼 + body）映射。優先採用 body 內的業務碼。
  static AppError fromResponse({
    required int? statusCode,
    required Object? body,
    Object? cause,
  }) {
    final int? businessCode = _extractCode(body);
    if (businessCode != null && businessCode != ApiConstants.codeSuccess) {
      return fromBusinessCode(
        code: businessCode,
        serverMessage: _extractMessage(body),
        cause: cause,
      );
    }
    if (statusCode == ApiConstants.codeUpdateRequired) {
      return AppError(
        kind: AppErrorKind.forceUpdate,
        code: ApiConstants.codeUpdateRequired,
        message: _Messages.updateRequired,
        cause: cause,
      );
    }
    return AppError(
      kind: AppErrorKind.server,
      code: statusCode,
      message: '請求失敗：${statusCode ?? '未知'}',
      cause: cause,
    );
  }

  /// 從業務碼映射。401/666 → unauthorized；501 → forceUpdate；其餘 → server。
  static AppError fromBusinessCode({
    required int code,
    String? serverMessage,
    Object? cause,
  }) {
    final String? server =
        (serverMessage != null && serverMessage.trim().isNotEmpty)
        ? serverMessage
        : null;
    switch (code) {
      case ApiConstants.codeTokenInvalid:
        return AppError(
          kind: AppErrorKind.unauthorized,
          code: code,
          message: server ?? _Messages.tokenInvalid,
          cause: cause,
        );
      case ApiConstants.codeAccountBanned:
        return AppError(
          kind: AppErrorKind.unauthorized,
          code: code,
          message: server ?? _Messages.accountBanned,
          cause: cause,
        );
      case ApiConstants.codeUpdateRequired:
        return AppError(
          kind: AppErrorKind.forceUpdate,
          code: code,
          message: server ?? _Messages.updateRequired,
          cause: cause,
        );
      default:
        return AppError(
          kind: AppErrorKind.server,
          code: code,
          message: server ?? _Messages.operationFailed,
          cause: cause,
        );
    }
  }

  /// 業務碼 200 但 data 為 null（規範 §7.0：需 data 的端點視為錯誤）。
  static AppError emptyData({Object? cause}) => AppError(
    kind: AppErrorKind.server,
    code: ApiConstants.codeSuccess,
    message: _Messages.emptyData,
    cause: cause,
  );

  /// 本地儲存錯誤。
  static AppError storage(Object cause) => AppError(
    kind: AppErrorKind.storage,
    message: _Messages.operationFailed,
    cause: cause,
  );

  /// 回應解析錯誤（型別不符、缺欄位等）；不得讓 raw error 流入 UI（規範 §7.2）。
  static AppError parse(Object cause) => AppError(
    kind: AppErrorKind.parse,
    message: _Messages.operationFailed,
    cause: cause,
  );

  static int? _extractCode(Object? body) {
    if (body is Map) {
      final Object? raw = body['code'];
      if (raw is num) {
        return raw.toInt();
      }
    }
    return null;
  }

  static String? _extractMessage(Object? body) {
    if (body is Map) {
      final Object? raw = body['message'] ?? body['msg'];
      if (raw is String) {
        return raw;
      }
    }
    return null;
  }
}
