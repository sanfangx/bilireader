import '../constants/api_constants.dart';

/// 統一回應信封 `BaseResponse<T>`（規範 §7.0，對照 apk/docs/API.md）。
///
/// wire key：`code`、`data`、`message`（相容別名 `msg`）。成功條件為
/// `code == 200 && data != null`（需要 data 的端點）。DTO 解析由 [fromData] 提供。
class BaseResponse<T> {
  const BaseResponse({required this.code, required this.message, this.data});

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? data) fromData,
  ) {
    final Object? rawData = json['data'];
    return BaseResponse<T>(
      code: _readCode(json),
      message: readMessage(json),
      data: rawData == null ? null : fromData(rawData),
    );
  }

  final int code;
  final String message;
  final T? data;

  /// 成功條件：業務碼 200 且 data 非空。
  bool get isSuccess => code == ApiConstants.codeSuccess && data != null;

  /// `message` 需同時相容 `message` 與 `msg`（規範 §7.0）。
  static String readMessage(Map<String, dynamic> json) {
    final Object? raw = json['message'] ?? json['msg'];
    return raw is String ? raw : '';
  }

  static int _readCode(Map<String, dynamic> json) {
    final Object? raw = json['code'];
    return raw is num ? raw.toInt() : -1;
  }
}

/// 無 data 的精簡信封 `BaseResponse2`（規範 §7.0）。用於 logout 等端點。
/// 成功條件僅 `code == 200`。
class BaseResponse2 {
  const BaseResponse2({required this.code, required this.message});

  factory BaseResponse2.fromJson(Map<String, dynamic> json) {
    final Object? rawCode = json['code'];
    return BaseResponse2(
      code: rawCode is num ? rawCode.toInt() : -1,
      message: BaseResponse.readMessage(json),
    );
  }

  final int code;
  final String message;

  bool get isSuccess => code == ApiConstants.codeSuccess;
}
