import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/router/auth_controller.dart';
import '../../../core/social/reaction.dart';
import '../data/review_providers.dart';
import '../domain/review_entities.dart';
import '../domain/review_options.dart';

part 'review_controllers.g.dart';

/// 書評需登入（doc 09 §7 loginRequiredPages 含 reviews）；未登入短路避免 401 迴圈（§6.3）。
void _requireLogin(Ref ref) {
  if (!ref.watch(authControllerProvider).isLoggedIn) {
    throw ErrorMapper.fromBusinessCode(code: ApiConstants.codeTokenInvalid);
  }
}

/// 目前書評排序（最新 / 最熱）。
@riverpod
class ReviewSort extends _$ReviewSort {
  @override
  BookReviewSort build() => BookReviewSort.defaultValue;

  void select(BookReviewSort sort) {
    if (sort != state) {
      state = sort;
    }
  }
}

/// 某書書評列表狀態（分頁累積）。
@immutable
class ReviewListState {
  const ReviewListState({
    this.reviews = const <BookReview>[],
    this.total = 0,
    this.page = ApiConstants.firstPage,
    this.hasMore = true,
    this.loadingMore = false,
    this.loadMoreError = false,
  });

  final List<BookReview> reviews;
  final int total;
  final int page;
  final bool hasMore;
  final bool loadingMore;

  /// F-15：載入更多失敗（尾端顯示重試而非靜默停止）。
  final bool loadMoreError;

  ReviewListState copyWith({
    List<BookReview>? reviews,
    int? total,
    int? page,
    bool? hasMore,
    bool? loadingMore,
    bool? loadMoreError,
  }) => ReviewListState(
    reviews: reviews ?? this.reviews,
    total: total ?? this.total,
    page: page ?? this.page,
    hasMore: hasMore ?? this.hasMore,
    loadingMore: loadingMore ?? this.loadingMore,
    loadMoreError: loadMoreError ?? this.loadMoreError,
  );
}

@riverpod
class ReviewListController extends _$ReviewListController {
  @override
  Future<ReviewListState> build(int articleId) async {
    final BookReviewSort sort = ref.watch(reviewSortProvider);
    _requireLogin(ref);
    final BookReviewPage p =
        (await ref
                .read(reviewRepositoryProvider)
                .list(
                  articleId: articleId,
                  sort: sort,
                  page: ApiConstants.firstPage,
                ))
            .dataOrThrow();
    return ReviewListState(
      reviews: p.reviews,
      total: p.total,
      page: p.pageNum,
      hasMore: p.hasMore,
    );
  }

  /// 單筆同步某書評的讚/回覆數（UX F-07）：詳情操作後列表即時反映，**不整列重抓** →
  /// 保捲動位置與已載分頁（體驗不變量#1）。該 topicId 不在已載清單則不動作。
  void applyStats(
    int topicId, {
    int? likeNum,
    int? badNum,
    Reaction? myReaction,
    int repliesDelta = 0,
  }) {
    final AsyncValue<ReviewListState> current = state;
    if (current is! AsyncData<ReviewListState>) {
      return;
    }
    final ReviewListState view = current.value;
    final int idx = view.reviews.indexWhere(
      (BookReview r) => r.topicId == topicId,
    );
    if (idx < 0) {
      return;
    }
    final BookReview cur = view.reviews[idx];
    final List<BookReview> reviews = <BookReview>[...view.reviews];
    reviews[idx] = cur.copyWith(
      likeNum: likeNum,
      badNum: badNum,
      myReaction: myReaction,
      replies: repliesDelta != 0 ? cur.replies + repliesDelta : null,
    );
    state = AsyncData<ReviewListState>(view.copyWith(reviews: reviews));
  }

  /// F-14 下拉刷新：重抓第一頁但**保留現有列表**（不進 AsyncLoading，避免整頁閃 loading /
  /// 掉捲動）。僅在已有結果時有效；刷新失敗保留舊資料。
  Future<void> refresh() async {
    final AsyncValue<ReviewListState> current = state;
    if (current is! AsyncData<ReviewListState>) {
      return;
    }
    final BookReviewSort sort = ref.read(reviewSortProvider);
    final ApiResult<BookReviewPage> result = await ref
        .read(reviewRepositoryProvider)
        .list(articleId: articleId, sort: sort, page: ApiConstants.firstPage);
    // 刷新失敗：保留現有列表，不改動狀態（不變量#1）。
    if (result is ApiSuccess<BookReviewPage>) {
      final BookReviewPage p = result.data;
      state = AsyncData<ReviewListState>(
        ReviewListState(
          reviews: p.reviews,
          total: p.total,
          page: p.pageNum,
          hasMore: p.hasMore,
        ),
      );
    }
  }

  Future<void> loadMore() async {
    final AsyncValue<ReviewListState> current = state;
    if (current is! AsyncData<ReviewListState>) {
      return;
    }
    final ReviewListState view = current.value;
    if (!view.hasMore || view.loadingMore || view.loadMoreError) {
      return;
    }
    await _fetchMore(view);
  }

  /// F-15：載入更多失敗後由尾端「點擊重試」呼叫。
  Future<void> retryLoadMore() async {
    final AsyncValue<ReviewListState> current = state;
    if (current is! AsyncData<ReviewListState>) {
      return;
    }
    if (current.value.loadingMore) {
      return;
    }
    await _fetchMore(current.value.copyWith(loadMoreError: false));
  }

  Future<void> _fetchMore(ReviewListState view) async {
    state = AsyncData<ReviewListState>(
      view.copyWith(loadingMore: true, loadMoreError: false),
    );
    final BookReviewSort sort = ref.read(reviewSortProvider);
    final ApiResult<BookReviewPage> result = await ref
        .read(reviewRepositoryProvider)
        .list(articleId: articleId, sort: sort, page: view.page + 1);
    final AsyncValue<ReviewListState> now = state;
    // 載入期間被 refresh/applyStats 換掉（reviews 參照改變）→ 丟棄本次分頁結果（審查發現的競態）。
    // 但須清掉 loadingMore，否則卡在假 loading、分頁死掉（不變量#1）。
    if (now is! AsyncData<ReviewListState> ||
        !identical(now.value.reviews, view.reviews)) {
      if (now is AsyncData<ReviewListState> && now.value.loadingMore) {
        state = AsyncData<ReviewListState>(
          now.value.copyWith(loadingMore: false),
        );
      }
      return;
    }
    switch (result) {
      case ApiSuccess<BookReviewPage>(:final BookReviewPage data):
        state = AsyncData<ReviewListState>(
          now.value.copyWith(
            reviews: <BookReview>[...now.value.reviews, ...data.reviews],
            page: data.pageNum,
            hasMore: data.hasMore,
            loadingMore: false,
          ),
        );
      case ApiFailure<BookReviewPage>():
        // F-15：失敗 → 標記 loadMoreError（尾端顯示重試），不靜默 hasMore=false。
        state = AsyncData<ReviewListState>(
          now.value.copyWith(loadingMore: false, loadMoreError: true),
        );
    }
  }
}

/// 書評詳情（`book_review/detail`）。
@riverpod
Future<BookReview> reviewDetail(Ref ref, int topicId) async {
  _requireLogin(ref);
  return (await ref.watch(reviewRepositoryProvider).detail(topicId))
      .dataOrThrow();
}

/// 書評回覆列表狀態（分頁累積）。
@immutable
class ReviewRepliesState {
  const ReviewRepliesState({
    this.replies = const <BookReviewReply>[],
    this.page = ApiConstants.firstPage,
    this.hasMore = true,
    this.loadingMore = false,
  });

  final List<BookReviewReply> replies;
  final int page;
  final bool hasMore;
  final bool loadingMore;

  ReviewRepliesState copyWith({
    List<BookReviewReply>? replies,
    int? page,
    bool? hasMore,
    bool? loadingMore,
  }) => ReviewRepliesState(
    replies: replies ?? this.replies,
    page: page ?? this.page,
    hasMore: hasMore ?? this.hasMore,
    loadingMore: loadingMore ?? this.loadingMore,
  );
}

@riverpod
class ReviewRepliesController extends _$ReviewRepliesController {
  @override
  Future<ReviewRepliesState> build(int topicId) async {
    _requireLogin(ref);
    final BookReviewReplyList first =
        (await ref
                .read(reviewRepositoryProvider)
                .replies(topicId: topicId, page: ApiConstants.firstPage))
            .dataOrThrow();
    return ReviewRepliesState(
      replies: first.replies,
      page: first.pageNum,
      hasMore: first.hasMore,
    );
  }

  Future<void> loadMore() async {
    final AsyncValue<ReviewRepliesState> current = state;
    if (current is! AsyncData<ReviewRepliesState>) {
      return;
    }
    final ReviewRepliesState view = current.value;
    if (!view.hasMore || view.loadingMore) {
      return;
    }
    state = AsyncData<ReviewRepliesState>(view.copyWith(loadingMore: true));
    final ApiResult<BookReviewReplyList> result = await ref
        .read(reviewRepositoryProvider)
        .replies(topicId: topicId, page: view.page + 1);
    switch (result) {
      case ApiSuccess<BookReviewReplyList>(:final BookReviewReplyList data):
        state = AsyncData<ReviewRepliesState>(
          view.copyWith(
            replies: <BookReviewReply>[...view.replies, ...data.replies],
            page: data.pageNum,
            hasMore: data.hasMore,
            loadingMore: false,
          ),
        );
      case ApiFailure<BookReviewReplyList>():
        state = AsyncData<ReviewRepliesState>(
          view.copyWith(loadingMore: false, hasMore: false),
        );
    }
  }
}

/// 書評互動（add / reply / like / reply_like）。狀態變更端點（§7.0），僅供使用者
/// 操作、不做破壞性自動測試。成功後由呼叫端 invalidate 對應 provider。
@riverpod
class ReviewActions extends _$ReviewActions {
  @override
  void build() {}

  Future<ApiResult<int>> add({
    required int articleId,
    required String content,
    bool isSpoiler = false,
  }) => ref
      .read(reviewRepositoryProvider)
      .add(articleId: articleId, content: content, isSpoiler: isSpoiler);

  Future<ApiResult<BookReviewReply>> reply({
    required int topicId,
    required String posttext,
    int? replyPid,
  }) => ref
      .read(reviewRepositoryProvider)
      .reply(topicId: topicId, posttext: posttext, replyPid: replyPid);
}
