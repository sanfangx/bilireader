import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_challenge_response.freezed.dart';
part 'login_challenge_response.g.dart';

/// `user/login/challenge` 回應 data（規範 §7.3、API.md）。wire key 照文件 camelCase。
/// `expiresIn`（秒）與 `timestamp`（伺服器秒）client 讀取但不參與 proof 計算。
@freezed
abstract class LoginChallengeResponse with _$LoginChallengeResponse {
  const factory LoginChallengeResponse({
    @Default('') String challenge,
    @Default('') String challengeId,
    @Default(0) int expiresIn,
    @Default(0) int timestamp,
  }) = _LoginChallengeResponse;

  factory LoginChallengeResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginChallengeResponseFromJson(json);
}
