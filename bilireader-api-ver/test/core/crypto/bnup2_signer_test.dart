import 'package:bilireader/core/crypto/bnup2_signer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Bnup2Signer', () {
    test('decodeSigningSecret 還原為已知明文（測試向量）', () {
      expect(
        Bnup2Signer.decodeSigningSecret(),
        'bn-up-sig-v2-7Kq9XzR4mP1sLwE6vH8dNcYbA0fT',
      );
    });

    test('normalizeAppPath 從 /client/ 起截斷', () {
      expect(
        Bnup2Signer.normalizeAppPath(
          '/phone/api/client/bilinovel/circle/publish',
        ),
        '/client/bilinovel/circle/publish',
      );
    });

    test('normalizeAppPath 找不到 /client/ 時原樣回傳', () {
      expect(Bnup2Signer.normalizeAppPath('/foo/bar'), '/foo/bar');
    });

    test('canonicalQuery 去空段並字典序排序（不解碼）', () {
      final Uri uri = Uri.parse('https://x/y?b=2&a=1&&c=3');
      expect(Bnup2Signer.canonicalQuery(uri), 'a=1&b=2&c=3');
    });

    test('canonicalQuery 空 query 回傳空字串', () {
      expect(Bnup2Signer.canonicalQuery(Uri.parse('https://x/y')), '');
    });

    test('canonicalQuery 單段不排序', () {
      expect(Bnup2Signer.canonicalQuery(Uri.parse('https://x/y?z=9')), 'z=9');
    });

    test('shouldSign 僅 POST + 受保護路徑 + 非空 token', () {
      const String path = '/client/bilinovel/circle/publish';
      expect(
        Bnup2Signer.shouldSign(method: 'POST', appPath: path, token: 't'),
        isTrue,
      );
      expect(
        Bnup2Signer.shouldSign(method: 'post', appPath: path, token: 't'),
        isTrue,
      );
      expect(
        Bnup2Signer.shouldSign(method: 'GET', appPath: path, token: 't'),
        isFalse,
      );
      expect(
        Bnup2Signer.shouldSign(
          method: 'POST',
          appPath: '/client/bilinovel/other',
          token: 't',
        ),
        isFalse,
      );
      expect(
        Bnup2Signer.shouldSign(method: 'POST', appPath: path, token: ''),
        isFalse,
      );
    });

    test('buildPayload 為 7 行以 LF 分隔', () {
      final String payload = Bnup2Signer.buildPayload(
        method: 'post',
        appPath: '/client/bilinovel/circle/reply',
        query: 'a=1',
        timestamp: '123',
        nonce: 'abc',
        token: 'tok',
      );
      expect(
        payload,
        'BNUP2\nPOST\n/client/bilinovel/circle/reply\na=1\n123\nabc\ntok',
      );
      expect(payload.split('\n').length, 7);
    });

    test('hmacSha256Hex 為 64 字元小寫 hex 且具決定性', () {
      const String payload =
          'BNUP2\nPOST\n/client/bilinovel/circle/reply\n\n1\nn\nt';
      final String sig1 = Bnup2Signer.hmacSha256Hex(payload: payload);
      final String sig2 = Bnup2Signer.hmacSha256Hex(payload: payload);
      expect(sig1, sig2);
      expect(sig1.length, 64);
      expect(RegExp(r'^[0-9a-f]{64}$').hasMatch(sig1), isTrue);
    });

    test('signatureHeaders：受保護請求回三個 header', () {
      final Uri uri = Uri.parse(
        'https://api.readpai.com/phone/api/client/bilinovel/circle/publish?a=1',
      );
      final Map<String, String> headers = Bnup2Signer.signatureHeaders(
        method: 'POST',
        uri: uri,
        token: 'tok',
        timestamp: '100',
        nonce: 'nnn',
      );
      expect(
        headers.keys,
        containsAll(<String>[
          Bnup2Signer.headerTimestamp,
          Bnup2Signer.headerNonce,
          Bnup2Signer.headerSignature,
        ]),
      );
      expect(headers[Bnup2Signer.headerTimestamp], '100');
      expect(headers[Bnup2Signer.headerNonce], 'nnn');
      expect(headers[Bnup2Signer.headerSignature]!.length, 64);
    });

    test('signatureHeaders：非受保護路徑回空 map', () {
      final Uri uri = Uri.parse(
        'https://api.readpai.com/phone/api/client/bilinovel/user/login',
      );
      final Map<String, String> headers = Bnup2Signer.signatureHeaders(
        method: 'POST',
        uri: uri,
        token: 'tok',
        timestamp: '100',
        nonce: 'nnn',
      );
      expect(headers, isEmpty);
    });

    test('作者端 5 個上傳路徑皆受簽章保護', () {
      const List<String> uploadPaths = <String>[
        '/client/bilinovel/author/novel/create',
        '/client/bilinovel/author/novel/cover',
        '/client/bilinovel/author/volume/create',
        '/client/bilinovel/author/volume/cover',
        '/client/bilinovel/author/chapter/attach/upload',
      ];
      for (final String p in uploadPaths) {
        expect(
          Bnup2Signer.shouldSign(method: 'POST', appPath: p, token: 't'),
          isTrue,
          reason: '$p 應簽章',
        );
      }
    });

    test('作者端非上傳路徑不簽章（list / tree / draft/save）', () {
      const List<String> plainPaths = <String>[
        '/client/bilinovel/author/novel/list',
        '/client/bilinovel/author/chapter/tree',
        '/client/bilinovel/author/draft/save',
        '/client/bilinovel/author/chapter/update',
      ];
      for (final String p in plainPaths) {
        expect(
          Bnup2Signer.shouldSign(method: 'POST', appPath: p, token: 't'),
          isFalse,
          reason: '$p 不應簽章',
        );
      }
    });
  });
}
