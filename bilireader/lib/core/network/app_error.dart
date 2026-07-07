import 'package:flutter/foundation.dart';

/// 錯誤分類（規範 §7.2）。
enum AppErrorKind {
  /// 網路連線失敗。
  network,

  /// 連線 / 讀寫逾時。
  timeout,

  /// 登入態失效（業務碼 401 / 666）。
  unauthorized,

  /// 需強制更新（業務碼 / HTTP 501）。
  forceUpdate,

  /// 伺服器回應業務錯誤或 HTTP 非 2xx。
  server,

  /// 回應解析失敗。
  parse,

  /// 本地儲存錯誤。
  storage,

  /// 請求被取消（靜默，不顯示錯誤）。
  cancelled,

  /// 其他未分類錯誤。
  unknown,
}

/// 統一領域錯誤（規範 §7.2）。不得讓 raw Dio exception / raw JSON / HTTP 細節
/// 直接進入 UI；一律轉為 [AppError]。
///
/// [message] 為給使用者看的訊息；對已知分類使用繁體中文預設值。
/// 注意：伺服器回傳的 [message] 可能為簡體，presentation 顯示前仍須經 OpenCC
/// 轉繁（規範 §5.0，OpenCC 於後續階段建立）。
@immutable
class AppError implements Exception {
  const AppError({
    required this.kind,
    required this.message,
    this.code,
    this.cause,
  });

  final AppErrorKind kind;
  final String message;

  /// 業務碼或 HTTP 狀態碼（若有）。
  final int? code;

  /// 原始例外，供除錯（不得輸出到 UI）。
  final Object? cause;

  bool get isUnauthorized => kind == AppErrorKind.unauthorized;
  bool get isCancelled => kind == AppErrorKind.cancelled;
  bool get requiresUpdate => kind == AppErrorKind.forceUpdate;

  @override
  String toString() => 'AppError(kind: $kind, code: $code, message: $message)';
}
