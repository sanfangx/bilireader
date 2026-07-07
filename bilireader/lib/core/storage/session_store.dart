import 'package:shared_preferences/shared_preferences.dart';

/// 非敏感登入識別資料（uid / groupid）的儲存抽象（規範 §7.3：可放
/// `shared_preferences`）。uid <= 0 視為未登入；groupid < 0 視為無效。
abstract interface class SessionStore {
  Future<int?> readUid();
  Future<void> writeUid(int uid);
  Future<int?> readGroupId();
  Future<void> writeGroupId(int groupId);
  Future<void> clear();
}

/// `shared_preferences` 實作。
class PrefsSessionStore implements SessionStore {
  const PrefsSessionStore(this._prefs);

  final SharedPreferences _prefs;

  static const String _keyUid = 'uid';
  static const String _keyGroupId = 'groupid';

  @override
  Future<int?> readUid() async {
    final int? value = _prefs.getInt(_keyUid);
    return (value == null || value <= 0) ? null : value;
  }

  @override
  Future<void> writeUid(int uid) => _prefs.setInt(_keyUid, uid);

  @override
  Future<int?> readGroupId() async {
    final int? value = _prefs.getInt(_keyGroupId);
    return (value == null || value < 0) ? null : value;
  }

  @override
  Future<void> writeGroupId(int groupId) => _prefs.setInt(_keyGroupId, groupId);

  @override
  Future<void> clear() async {
    await _prefs.remove(_keyUid);
    await _prefs.remove(_keyGroupId);
  }
}
