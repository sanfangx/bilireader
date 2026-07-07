import 'package:bilireader/core/crypto/login_proof.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginProof', () {
    test('md5Hex 對已知向量正確（32 位小寫 hex）', () {
      expect(LoginProof.md5Hex('abc'), '900150983cd24fb0d6963f7d28e17f72');
    });

    test('build 依 challenge|uname|pass|nonce|timestamp 順序組 md5', () {
      const String challenge = 'CHg';
      const String uname = 'alice';
      const String pass = 'secret';
      const String nonce = 'abcdef0123456789abcdef0123456789';
      const int ts = 1700000000000;
      final String expected = LoginProof.md5Hex(
        '$challenge|$uname|$pass|$nonce|$ts',
      );
      expect(
        LoginProof.build(
          challenge: challenge,
          uname: uname,
          pass: pass,
          nonce: nonce,
          timestampMs: ts,
        ),
        expected,
      );
      // 輸出格式：32 位小寫 hex。
      expect(RegExp(r'^[0-9a-f]{32}$').hasMatch(expected), isTrue);
    });

    test('newNonce 為 32 位小寫 hex（UUID 去 dash）', () {
      final String nonce = LoginProof.newNonce();
      expect(RegExp(r'^[0-9a-f]{32}$').hasMatch(nonce), isTrue);
      expect(nonce.contains('-'), isFalse);
    });
  });
}
