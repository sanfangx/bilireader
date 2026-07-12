import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

/// `user/getuserInfo` 回應 data（規範 §4.3、doc 10 `UserEntity`）。
///
/// 重要（doc 10）：原始 `UserEntity` 無 `@SerializedName` → wire key = 欄位名（小寫），
/// 全欄位 nullable。型別陷阱：`level`/`votes` 為 String（非 int）；`avatar` 為頭像索引 int、
/// 真正 URL 在 `avatarUrl`；`isvip` 為 0/1；時間欄位為秒級 Unix int。
/// 僅收錄顯示 / session 相關欄位；未映射的 wire key 由 json_serializable 忽略。
@freezed
abstract class UserEntity with _$UserEntity {
  const UserEntity._();

  const factory UserEntity({
    int? uid,
    String? uname,
    String? name,
    int? avatar,
    String? avatarUrl,
    int? groupid,
    int? sex,
    String? level,
    String? votes,
    int? isvip,
    int? viplevel,
    int? experience,
    int? score,
    int? egold,
    int? esilver,
    int? credit,
    String? sign,
    String? intro,
    String? email,
    int? regdate,
    int? lastlogin,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  /// 0/1 → bool（doc 10 慣例）。
  bool get isVipUser => (isvip ?? 0) == 1;

  /// 作者專區權限（groupid 1=管理員 / 5=作者 / 6=用愛發電）。
  bool get canAccessAuthorZone => groupid == 1 || groupid == 5 || groupid == 6;
}
