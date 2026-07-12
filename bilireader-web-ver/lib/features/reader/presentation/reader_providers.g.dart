// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reader_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 載入並建構某章內容：ChapterText（drift 快取優先，未命中 WebView 擷取）→ blocks。
///
/// web 適配（忠實對應 api-ver `readerChapterContent`，除下列）：
/// - `convert`＝identity（tw.linovelib 本繁體，不套 OpenCC）。
/// - `illustrationSpoiler`/`chapterCommentEnabled`＝false：兩者對 web 皆**惰性**（擷取合成的
///   ChapterText.isbody 恆 0 → 防劇透門檻不觸發；web 無章末章評）。故 blocks **只依章節本身**，
///   字級/行距/主題/防劇透設定變更都不會重建 blocks（自然滿足 api-ver 的「避免捲動歸零」優化）。

@ProviderFor(readerChapterContent)
final readerChapterContentProvider = ReaderChapterContentFamily._();

/// 載入並建構某章內容：ChapterText（drift 快取優先，未命中 WebView 擷取）→ blocks。
///
/// web 適配（忠實對應 api-ver `readerChapterContent`，除下列）：
/// - `convert`＝identity（tw.linovelib 本繁體，不套 OpenCC）。
/// - `illustrationSpoiler`/`chapterCommentEnabled`＝false：兩者對 web 皆**惰性**（擷取合成的
///   ChapterText.isbody 恆 0 → 防劇透門檻不觸發；web 無章末章評）。故 blocks **只依章節本身**，
///   字級/行距/主題/防劇透設定變更都不會重建 blocks（自然滿足 api-ver 的「避免捲動歸零」優化）。

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
  /// 載入並建構某章內容：ChapterText（drift 快取優先，未命中 WebView 擷取）→ blocks。
  ///
  /// web 適配（忠實對應 api-ver `readerChapterContent`，除下列）：
  /// - `convert`＝identity（tw.linovelib 本繁體，不套 OpenCC）。
  /// - `illustrationSpoiler`/`chapterCommentEnabled`＝false：兩者對 web 皆**惰性**（擷取合成的
  ///   ChapterText.isbody 恆 0 → 防劇透門檻不觸發；web 無章末章評）。故 blocks **只依章節本身**，
  ///   字級/行距/主題/防劇透設定變更都不會重建 blocks（自然滿足 api-ver 的「避免捲動歸零」優化）。
  ReaderChapterContentProvider._({
    required ReaderChapterContentFamily super.from,
    required ChapterRef super.argument,
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
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ReaderChapterContent> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ReaderChapterContent> create(Ref ref) {
    final argument = this.argument as ChapterRef;
    return readerChapterContent(ref, argument);
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
    r'0f77e547403c61e251fbc03471f694c2873128e8';

/// 載入並建構某章內容：ChapterText（drift 快取優先，未命中 WebView 擷取）→ blocks。
///
/// web 適配（忠實對應 api-ver `readerChapterContent`，除下列）：
/// - `convert`＝identity（tw.linovelib 本繁體，不套 OpenCC）。
/// - `illustrationSpoiler`/`chapterCommentEnabled`＝false：兩者對 web 皆**惰性**（擷取合成的
///   ChapterText.isbody 恆 0 → 防劇透門檻不觸發；web 無章末章評）。故 blocks **只依章節本身**，
///   字級/行距/主題/防劇透設定變更都不會重建 blocks（自然滿足 api-ver 的「避免捲動歸零」優化）。

final class ReaderChapterContentFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ReaderChapterContent>, ChapterRef> {
  ReaderChapterContentFamily._()
    : super(
        retry: null,
        name: r'readerChapterContentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 載入並建構某章內容：ChapterText（drift 快取優先，未命中 WebView 擷取）→ blocks。
  ///
  /// web 適配（忠實對應 api-ver `readerChapterContent`，除下列）：
  /// - `convert`＝identity（tw.linovelib 本繁體，不套 OpenCC）。
  /// - `illustrationSpoiler`/`chapterCommentEnabled`＝false：兩者對 web 皆**惰性**（擷取合成的
  ///   ChapterText.isbody 恆 0 → 防劇透門檻不觸發；web 無章末章評）。故 blocks **只依章節本身**，
  ///   字級/行距/主題/防劇透設定變更都不會重建 blocks（自然滿足 api-ver 的「避免捲動歸零」優化）。

  ReaderChapterContentProvider call(ChapterRef chapter) =>
      ReaderChapterContentProvider._(argument: chapter, from: this);

  @override
  String toString() => r'readerChapterContentProvider';
}
