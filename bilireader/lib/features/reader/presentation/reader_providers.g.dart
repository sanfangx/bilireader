// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reader_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 只影響 blocks 的設定子集：轉繁模式 / 防劇透 / 章末章評入口。**不含**字級/行距/段距/
/// 翻頁方式——故變更那些設定不會令 [readerChapterContent] 重建 blocks（避免字級滑桿每次
/// 重轉繁 + 內容 provider 進 loading 態導致 ListView 重建、捲動歸零）。

@ProviderFor(readerBlockSettings)
final readerBlockSettingsProvider = ReaderBlockSettingsProvider._();

/// 只影響 blocks 的設定子集：轉繁模式 / 防劇透 / 章末章評入口。**不含**字級/行距/段距/
/// 翻頁方式——故變更那些設定不會令 [readerChapterContent] 重建 blocks（避免字級滑桿每次
/// 重轉繁 + 內容 provider 進 loading 態導致 ListView 重建、捲動歸零）。

final class ReaderBlockSettingsProvider
    extends
        $FunctionalProvider<
          ({bool comment, ReaderConvertMode mode, bool spoiler}),
          ({bool comment, ReaderConvertMode mode, bool spoiler}),
          ({bool comment, ReaderConvertMode mode, bool spoiler})
        >
    with $Provider<({bool comment, ReaderConvertMode mode, bool spoiler})> {
  /// 只影響 blocks 的設定子集：轉繁模式 / 防劇透 / 章末章評入口。**不含**字級/行距/段距/
  /// 翻頁方式——故變更那些設定不會令 [readerChapterContent] 重建 blocks（避免字級滑桿每次
  /// 重轉繁 + 內容 provider 進 loading 態導致 ListView 重建、捲動歸零）。
  ReaderBlockSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readerBlockSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readerBlockSettingsHash();

  @$internal
  @override
  $ProviderElement<({bool comment, ReaderConvertMode mode, bool spoiler})>
  $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  ({bool comment, ReaderConvertMode mode, bool spoiler}) create(Ref ref) {
    return readerBlockSettings(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    ({bool comment, ReaderConvertMode mode, bool spoiler}) value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<
            ({bool comment, ReaderConvertMode mode, bool spoiler})
          >(value),
    );
  }
}

String _$readerBlockSettingsHash() =>
    r'7747734aabc5c47328781c17403970b5ee8aa53c';

/// 載入並建構某章內容（doc 05 §0/§4）：ChapterText（快取優先）→ OpenCC（依 `convertMode`）→ blocks。
///
/// 只在 `convertMode`/`illustration_spoiler`/`chapter_comment_enabled` 變更時重建（字級/行距不影響 blocks）。

@ProviderFor(readerChapterContent)
final readerChapterContentProvider = ReaderChapterContentFamily._();

/// 載入並建構某章內容（doc 05 §0/§4）：ChapterText（快取優先）→ OpenCC（依 `convertMode`）→ blocks。
///
/// 只在 `convertMode`/`illustration_spoiler`/`chapter_comment_enabled` 變更時重建（字級/行距不影響 blocks）。

final class ReaderChapterContentProvider
    extends
        $FunctionalProvider<
          AsyncValue<ReaderChapterContent>,
          ReaderChapterContent,
          FutureOr<ReaderChapterContent>
        >
    with
        $FutureModifier<ReaderChapterContent>,
        $FutureProvider<ReaderChapterContent> {
  /// 載入並建構某章內容（doc 05 §0/§4）：ChapterText（快取優先）→ OpenCC（依 `convertMode`）→ blocks。
  ///
  /// 只在 `convertMode`/`illustration_spoiler`/`chapter_comment_enabled` 變更時重建（字級/行距不影響 blocks）。
  ReaderChapterContentProvider._({
    required ReaderChapterContentFamily super.from,
    required (int, int) super.argument,
  }) : super(
         retry: null,
         name: r'readerChapterContentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$readerChapterContentHash();

  @override
  String toString() {
    return r'readerChapterContentProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<ReaderChapterContent> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ReaderChapterContent> create(Ref ref) {
    final argument = this.argument as (int, int);
    return readerChapterContent(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is ReaderChapterContentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$readerChapterContentHash() =>
    r'0e9b219e43362a8fe5d2321d3f4ca22f7fb30e48';

/// 載入並建構某章內容（doc 05 §0/§4）：ChapterText（快取優先）→ OpenCC（依 `convertMode`）→ blocks。
///
/// 只在 `convertMode`/`illustration_spoiler`/`chapter_comment_enabled` 變更時重建（字級/行距不影響 blocks）。

final class ReaderChapterContentFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ReaderChapterContent>, (int, int)> {
  ReaderChapterContentFamily._()
    : super(
        retry: null,
        name: r'readerChapterContentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 載入並建構某章內容（doc 05 §0/§4）：ChapterText（快取優先）→ OpenCC（依 `convertMode`）→ blocks。
  ///
  /// 只在 `convertMode`/`illustration_spoiler`/`chapter_comment_enabled` 變更時重建（字級/行距不影響 blocks）。

  ReaderChapterContentProvider call(int articleId, int chapterId) =>
      ReaderChapterContentProvider._(
        argument: (articleId, chapterId),
        from: this,
      );

  @override
  String toString() => r'readerChapterContentProvider';
}
