import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Token 安全儲存抽象（規範 §7.3）。token 為機密憑證，必須放安全儲存，
/// 不得寫入 log / analytics / plain SharedPreferences。
abstract interface class TokenStore {
  Future<String?> read();
  Future<void> write(String token);
  Future<void> delete();
}

/// `flutter_secure_storage` 實作（Android Keystore / iOS Keychain）。
class SecureTokenStore implements TokenStore {
  const SecureTokenStore(this._storage);

  final FlutterSecureStorage _storage;

  static const String _key = 'token';

  @override
  Future<String?> read() async {
    try {
      return await _storage.read(key: _key);
    } on Object {
      // Keystore / Keychain 讀取失敗（平台例外、未初始化、權限等）不應沿攔截器
      // 往上炸掉整條請求；回傳 null 視為未登入（規範 §7.3）。
      return null;
    }
  }

  @override
  Future<void> write(String token) => _storage.write(key: _key, value: token);

  @override
  Future<void> delete() => _storage.delete(key: _key);
}
