// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 目前書評排序（最新 / 最熱）。

@ProviderFor(ReviewSort)
final reviewSortProvider = ReviewSortProvider._();

/// 目前書評排序（最新 / 最熱）。
final class ReviewSortProvider
    extends $NotifierProvider<ReviewSort, BookReviewSort> {
  /// 目前書評排序（最新 / 最熱）。
  ReviewSortProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewSortProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewSortHash();

  @$internal
  @override
  ReviewSort create() => ReviewSort();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookReviewSort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookReviewSort>(value),
    );
  }
}

String _$reviewSortHash() => r'f0c2e6490142e5c93973051db9d1c5d4b91212ad';

/// 目前書評排序（最新 / 最熱）。

abstract class _$ReviewSort extends $Notifier<BookReviewSort> {
  BookReviewSort build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<BookReviewSort, BookReviewSort>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BookReviewSort, BookReviewSort>,
              BookReviewSort,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(ReviewListController)
final reviewListControllerProvider = ReviewListControllerFamily._();

final class ReviewListControllerProvider
    extends $AsyncNotifierProvider<ReviewListController, ReviewListState> {
  ReviewListControllerProvider._({
    required ReviewListControllerFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'reviewListControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$reviewListControllerHash();

  @override
  String toString() {
    return r'reviewListControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ReviewListController create() => ReviewListController();

  @override
  bool operator ==(Object other) {
    return other is ReviewListControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reviewListControllerHash() =>
    r'99f75ae476ebd8a16ceb89ba30540d4682e956b7';

final class ReviewListControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ReviewListController,
          AsyncValue<ReviewListState>,
          ReviewListState,
          FutureOr<ReviewListState>,
          int
        > {
  ReviewListControllerFamily._()
    : super(
        retry: null,
        name: r'reviewListControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ReviewListControllerProvider call(int articleId) =>
      ReviewListControllerProvider._(argument: articleId, from: this);

  @override
  String toString() => r'reviewListControllerProvider';
}

abstract class _$ReviewListController extends $AsyncNotifier<ReviewListState> {
  late final _$args = ref.$arg as int;
  int get articleId => _$args;

  FutureOr<ReviewListState> build(int articleId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ReviewListState>, ReviewListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ReviewListState>, ReviewListState>,
              AsyncValue<ReviewListState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// 書評詳情（`book_review/detail`）。

@ProviderFor(reviewDetail)
final reviewDetailProvider = ReviewDetailFamily._();

/// 書評詳情（`book_review/detail`）。

final class ReviewDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<BookReview>,
          BookReview,
          FutureOr<BookReview>
        >
    with $FutureModifier<BookReview>, $FutureProvider<BookReview> {
  /// 書評詳情（`book_review/detail`）。
  ReviewDetailProvider._({
    required ReviewDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'reviewDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$reviewDetailHash();

  @override
  String toString() {
    return r'reviewDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<BookReview> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<BookReview> create(Ref ref) {
    final argument = this.argument as int;
    return reviewDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ReviewDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reviewDetailHash() => r'4cd283d06ee9e28c92b1ace9ceff8e3fb805f241';

/// 書評詳情（`book_review/detail`）。

final class ReviewDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<BookReview>, int> {
  ReviewDetailFamily._()
    : super(
        retry: null,
        name: r'reviewDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 書評詳情（`book_review/detail`）。

  ReviewDetailProvider call(int topicId) =>
      ReviewDetailProvider._(argument: topicId, from: this);

  @override
  String toString() => r'reviewDetailProvider';
}

@ProviderFor(ReviewRepliesController)
final reviewRepliesControllerProvider = ReviewRepliesControllerFamily._();

final class ReviewRepliesControllerProvider
    extends
        $AsyncNotifierProvider<ReviewRepliesController, ReviewRepliesState> {
  ReviewRepliesControllerProvider._({
    required ReviewRepliesControllerFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'reviewRepliesControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$reviewRepliesControllerHash();

  @override
  String toString() {
    return r'reviewRepliesControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ReviewRepliesController create() => ReviewRepliesController();

  @override
  bool operator ==(Object other) {
    return other is ReviewRepliesControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reviewRepliesControllerHash() =>
    r'82e9485ac6e825658a8434c457f3a029c881f01e';

final class ReviewRepliesControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ReviewRepliesController,
          AsyncValue<ReviewRepliesState>,
          ReviewRepliesState,
          FutureOr<ReviewRepliesState>,
          int
        > {
  ReviewRepliesControllerFamily._()
    : super(
        retry: null,
        name: r'reviewRepliesControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ReviewRepliesControllerProvider call(int topicId) =>
      ReviewRepliesControllerProvider._(argument: topicId, from: this);

  @override
  String toString() => r'reviewRepliesControllerProvider';
}

abstract class _$ReviewRepliesController
    extends $AsyncNotifier<ReviewRepliesState> {
  late final _$args = ref.$arg as int;
  int get topicId => _$args;

  FutureOr<ReviewRepliesState> build(int topicId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ReviewRepliesState>, ReviewRepliesState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ReviewRepliesState>, ReviewRepliesState>,
              AsyncValue<ReviewRepliesState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// 書評互動（add / reply / like / reply_like）。狀態變更端點（§7.0），僅供使用者
/// 操作、不做破壞性自動測試。成功後由呼叫端 invalidate 對應 provider。

@ProviderFor(ReviewActions)
final reviewActionsProvider = ReviewActionsProvider._();

/// 書評互動（add / reply / like / reply_like）。狀態變更端點（§7.0），僅供使用者
/// 操作、不做破壞性自動測試。成功後由呼叫端 invalidate 對應 provider。
final class ReviewActionsProvider
    extends $NotifierProvider<ReviewActions, void> {
  /// 書評互動（add / reply / like / reply_like）。狀態變更端點（§7.0），僅供使用者
  /// 操作、不做破壞性自動測試。成功後由呼叫端 invalidate 對應 provider。
  ReviewActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewActionsHash();

  @$internal
  @override
  ReviewActions create() => ReviewActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$reviewActionsHash() => r'88ae67e10a7140b473751768629e660df8846275';

/// 書評互動（add / reply / like / reply_like）。狀態變更端點（§7.0），僅供使用者
/// 操作、不做破壞性自動測試。成功後由呼叫端 invalidate 對應 provider。

abstract class _$ReviewActions extends $Notifier<void> {
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
