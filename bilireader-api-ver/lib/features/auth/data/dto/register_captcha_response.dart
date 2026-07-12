import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_captcha_response.freezed.dart';
part 'register_captcha_response.g.dart';

/// `user/register/captcha` 回應 data（API.md）。`img` 為 base64 圖片
/// （`Image.memory(base64Decode(img))`）；`expiresIn` 秒、單次有效。
@freezed
abstract class RegisterCaptchaResponse with _$RegisterCaptchaResponse {
  const factory RegisterCaptchaResponse({
    @Default('') String captchaId,
    @Default('') String img,
    @Default(0) int expiresIn,
  }) = _RegisterCaptchaResponse;

  factory RegisterCaptchaResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterCaptchaResponseFromJson(json);
}
