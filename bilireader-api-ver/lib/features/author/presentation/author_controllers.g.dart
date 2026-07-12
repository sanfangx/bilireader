// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 我的作品清單（`author/novel/list`）。

@ProviderFor(myNovels)
final myNovelsProvider = MyNovelsProvider._();

/// 我的作品清單（`author/novel/list`）。

final class MyNovelsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AuthorNovel>>,
          List<AuthorNovel>,
          FutureOr<List<AuthorNovel>>
        >
    with
        $FutureModifier<List<AuthorNovel>>,
        $FutureProvider<List<AuthorNovel>> {
  /// 我的作品清單（`author/novel/list`）。
  MyNovelsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myNovelsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myNovelsHash();

  @$internal
  @override
  $FutureProviderElement<List<AuthorNovel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AuthorNovel>> create(Ref ref) {
    return myNovels(ref);
  }
}

String _$myNovelsHash() => r'7cb9f790cf0681d7f7d13dd3789334d36ba9aee0';

/// 某作品的章節樹（`author/chapter/tree`）。

@ProviderFor(authorChapterTree)
final authorChapterTreeProvider = AuthorChapterTreeFamily._();

/// 某作品的章節樹（`author/chapter/tree`）。

final class AuthorChapterTreeProvider
    extends
        $FunctionalProvider<
          AsyncValue<AuthorChapterTree>,
          AuthorChapterTree,
          FutureOr<AuthorChapterTree>
        >
    with
        $FutureModifier<AuthorChapterTree>,
        $FutureProvider<AuthorChapterTree> {
  /// 某作品的章節樹（`author/chapter/tree`）。
  AuthorChapterTreeProvider._({
    required AuthorChapterTreeFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'authorChapterTreeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$authorChapterTreeHash();

  @override
  String toString() {
    return r'authorChapterTreeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<AuthorChapterTree> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AuthorChapterTree> create(Ref ref) {
    final argument = this.argument as int;
    return authorChapterTree(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AuthorChapterTreeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$authorChapterTreeHash() => r'8d98b18c18946b164e2fad2fa5f7dd3903fec58d';

/// 某作品的章節樹（`author/chapter/tree`）。

final class AuthorChapterTreeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<AuthorChapterTree>, int> {
  AuthorChapterTreeFamily._()
    : super(
        retry: null,
        name: r'authorChapterTreeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 某作品的章節樹（`author/chapter/tree`）。

  AuthorChapterTreeProvider call(int articleId) =>
      AuthorChapterTreeProvider._(argument: articleId, from: this);

  @override
  String toString() => r'authorChapterTreeProvider';
}

/// 作者寫入動作（草稿 / 發佈 / 章節 / 卷 / 封面 / 插圖）。皆為狀態變更端點（§7.0），
/// 僅供實際使用者操作、不做破壞性自動測試。成功後由呼叫端 invalidate 對應 provider。

@ProviderFor(AuthorActions)
final authorActionsProvider = AuthorActionsProvider._();

/// 作者寫入動作（草稿 / 發佈 / 章節 / 卷 / 封面 / 插圖）。皆為狀態變更端點（§7.0），
/// 僅供實際使用者操作、不做破壞性自動測試。成功後由呼叫端 invalidate 對應 provider。
final class AuthorActionsProvider
    extends $NotifierProvider<AuthorActions, void> {
  /// 作者寫入動作（草稿 / 發佈 / 章節 / 卷 / 封面 / 插圖）。皆為狀態變更端點（§7.0），
  /// 僅供實際使用者操作、不做破壞性自動測試。成功後由呼叫端 invalidate 對應 provider。
  AuthorActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authorActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authorActionsHash();

  @$internal
  @override
  AuthorActions create() => AuthorActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$authorActionsHash() => r'd89dfb3baaa84c780beba678ce99541c30ee2b07';

/// 作者寫入動作（草稿 / 發佈 / 章節 / 卷 / 封面 / 插圖）。皆為狀態變更端點（§7.0），
/// 僅供實際使用者操作、不做破壞性自動測試。成功後由呼叫端 invalidate 對應 provider。

abstract class _$AuthorActions extends $Notifier<void> {
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
