// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 全域簡繁轉換器（規範 §5.0）。消費端（搜尋 fallback、閱讀器、顯示 server 文字）
/// 使用前先 `await ref.read(chineseConverterProvider).ensureLoaded()`。

@ProviderFor(chineseConverter)
final chineseConverterProvider = ChineseConverterProvider._();

/// 全域簡繁轉換器（規範 §5.0）。消費端（搜尋 fallback、閱讀器、顯示 server 文字）
/// 使用前先 `await ref.read(chineseConverterProvider).ensureLoaded()`。

final class ChineseConverterProvider
    extends
        $FunctionalProvider<
          ChineseConverter,
          ChineseConverter,
          ChineseConverter
        >
    with $Provider<ChineseConverter> {
  /// 全域簡繁轉換器（規範 §5.0）。消費端（搜尋 fallback、閱讀器、顯示 server 文字）
  /// 使用前先 `await ref.read(chineseConverterProvider).ensureLoaded()`。
  ChineseConverterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chineseConverterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chineseConverterHash();

  @$internal
  @override
  $ProviderElement<ChineseConverter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChineseConverter create(Ref ref) {
    return chineseConverter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChineseConverter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChineseConverter>(value),
    );
  }
}

String _$chineseConverterHash() => r'b25743ee78d6bba7fa19505b0eb3bdb3db47c4ae';
