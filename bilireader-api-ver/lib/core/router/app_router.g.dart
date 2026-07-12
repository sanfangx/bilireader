// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 全域 GoRouter（規範 §2.2、§6.2）。底部分頁使用可保留狀態的
/// [StatefulShellRoute.indexedStack]；詳情／閱讀器／搜尋等為 shell 外全屏 route。
/// `refreshListenable` 綁定認證狀態，Phase 2 登入／登出後路由守衛會重新評估。

@ProviderFor(goRouter)
final goRouterProvider = GoRouterProvider._();

/// 全域 GoRouter（規範 §2.2、§6.2）。底部分頁使用可保留狀態的
/// [StatefulShellRoute.indexedStack]；詳情／閱讀器／搜尋等為 shell 外全屏 route。
/// `refreshListenable` 綁定認證狀態，Phase 2 登入／登出後路由守衛會重新評估。

final class GoRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// 全域 GoRouter（規範 §2.2、§6.2）。底部分頁使用可保留狀態的
  /// [StatefulShellRoute.indexedStack]；詳情／閱讀器／搜尋等為 shell 外全屏 route。
  /// `refreshListenable` 綁定認證狀態，Phase 2 登入／登出後路由守衛會重新評估。
  GoRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return goRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$goRouterHash() => r'0e4b6bc9a8897e09e82e42ed84822c78a910405c';
