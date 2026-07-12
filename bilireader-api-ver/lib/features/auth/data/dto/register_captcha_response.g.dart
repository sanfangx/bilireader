// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_captcha_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RegisterCaptchaResponse _$RegisterCaptchaResponseFromJson(
  Map<String, dynamic> json,
) => _RegisterCaptchaResponse(
  captchaId: json['captchaId'] as String? ?? '',
  img: json['img'] as String? ?? '',
  expiresIn: (json['expiresIn'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$RegisterCaptchaResponseToJson(
  _RegisterCaptchaResponse instance,
) => <String, dynamic>{
  'captchaId': instance.captchaId,
  'img': instance.img,
  'expiresIn': instance.expiresIn,
};
