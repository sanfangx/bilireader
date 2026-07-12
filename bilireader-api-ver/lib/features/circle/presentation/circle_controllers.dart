import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/router/auth_controller.dart';
import '../../../core/social/reaction.dart';
import '../data/circle_providers.dart';
import '../domain/circle_entities.dart';

part 'circle_controllers.g.dart';

/// 圈子（社群 posts）需登入（doc 09 §7 loginRequiredPages 含 posts）；未登入短路，
/// 避免 401 觸發登入態刷新迴圈（§6.3）。
void _requireLogin(Ref ref) {
  if (!ref.watch(authControllerProvider).isLoggedIn) {
    throw ErrorMapper.fromBusinessCode(code: ApiConstants.codeTokenInvalid);
  }
}

const String kLatestCategory = 'latest';

/// 版塊清單（`circle/sections`）——供分類 chip 使用。
@riverpod
Future<List<CircleSection>> circleSections(Ref ref) async {
  _requireLogin(ref);
  return (await ref.watch(circleRepositoryProvider).sections()).dataOrThrow();
}

/// 目前選取的圈子分類 / 版塊（null sectionId = 「最新」全部）。
typedef CircleTab = ({String category, int? sectionId});

@riverpod
class CircleFeedFilter extends _$CircleFeedFilter {
  @override
  CircleTab build() => (category: kLatestCategory, sectionId: null);

  void selectLatest() => state = (category: kLatestCategory, sectionId: null);

  void selectSection(int sectionId) =>
      state = (category: kLatestCategory, sectionId: sectionId);
}

/// 圈子貼文列表（依 [circleFeedFilterProvider]，分頁累積）。
@immutable
class CircleFeedState {
  const CircleFeedState({
    this.posts = const <CirclePost>[],
    this.page = ApiConstants.firstPage,
    this.hasMore = true,
    this.loadingMore = false,
    this.loadMoreError = false,
  });

  final List<CirclePost> posts;
  final int page;
  final bool hasMore;
  final bool loadingMore;

  /// F-15：載入更多失敗（尾端顯示重試而非靜默停止）。
  final bool loadMoreError;

  CircleFeedState copyWith({
    List<CirclePost>? posts,
    int? page,
    bool? hasMore,
    bool? loadingMore,
    bool? loadMoreError,
  }) => CircleFeedState(
    posts: posts ?? this.posts,
    page: page ?? this.page,
    hasMore: hasMore ?? this.hasMore,
    loadingMore: loadingMore ?? this.loadingMore,
    loadMoreError: loadMoreError ?? this.loadMoreError,
  );
}

@riverpod
class CircleFeedController extends _$CircleFeedController {
  @override
  Future<CircleFeedState> build() async {
    final CircleTab tab = ref.watch(circleFeedFilterProvider);
    _requireLogin(ref);
    final CircleFeed feed =
        (await ref
                .read(circleRepositoryProvider)
                .list(
                  category: tab.category,
                  sectionId: tab.sectionId,
                  page: ApiConstants.firstPage,
                ))
            .dataOrThrow();
    return CircleFeedState(
      posts: feed.posts,
      page: feed.pageNum,
      hasMore: feed.hasMore,
    );
  }

  /// 單筆同步某貼文的讚/倒讚（UX F-05）：詳情按讚後 feed 即時反映，**不整列重抓** →
  /// 保捲動位置與已載分頁（體驗不變量#1）。該 topicId 不在已載清單則不動作。
  void applyReaction(int topicId, ReactionCounts counts) {
    final AsyncValue<CircleFeedState> current = state;
    if (current is! AsyncData<CircleFeedState>) {
      return;
    }
    final CircleFeedState view = current.value;
    final int idx = view.posts.indexWhere(
      (CirclePost p) => p.topicId == topicId,
    );
    if (idx < 0) {
      return;
    }
    final List<CirclePost> posts = <CirclePost>[...view.posts];
    posts[idx] = posts[idx].copyWithReaction(
      likeNum: counts.likeNum,
      badNum: counts.badNum,
      myReaction: counts.myReaction,
    );
    state = AsyncData<CircleFeedState>(view.copyWith(posts: posts));
  }

  /// F-14 下拉刷新：重抓第一頁但**保留現有列表**（不進 AsyncLoading，避免整頁閃 loading /
  /// 掉捲動）。僅在已有結果時有效；刷新失敗保留舊資料。刷新**成功**為權威覆蓋——
  /// 以伺服器第一頁重建（無 cancel-token 守門），期間發生的樂觀 applyReaction 會被覆蓋，
  /// 由下次伺服器資料校正（可接受權衡；feed 無 socket、非硬不變量）。
  Future<void> refresh() async {
    final AsyncValue<CircleFeedState> current = state;
    if (current is! AsyncData<CircleFeedState>) {
      return;
    }
    final CircleTab tab = ref.read(circleFeedFilterProvider);
    final ApiResult<CircleFeed> result = await ref
        .read(circleRepositoryProvider)
        .list(
          category: tab.category,
          sectionId: tab.sectionId,
          page: ApiConstants.firstPage,
        );
    // 刷新失敗：保留現有列表，不改動狀態（不變量#1，與 search 一致）。
    if (result is ApiSuccess<CircleFeed>) {
      final CircleFeed data = result.data;
      state = AsyncData<CircleFeedState>(
        CircleFeedState(
          posts: data.posts,
          page: data.pageNum,
          hasMore: data.hasMore,
        ),
      );
    }
  }

  Future<void> loadMore() async {
    final AsyncValue<CircleFeedState> current = state;
    if (current is! AsyncData<CircleFeedState>) {
      return;
    }
    final CircleFeedState view = current.value;
    if (!view.hasMore || view.loadingMore || view.loadMoreError) {
      return;
    }
    await _fetchMore(view);
  }

  /// F-15：載入更多失敗後由尾端「點擊重試」呼叫。
  Future<void> retryLoadMore() async {
    final AsyncValue<CircleFeedState> current = state;
    if (current is! AsyncData<CircleFeedState>) {
      return;
    }
    if (current.value.loadingMore) {
      return;
    }
    await _fetchMore(current.value.copyWith(loadMoreError: false));
  }

  Future<void> _fetchMore(CircleFeedState view) async {
    state = AsyncData<CircleFeedState>(
      view.copyWith(loadingMore: true, loadMoreError: false),
    );
    final CircleTab tab = ref.read(circleFeedFilterProvider);
    final ApiResult<CircleFeed> result = await ref
        .read(circleRepositoryProvider)
        .list(
          category: tab.category,
          sectionId: tab.sectionId,
          page: view.page + 1,
        );
    final AsyncValue<CircleFeedState> now = state;
    // 載入期間被 refresh/換分類/applyReaction 換掉（posts 參照改變）→ 丟棄本次分頁結果
    // （審查發現的競態）。但須清掉 loadingMore，否則卡在假 loading、分頁死掉（不變量#1）。
    if (now is! AsyncData<CircleFeedState> ||
        !identical(now.value.posts, view.posts)) {
      if (now is AsyncData<CircleFeedState> && now.value.loadingMore) {
        state = AsyncData<CircleFeedState>(
          now.value.copyWith(loadingMore: false),
        );
      }
      return;
    }
    // 以 now.value 為基底（guard 已確認 posts 與 view 相同）→ 保留期間其它欄位更新。
    switch (result) {
      case ApiSuccess<CircleFeed>(:final CircleFeed data):
        state = AsyncData<CircleFeedState>(
          now.value.copyWith(
            posts: <CirclePost>[...now.value.posts, ...data.posts],
            page: data.pageNum,
            hasMore: data.hasMore,
            loadingMore: false,
          ),
        );
      case ApiFailure<CircleFeed>():
        // F-15：失敗 → 標記 loadMoreError（尾端顯示重試），不靜默 hasMore=false。
        state = AsyncData<CircleFeedState>(
          now.value.copyWith(loadingMore: false, loadMoreError: true),
        );
    }
  }
}

/// 貼文詳情（`circle/detail`）。
@riverpod
Future<CirclePost> circlePostDetail(Ref ref, int topicId) async {
  _requireLogin(ref);
  return (await ref.watch(circleRepositoryProvider).detail(topicId))
      .dataOrThrow();
}

/// 貼文回覆列表狀態（分頁累積）。
@immutable
class CircleRepliesState {
  const CircleRepliesState({
    this.replies = const <CircleReply>[],
    this.page = ApiConstants.firstPage,
    this.hasMore = true,
    this.loadingMore = false,
    this.loadMoreError = false,
  });

  final List<CircleReply> replies;
  final int page;
  final bool hasMore;
  final bool loadingMore;

  /// F-15：載入更多失敗（尾端顯示重試而非靜默停止）。
  final bool loadMoreError;

  CircleRepliesState copyWith({
    List<CircleReply>? replies,
    int? page,
    bool? hasMore,
    bool? loadingMore,
    bool? loadMoreError,
  }) => CircleRepliesState(
    replies: replies ?? this.replies,
    page: page ?? this.page,
    hasMore: hasMore ?? this.hasMore,
    loadingMore: loadingMore ?? this.loadingMore,
    loadMoreError: loadMoreError ?? this.loadMoreError,
  );
}

/// 貼文回覆（`circle/replies`，分頁累積）。
@riverpod
class CircleRepliesController extends _$CircleRepliesController {
  @override
  Future<CircleRepliesState> build(int topicId) async {
    _requireLogin(ref);
    final CircleReplyPage first =
        (await ref
                .read(circleRepositoryProvider)
                .replies(topicId: topicId, page: ApiConstants.firstPage))
            .dataOrThrow();
    return CircleRepliesState(
      replies: first.replies,
      page: first.pageNum,
      hasMore: first.hasMore,
    );
  }

  /// F-14 下拉刷新：重抓第一頁但**保留現有列表**（不進 AsyncLoading）。刷新失敗保留舊資料。
  Future<void> refresh() async {
    final AsyncValue<CircleRepliesState> current = state;
    if (current is! AsyncData<CircleRepliesState>) {
      return;
    }
    final ApiResult<CircleReplyPage> result = await ref
        .read(circleRepositoryProvider)
        .replies(topicId: topicId, page: ApiConstants.firstPage);
    // 刷新失敗：保留現有列表，不改動狀態（不變量#1，與 search 一致）。
    if (result is ApiSuccess<CircleReplyPage>) {
      final CircleReplyPage p = result.data;
      state = AsyncData<CircleRepliesState>(
        CircleRepliesState(
          replies: p.replies,
          page: p.pageNum,
          hasMore: p.hasMore,
        ),
      );
    }
  }

  Future<void> loadMore() async {
    final AsyncValue<CircleRepliesState> current = state;
    if (current is! AsyncData<CircleRepliesState>) {
      return;
    }
    final CircleRepliesState view = current.value;
    if (!view.hasMore || view.loadingMore || view.loadMoreError) {
      return;
    }
    await _fetchMore(view);
  }

  /// F-15：載入更多失敗後由尾端「點擊重試」呼叫。
  Future<void> retryLoadMore() async {
    final AsyncValue<CircleRepliesState> current = state;
    if (current is! AsyncData<CircleRepliesState>) {
      return;
    }
    if (current.value.loadingMore) {
      return;
    }
    await _fetchMore(current.value.copyWith(loadMoreError: false));
  }

  Future<void> _fetchMore(CircleRepliesState view) async {
    state = AsyncData<CircleRepliesState>(
      view.copyWith(loadingMore: true, loadMoreError: false),
    );
    final ApiResult<CircleReplyPage> result = await ref
        .read(circleRepositoryProvider)
        .replies(topicId: topicId, page: view.page + 1);
    final AsyncValue<CircleRepliesState> now = state;
    // 載入期間被 refresh 換掉（replies 參照改變）→ 丟棄本次分頁結果（審查發現的競態）。
    // 但須清掉 loadingMore，否則卡在假 loading、分頁死掉（不變量#1）。
    if (now is! AsyncData<CircleRepliesState> ||
        !identical(now.value.replies, view.replies)) {
      if (now is AsyncData<CircleRepliesState> && now.value.loadingMore) {
        state = AsyncData<CircleRepliesState>(
          now.value.copyWith(loadingMore: false),
        );
      }
      return;
    }
    switch (result) {
      case ApiSuccess<CircleReplyPage>(:final CircleReplyPage data):
        state = AsyncData<CircleRepliesState>(
          now.value.copyWith(
            replies: <CircleReply>[...now.value.replies, ...data.replies],
            page: data.pageNum,
            hasMore: data.hasMore,
            loadingMore: false,
          ),
        );
      case ApiFailure<CircleReplyPage>():
        // F-15：失敗 → 標記 loadMoreError（尾端顯示重試），不靜默 hasMore=false。
        state = AsyncData<CircleRepliesState>(
          now.value.copyWith(loadingMore: false, loadMoreError: true),
        );
    }
  }
}

/// 圈子互動（like / reply_like / publish / reply）。狀態變更端點（§7.0），僅供
/// 使用者操作、不做破壞性自動測試。成功後由呼叫端 invalidate 對應 provider。
@riverpod
class CircleActions extends _$CircleActions {
  @override
  void build() {}

  Future<ApiResult<int>> publish({
    required int sectionId,
    required String title,
    required String content,
    List<XFile> images = const <XFile>[],
  }) => ref
      .read(circleRepositoryProvider)
      .publish(
        sectionId: sectionId,
        title: title,
        content: content,
        images: images,
      );

  Future<ApiResult<CircleReply>> reply({
    required int topicId,
    required String posttext,
    int? replyPid,
    List<XFile> images = const <XFile>[],
  }) => ref
      .read(circleRepositoryProvider)
      .reply(
        topicId: topicId,
        posttext: posttext,
        replyPid: replyPid,
        images: images,
      );
}
