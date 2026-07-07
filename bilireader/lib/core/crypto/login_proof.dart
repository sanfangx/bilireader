import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

/// 登入 challenge proof 計算（規範 §7.3，對照 `NetworkRequestUtil`）。
///
/// `proof = md5(challenge + "|" + uname + "|" + pass + "|" + nonce + "|" + timestamp)`
/// - 分隔符為半形 `|`；順序固定：challenge、uname、pass、nonce、timestamp。
/// - 輸入以 UTF-8 編碼，輸出 32 位小寫十六進位。
/// - `nonce` = UUID v4 去除所有 `-`（32 hex）；`timestamp` = 毫秒 epoch，字串化。
///
/// `pass` 為明文，僅在請求組裝期間短暫存在，**不得儲存 / 記錄 / 上傳**（§7.3）。
abstract final class LoginProof {
  static String md5Hex(String input) =>
      md5.convert(utf8.encode(input)).toString();

  /// [timestampMs] 為毫秒 epoch；proof 中使用其十進位字串形式。
  static String build({
    required String challenge,
    required String uname,
    required String pass,
    required String nonce,
    required int timestampMs,
  }) {
    return md5Hex('$challenge|$uname|$pass|$nonce|$timestampMs');
  }

  /// 產生 32 位小寫 hex 的 nonce（UUID v4 去 `-`）。
  static String newNonce([Uuid? uuid]) =>
      (uuid ?? const Uuid()).v4().replaceAll('-', '');
}
