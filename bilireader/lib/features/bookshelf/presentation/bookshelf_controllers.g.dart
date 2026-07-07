// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookshelf_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BookshelfFilter)
final bookshelfFilterProvider = BookshelfFilterProvider._();

final class BookshelfFilterProvider
    extends $NotifierProvider<BookshelfFilter, BookshelfQuery> {
  BookshelfFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookshelfFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookshelfFilterHash();

  @$internal
  @override
  BookshelfFilter create() => BookshelfFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookshelfQuery value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookshelfQuery>(value),
    );
  }
}

String _$bookshelfFilterHash() => r'4b087ce4c03b03a078358d0f39558078b571b557';

abstract class _$BookshelfFilter extends $Notifier<BookshelfQuery> {
  BookshelfQuery build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<BookshelfQuery, BookshelfQuery>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BookshelfQuery, BookshelfQuery>,
              BookshelfQuery,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 書架清單（`bookcase/list`，依 [bookshelfFilterProvider] 的分類 + 排序）。
/// 空清單為正常狀態；業務錯誤以 [AppError] 拋出交由頁面呈現。

@ProviderFor(bookshelfList)
final bookshelfListProvider = BookshelfListProvider._();

/// 書架清單（`bookcase/list`，依 [bookshelfFilterProvider] 的分類 + 排序）。
/// 空清單為正常狀態；業務錯誤以 [AppError] 拋出交由頁面呈現。

final class BookshelfListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BookshelfEntry>>,
          List<BookshelfEntry>,
          FutureOr<List<BookshelfEntry>>
        >
    with
        $FutureModifier<List<BookshelfEntry>>,
        $FutureProvider<List<BookshelfEntry>> {
  /// 書架清單（`bookcase/list`，依 [bookshelfFilterProvider] 的分類 + 排序）。
  /// 空清單為正常狀態；業務錯誤以 [AppError] 拋出交由頁面呈現。
  BookshelfListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookshelfListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookshelfListHash();

  @$internal
  @override
  $FutureProviderElement<List<BookshelfEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BookshelfEntry>> create(Ref ref) {
    return bookshelfList(ref);
  }
}

String _$bookshelfListHash() => r'76a31cee0ca03ed79d1722e832c104654292c034';

/// 書架異動（移除 / 變更分類）。皆為狀態變更端點（§7.0），僅供實際使用者操作，
/// 不做破壞性自動測試。成功後 invalidate 清單以重新載入。

@ProviderFor(BookshelfMutations)
final bookshelfMutationsProvider = BookshelfMutationsProvider._();

/// 書架異動（移除 / 變更分類）。皆為狀態變更端點（§7.0），僅供實際使用者操作，
/// 不做破壞性自動測試。成功後 invalidate 清單以重新載入。
final class BookshelfMutationsProvider
    extends $NotifierProvider<BookshelfMutations, void> {
  /// 書架異動（移除 / 變更分類）。皆為狀態變更端點（§7.0），僅供實際使用者操作，
  /// 不做破壞性自動測試。成功後 invalidate 清單以重新載入。
  BookshelfMutationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookshelfMutationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookshelfMutationsHash();

  @$internal
  @override
  BookshelfMutations create() => BookshelfMutations();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$bookshelfMutationsHash() =>
    r'77516eee43e3c35f9d21c780a4be74f9225cb955';

/// 書架異動（移除 / 變更分類）。皆為狀態變更端點（§7.0），僅供實際使用者操作，
/// 不做破壞性自動測試。成功後 invalidate 清單以重新載入。

abstract class _$BookshelfMutations extends $Notifier<void> {
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
