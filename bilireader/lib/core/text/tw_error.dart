import '../network/app_error.dart';
import 'chinese_converter.dart';

/// 把錯誤轉成可顯示的繁體訊息（規範 §5.0）。server 端錯誤訊息可能為簡體，
/// 顯示前一律經 OpenCC 轉繁；轉換失敗時回退原文，避免再拋例外。
String twErrorMessage(ChineseConverter converter, Object? error) {
  final String raw = error is AppError ? error.message : '發生錯誤，請稍後再試';
  try {
    return converter.toTraditionalTw(raw);
  } on Object catch (_) {
    return raw;
  }
}
