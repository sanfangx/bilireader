import 'app_error.dart';

/// 網路 / 資料操作結果（規範 §7.2）。以 sealed 型別表達成功與失敗，
/// 呼叫端以 switch 窮舉處理，不得讓 raw exception 流入 UI。
sealed class ApiResult<T> {
  const ApiResult();

  bool get isSuccess => this is ApiSuccess<T>;

  T? get dataOrNull => switch (this) {
    ApiSuccess<T>(:final T data) => data,
    ApiFailure<T>() => null,
  };

  AppError? get errorOrNull => switch (this) {
    ApiSuccess<T>() => null,
    ApiFailure<T>(:final AppError error) => error,
  };

  /// 成功回傳資料；失敗則 throw 已分類的 [AppError]。供 `AsyncValue` 型 provider
  /// 直接把失敗轉為 `AsyncError`（UI 以 [AppError.message] 顯示，規範 §5.2/§7.2）。
  T dataOrThrow() => switch (this) {
    ApiSuccess<T>(:final T data) => data,
    ApiFailure<T>(:final AppError error) => throw error,
  };
}

/// 成功，攜帶資料。
final class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.data);

  final T data;
}

/// 失敗，攜帶已分類的 [AppError]。
final class ApiFailure<T> extends ApiResult<T> {
  const ApiFailure(this.error);

  final AppError error;
}
