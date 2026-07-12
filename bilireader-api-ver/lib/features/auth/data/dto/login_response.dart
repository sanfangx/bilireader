import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

/// `user/login` 與 `user/register` 回應 data（規範 §7.3、API.md）。只含 token。
@freezed
abstract class LoginResponse with _$LoginResponse {
  const factory LoginResponse({@Default('') String token}) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
