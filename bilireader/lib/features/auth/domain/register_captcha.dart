import 'package:flutter/foundation.dart';

/// 註冊圖形驗證碼 domain entity。[imageBase64] 為 base64 圖片位元組
/// （UI 以 `Image.memory(base64Decode(imageBase64))` 顯示）。
@immutable
class RegisterCaptcha {
  const RegisterCaptcha({required this.captchaId, required this.imageBase64});

  final String captchaId;
  final String imageBase64;
}
