// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 更新日誌（`version/changelog`）。

@ProviderFor(changelog)
final changelogProvider = ChangelogProvider._();

/// 更新日誌（`version/changelog`）。

final class ChangelogProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<VersionLog>>,
          List<VersionLog>,
          FutureOr<List<VersionLog>>
        >
    with $FutureModifier<List<VersionLog>>, $FutureProvider<List<VersionLog>> {
  /// 更新日誌（`version/changelog`）。
  ChangelogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'changelogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$changelogHash();

  @$internal
  @override
  $FutureProviderElement<List<VersionLog>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<VersionLog>> create(Ref ref) {
    return changelog(ref);
  }
}

String _$changelogHash() => r'a22aefbd7256552ff65fc7a51b3967cd0d6a4b41';

/// App 啟動流程協調（版本檢查 / 啟動公告去重 / 每日自動簽到）+ 開啟外部連結。
/// 皆比照原 App `MainActivity` / `AutoSignInManager` 行為（§11 ⑧）。

@ProviderFor(SystemStartup)
final systemStartupProvider = SystemStartupProvider._();

/// App 啟動流程協調（版本檢查 / 啟動公告去重 / 每日自動簽到）+ 開啟外部連結。
/// 皆比照原 App `MainActivity` / `AutoSignInManager` 行為（§11 ⑧）。
final class SystemStartupProvider
    extends $NotifierProvider<SystemStartup, void> {
  /// App 啟動流程協調（版本檢查 / 啟動公告去重 / 每日自動簽到）+ 開啟外部連結。
  /// 皆比照原 App `MainActivity` / `AutoSignInManager` 行為（§11 ⑧）。
  SystemStartupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'systemStartupProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$systemStartupHash();

  @$internal
  @override
  SystemStartup create() => SystemStartup();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$systemStartupHash() => r'35c4566e4ed88c2fea5facf57252252abc2e9fb6';

/// App 啟動流程協調（版本檢查 / 啟動公告去重 / 每日自動簽到）+ 開啟外部連結。
/// 皆比照原 App `MainActivity` / `AutoSignInManager` 行為（§11 ⑧）。

abstract class _$SystemStartup extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 「我的」簽到卡狀態。**先與伺服器確認今日是否已簽**（`autoSignInIfNeeded`，本機今日已記錄則
/// 直接跳過、不重打），再讀本機記錄顯示。修正：啟動自動簽到跑在「尚未登入」之前 →
/// 登入後本機從未記錄 → 卡片一直停在「簽到中」且伺服器已有紀錄簽不了。已簽到（201/訊息）會被
/// `autoSignInIfNeeded` 記為今日 → 卡片顯示「已簽到」。§7.0：sign_in 每日僅一次（本機去重）。

@ProviderFor(profileSignIn)
final profileSignInProvider = ProfileSignInProvider._();

/// 「我的」簽到卡狀態。**先與伺服器確認今日是否已簽**（`autoSignInIfNeeded`，本機今日已記錄則
/// 直接跳過、不重打），再讀本機記錄顯示。修正：啟動自動簽到跑在「尚未登入」之前 →
/// 登入後本機從未記錄 → 卡片一直停在「簽到中」且伺服器已有紀錄簽不了。已簽到（201/訊息）會被
/// `autoSignInIfNeeded` 記為今日 → 卡片顯示「已簽到」。§7.0：sign_in 每日僅一次（本機去重）。

final class ProfileSignInProvider
    extends
        $FunctionalProvider<
          AsyncValue<SignInDisplay>,
          SignInDisplay,
          FutureOr<SignInDisplay>
        >
    with $FutureModifier<SignInDisplay>, $FutureProvider<SignInDisplay> {
  /// 「我的」簽到卡狀態。**先與伺服器確認今日是否已簽**（`autoSignInIfNeeded`，本機今日已記錄則
  /// 直接跳過、不重打），再讀本機記錄顯示。修正：啟動自動簽到跑在「尚未登入」之前 →
  /// 登入後本機從未記錄 → 卡片一直停在「簽到中」且伺服器已有紀錄簽不了。已簽到（201/訊息）會被
  /// `autoSignInIfNeeded` 記為今日 → 卡片顯示「已簽到」。§7.0：sign_in 每日僅一次（本機去重）。
  ProfileSignInProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileSignInProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileSignInHash();

  @$internal
  @override
  $FutureProviderElement<SignInDisplay> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SignInDisplay> create(Ref ref) {
    return profileSignIn(ref);
  }
}

String _$profileSignInHash() => r'a12ec1adead96fa060aa08d9c6ad41f9465f1c01';

/// 意見回饋送出（`feedback/submit`）。狀態變更端點（§7.0），僅使用者主動觸發。

@ProviderFor(FeedbackActions)
final feedbackActionsProvider = FeedbackActionsProvider._();

/// 意見回饋送出（`feedback/submit`）。狀態變更端點（§7.0），僅使用者主動觸發。
final class FeedbackActionsProvider
    extends $NotifierProvider<FeedbackActions, void> {
  /// 意見回饋送出（`feedback/submit`）。狀態變更端點（§7.0），僅使用者主動觸發。
  FeedbackActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'feedbackActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$feedbackActionsHash();

  @$internal
  @override
  FeedbackActions create() => FeedbackActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$feedbackActionsHash() => r'e85cf8ee0fe31ede653833f743cd231e756bbc95';

/// 意見回饋送出（`feedback/submit`）。狀態變更端點（§7.0），僅使用者主動觸發。

abstract class _$FeedbackActions extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
