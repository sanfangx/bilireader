import 'package:uuid/uuid.dart';

/// 註冊用 `deviceId` 解析。**每次呼叫產生一組全新隨機 UUID（不綁硬體、不持久化）**。
///
/// 隱私策略（使用者指定）：不採原生 App 的 `ANDROID_ID`（每台唯一，會讓伺服器得以裝置
/// 指紋稽核真實裝置並限制同機註冊次數）。改為每次註冊都送隨機值，伺服器無從辨識/追蹤真實
/// 裝置，且同一台裝置可多次註冊。`deviceId` 僅用於註冊請求（登入走挑戰式驗證、不帶 deviceId）。
class DeviceIdResolver {
  DeviceIdResolver({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  /// 全新隨機 deviceId（32 hex，去除 `-`）。每次註冊皆不同、不與硬體綁定、不持久化。
  Future<String> resolve() async => _uuid.v4().replaceAll('-', '');
}
