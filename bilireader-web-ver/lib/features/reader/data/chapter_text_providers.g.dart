// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_text_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 章節內容來源（正式：WebView 擷取）。測試可 override 為假來源。
/// 對應 api-ver `chapterTextRemoteDataSourceProvider`。

@ProviderFor(chapterContentSource)
final chapterContentSourceProvider = ChapterContentSourceProvider._();

/// 章節內容來源（正式：WebView 擷取）。測試可 override 為假來源。
/// 對應 api-ver `chapterTextRemoteDataSourceProvider`。

final class ChapterContentSourceProvider
    extends
        $FunctionalProvider<
          ChapterContentSource,
          ChapterContentSource,
          ChapterContentSource
        >
    with $Provider<ChapterContentSource> {
  /// 章節內容來源（正式：WebView 擷取）。測試可 override 為假來源。
  /// 對應 api-ver `chapterTextRemoteDataSourceProvider`。
  ChapterContentSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chapterContentSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chapterContentSourceHash();

  @$internal
  @override
  $ProviderElement<ChapterContentSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChapterContentSource create(Ref ref) {
    return chapterContentSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChapterContentSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChapterContentSource>(value),
    );
  }
}

String _$chapterContentSourceHash() =>
    r'2e0457664d48a7979b753d3d726e7f768d227b25';

/// 章節正文倉儲：**離線下載優先** → drift 快取 → WebView 擷取寫回 + VIP 偵測。
/// 對應 api-ver `chapterTextRepositoryProvider`（web 適配：離線層接 OfflineStore）。

@ProviderFor(chapterTextRepository)
final chapterTextRepositoryProvider = ChapterTextRepositoryProvider._();

/// 章節正文倉儲：**離線下載優先** → drift 快取 → WebView 擷取寫回 + VIP 偵測。
/// 對應 api-ver `chapterTextRepositoryProvider`（web 適配：離線層接 OfflineStore）。

final class ChapterTextRepositoryProvider
    extends
        $FunctionalProvider<
          ChapterTextRepository,
          ChapterTextRepository,
          ChapterTextRepository
        >
    with $Provider<ChapterTextRepository> {
  /// 章節正文倉儲：**離線下載優先** → drift 快取 → WebView 擷取寫回 + VIP 偵測。
  /// 對應 api-ver `chapterTextRepositoryProvider`（web 適配：離線層接 OfflineStore）。
  ChapterTextRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chapterTextRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chapterTextRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChapterTextRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChapterTextRepository create(Ref ref) {
    return chapterTextRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChapterTextRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChapterTextRepository>(value),
    );
  }
}

String _$chapterTextRepositoryHash() =>
    r'35181fb98c901107218502ad6130affe104a91fa';
