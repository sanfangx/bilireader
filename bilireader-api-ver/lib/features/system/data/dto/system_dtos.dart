import 'package:freezed_annotation/freezed_annotation.dart';

part 'system_dtos.freezed.dart';
part 'system_dtos.g.dart';

/// 簽到回應（`task/sign_in` → {points,totalScore}）。
/// server 未回 `points` 時退回 3（`AutoSignInManager` DEFAULT_SIGN_IN_POINTS）。
@freezed
abstract class SignInResponseDto with _$SignInResponseDto {
  const factory SignInResponseDto({
    @Default(3) int points,
    @Default(0) int totalScore,
  }) = _SignInResponseDto;

  factory SignInResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SignInResponseDtoFromJson(json);
}

/// 更新日誌項（`version/changelog`）。`current` 省略時預設 false（反編譯確認）。
@freezed
abstract class VersionLogItemDto with _$VersionLogItemDto {
  const factory VersionLogItemDto({
    String? versionName,
    String? updateContent,
    @Default(false) bool current,
  }) = _VersionLogItemDto;

  factory VersionLogItemDto.fromJson(Map<String, dynamic> json) =>
      _$VersionLogItemDtoFromJson(json);
}

/// 啟動公告（`system/startupAnnouncement`）。全部欄位可空。
@freezed
abstract class AppStartupAnnouncementDto with _$AppStartupAnnouncementDto {
  const factory AppStartupAnnouncementDto({
    int? bid,
    String? title,
    String? content,
    String? actionText,
    String? actionUrl,
    String? dismissKey,
    String? description,
    String? latestVersionName,
    int? latestVersionCode,
    String? latestUpdateContent,
  }) = _AppStartupAnnouncementDto;

  factory AppStartupAnnouncementDto.fromJson(Map<String, dynamic> json) =>
      _$AppStartupAnnouncementDtoFromJson(json);
}

/// 意見回饋回應（`feedback/submit` → {reportId}）。reportId 為 long → Dart int（64-bit）。
@freezed
abstract class FeedbackSubmitResponseDto with _$FeedbackSubmitResponseDto {
  const factory FeedbackSubmitResponseDto({@Default(0) int reportId}) =
      _FeedbackSubmitResponseDto;

  factory FeedbackSubmitResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FeedbackSubmitResponseDtoFromJson(json);
}
