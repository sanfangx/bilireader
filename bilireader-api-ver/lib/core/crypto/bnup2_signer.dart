import 'dart:convert';

import 'package:crypto/crypto.dart';

/// BNUP2 上傳簽章（規範 §7.4；對應反編譯 `AppUploadSignatureInterceptor`）。
///
/// 僅在**同時**符合下列條件時套用：HTTP method 為 POST、正規化後的 appPath 精確等於
/// [protectedPaths] 其一、且 `Authorization` token 非空。演算法為純客戶端可重現，
/// 以下為 byte-exact 復刻，密鑰以 XOR 還原（與原生一致）。
///
/// 純邏輯集中於此以便單元測試；Dio 掛載見 network 層的 UploadSignatureInterceptor。
abstract final class Bnup2Signer {
  /// payload 第一行的 scheme 標記。
  static const String schemeTag = 'BNUP2';

  static const String headerTimestamp = 'X-App-Upload-Timestamp';
  static const String headerNonce = 'X-App-Upload-Nonce';
  static const String headerSignature = 'X-App-Upload-Signature';

  /// 7 個受保護 upload/write 路徑，精確相等比對（非前綴、大小寫敏感）。
  static const Set<String> protectedPaths = <String>{
    '/client/bilinovel/author/novel/create',
    '/client/bilinovel/author/novel/cover',
    '/client/bilinovel/author/volume/create',
    '/client/bilinovel/author/volume/cover',
    '/client/bilinovel/author/chapter/attach/upload',
    '/client/bilinovel/circle/publish',
    '/client/bilinovel/circle/reply',
  };

  /// 內嵌密文（41 bytes，對應 `SECRET_ENC`）。
  static const List<int> _secretEnc = <int>[
    14, 7, 67, 26, 6, 72, 31, 0, 5, 0, 20, 92, 0, 90, 42, 2, 82, 117, 72, 98, //
    6,
    91,
    60,
    88,
    29,
    35,
    1,
    32,
    90,
    31,
    42,
    21,
    6,
    32,
    78,
    52,
    3,
    50,
    91,
    75,
    102,
  ];

  /// XOR 遮罩（對應 `SECRET_MASK`）。
  static const String _secretMask = 'linovelib-bn-mask-2026';

  /// 還原 HMAC 密鑰：`enc[i] XOR mask[i % mask.length]`，UTF-8 解碼。
  /// 結果應為 `bn-up-sig-v2-7Kq9XzR4mP1sLwE6vH8dNcYbA0fT`（見單元測試向量）。
  static String decodeSigningSecret() {
    final List<int> mask = utf8.encode(_secretMask);
    final List<int> out = List<int>.generate(
      _secretEnc.length,
      (int i) => _secretEnc[i] ^ mask[i % mask.length],
    );
    return utf8.decode(out);
  }

  /// 從「已編碼」的 path 取出自 `/client/` 起的相對路徑；找不到則原樣回傳。
  static String normalizeAppPath(String encodedPath) {
    final int idx = encodedPath.indexOf('/client/');
    if (idx < 0) {
      return encodedPath;
    }
    return encodedPath.substring(idx);
  }

  /// 正規化 query：使用已編碼原字串，以 `&` 拆分、去除空段、（>1 段時）UTF-16 字典序
  /// 排序後以 `&` 接回。不解碼、不去重、不重組同名參數。
  static String canonicalQuery(Uri uri) {
    final String raw = uri.query;
    if (raw.isEmpty) {
      return '';
    }
    final List<String> parts = raw
        .split('&')
        .where((String s) => s.isNotEmpty)
        .toList();
    if (parts.length > 1) {
      parts.sort();
    }
    return parts.join('&');
  }

  /// 觸發條件：POST + appPath 在清單內 + token 非空。
  static bool shouldSign({
    required String method,
    required String appPath,
    required String token,
  }) {
    return method.toUpperCase() == 'POST' &&
        protectedPaths.contains(appPath) &&
        token.isNotEmpty;
  }

  /// 組 7 行 payload，以 `\n`（LF）分隔：BNUP2 / METHOD / appPath / query / ts / nonce / token。
  static String buildPayload({
    required String method,
    required String appPath,
    required String query,
    required String timestamp,
    required String nonce,
    required String token,
  }) {
    final String m = method.toUpperCase();
    return '$schemeTag\n$m\n$appPath\n$query\n$timestamp\n$nonce\n$token';
  }

  /// HMAC-SHA256 → 64 字元小寫 hex。未指定 [secret] 時使用還原密鑰。
  static String hmacSha256Hex({required String payload, String? secret}) {
    final Hmac hmac = Hmac(
      sha256,
      utf8.encode(secret ?? decodeSigningSecret()),
    );
    return hmac.convert(utf8.encode(payload)).toString();
  }

  /// 為請求產生三個簽章 header；若不符合觸發條件回傳空 map（呼叫端不應加任何 header）。
  static Map<String, String> signatureHeaders({
    required String method,
    required Uri uri,
    required String token,
    required String timestamp,
    required String nonce,
  }) {
    final String appPath = normalizeAppPath(uri.path);
    if (!shouldSign(method: method, appPath: appPath, token: token)) {
      return const <String, String>{};
    }
    final String payload = buildPayload(
      method: method,
      appPath: appPath,
      query: canonicalQuery(uri),
      timestamp: timestamp,
      nonce: nonce,
      token: token,
    );
    return <String, String>{
      headerTimestamp: timestamp,
      headerNonce: nonce,
      headerSignature: hmacSha256Hex(payload: payload),
    };
  }
}
