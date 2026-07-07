// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 目前登入者資訊（規範 §4.2 app-level provider）。未登入回 null；隨認證狀態變化重取。
/// 供「我的」等頁面以 app-level 方式消費，避免 feature 間直接耦合。

@ProviderFor(currentUser)
final currentUserProvider = CurrentUserProvider._();

/// 目前登入者資訊（規範 §4.2 app-level provider）。未登入回 null；隨認證狀態變化重取。
/// 供「我的」等頁面以 app-level 方式消費，避免 feature 間直接耦合。

final class CurrentUserProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserInfo?>,
          UserInfo?,
          FutureOr<UserInfo?>
        >
    with $FutureModifier<UserInfo?>, $FutureProvider<UserInfo?> {
  /// 目前登入者資訊（規範 §4.2 app-level provider）。未登入回 null；隨認證狀態變化重取。
  /// 供「我的」等頁面以 app-level 方式消費，避免 feature 間直接耦合。
  CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $FutureProviderElement<UserInfo?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserInfo?> create(Ref ref) {
    return currentUser(ref);
  }
}

String _$currentUserHash() => r'6dda770caee4c8a950260acdb4c5ed85f8fea7d5';
