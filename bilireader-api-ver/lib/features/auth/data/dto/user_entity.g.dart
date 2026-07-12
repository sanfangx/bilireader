// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => _UserEntity(
  uid: (json['uid'] as num?)?.toInt(),
  uname: json['uname'] as String?,
  name: json['name'] as String?,
  avatar: (json['avatar'] as num?)?.toInt(),
  avatarUrl: json['avatarUrl'] as String?,
  groupid: (json['groupid'] as num?)?.toInt(),
  sex: (json['sex'] as num?)?.toInt(),
  level: json['level'] as String?,
  votes: json['votes'] as String?,
  isvip: (json['isvip'] as num?)?.toInt(),
  viplevel: (json['viplevel'] as num?)?.toInt(),
  experience: (json['experience'] as num?)?.toInt(),
  score: (json['score'] as num?)?.toInt(),
  egold: (json['egold'] as num?)?.toInt(),
  esilver: (json['esilver'] as num?)?.toInt(),
  credit: (json['credit'] as num?)?.toInt(),
  sign: json['sign'] as String?,
  intro: json['intro'] as String?,
  email: json['email'] as String?,
  regdate: (json['regdate'] as num?)?.toInt(),
  lastlogin: (json['lastlogin'] as num?)?.toInt(),
);

Map<String, dynamic> _$UserEntityToJson(_UserEntity instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'uname': instance.uname,
      'name': instance.name,
      'avatar': instance.avatar,
      'avatarUrl': instance.avatarUrl,
      'groupid': instance.groupid,
      'sex': instance.sex,
      'level': instance.level,
      'votes': instance.votes,
      'isvip': instance.isvip,
      'viplevel': instance.viplevel,
      'experience': instance.experience,
      'score': instance.score,
      'egold': instance.egold,
      'esilver': instance.esilver,
      'credit': instance.credit,
      'sign': instance.sign,
      'intro': instance.intro,
      'email': instance.email,
      'regdate': instance.regdate,
      'lastlogin': instance.lastlogin,
    };
