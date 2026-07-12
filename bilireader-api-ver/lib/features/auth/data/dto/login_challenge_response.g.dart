// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_challenge_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginChallengeResponse _$LoginChallengeResponseFromJson(
  Map<String, dynamic> json,
) => _LoginChallengeResponse(
  challenge: json['challenge'] as String? ?? '',
  challengeId: json['challengeId'] as String? ?? '',
  expiresIn: (json['expiresIn'] as num?)?.toInt() ?? 0,
  timestamp: (json['timestamp'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$LoginChallengeResponseToJson(
  _LoginChallengeResponse instance,
) => <String, dynamic>{
  'challenge': instance.challenge,
  'challengeId': instance.challengeId,
  'expiresIn': instance.expiresIn,
  'timestamp': instance.timestamp,
};
