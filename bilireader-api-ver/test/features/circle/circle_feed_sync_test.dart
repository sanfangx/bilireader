import 'dart:async';

import 'package:bilireader/core/network/api_result.dart';
import 'package:bilireader/core/network/app_error.dart';
import 'package:bilireader/core/router/auth_controller.dart';
import 'package:bilireader/core/social/reaction.dart';
import 'package:bilireader/features/circle/data/circle_providers.dart';
import 'package:bilireader/features/circle/domain/circle_entities.dart';
import 'package:bilireader/features/circle/domain/circle_repository.dart';
import 'package:bilireader/features/circle/presentation/circle_controllers.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 強制登入態，讓 `_requireLogin` 通過，不觸及 session 儲存。
class _LoggedInAuth extends AuthController {
  @override
  AuthSnapshot build() => const AuthSnapshot(isLoggedIn: true, groupId: 2);
}

class _FakeCircleRepo implements CircleRepository {
  _FakeCircleRepo(this._feed);

  final CircleFeed _feed;

  @override
  Future<ApiResult<CircleFeed>> list({
    String category = 'latest',
    int? sectionId,
    String? keyword,
    int page = 1,
  }) async => ApiSuccess<CircleFeed>(_feed);

  @override
  Future<ApiResult<List<CircleSection>>> sections() async =>
      const ApiSuccess<List<CircleSection>>(<CircleSection>[]);

  @override
  Future<ApiResult<CirclePost>> detail(int topicId) async =>
      throw UnimplementedError();

  @override
  Future<ApiResult<CircleReplyPage>> replies({
    required int topicId,
    int page = 1,
  }) async => throw UnimplementedError();

  @override
  Future<ApiResult<ReactionCounts>> like({
    required int topicId,
    required int type,
  }) async => const ApiSuccess<ReactionCounts>(ReactionCounts());

  @override
  Future<ApiResult<ReactionCounts>> replyLike({
    required int postId,
    required int type,
  }) async => throw UnimplementedError();

  @override
  Future<ApiResult<int>> publish({
    required int sectionId,
    required String title,
    required String content,
    List<XFile> images = const <XFile>[],
  }) async => const ApiSuccess<int>(1);

  @override
  Future<ApiResult<CircleReply>> reply({
    required int topicId,
    required String posttext,
    int? replyPid,
    List<XFile> images = const <XFile>[],
  }) async => throw UnimplementedError();
}

/// 依 page 回傳預設結果的圈子 repo（驗 F-14/F-15 分頁四態）。
class _ProgCircleRepo implements CircleRepository {
  _ProgCircleRepo(this.byPage);
  final Map<int, ApiResult<CircleFeed>> byPage;

  @override
  Future<ApiResult<CircleFeed>> list({
    String category = 'latest',
    int? sectionId,
    String? keyword,
    int page = 1,
  }) async =>
      byPage[page] ??
      const ApiFailure<CircleFeed>(
        AppError(kind: AppErrorKind.network, message: '離線'),
      );

  @override
  Future<ApiResult<List<CircleSection>>> sections() async =>
      const ApiSuccess<List<CircleSection>>(<CircleSection>[]);

  @override
  Future<ApiResult<CirclePost>> detail(int topicId) async =>
      throw UnimplementedError();

  @override
  Future<ApiResult<CircleReplyPage>> replies({
    required int topicId,
    int page = 1,
  }) async => throw UnimplementedError();

  @override
  Future<ApiResult<ReactionCounts>> like({
    required int topicId,
    required int type,
  }) async => const ApiSuccess<ReactionCounts>(ReactionCounts());

  @override
  Future<ApiResult<ReactionCounts>> replyLike({
    required int postId,
    required int type,
  }) async => throw UnimplementedError();

  @override
  Future<ApiResult<int>> publish({
    required int sectionId,
    required String title,
    required String content,
    List<XFile> images = const <XFile>[],
  }) async => const ApiSuccess<int>(1);

  @override
  Future<ApiResult<CircleReply>> reply({
    required int topicId,
    required String posttext,
    int? replyPid,
    List<XFile> images = const <XFile>[],
  }) async => throw UnimplementedError();
}

/// page 1 立即回、page 2 由 [gate] 控制何時落地 —— 用來重現「載入更多進行中被
/// 樂觀更新（applyReaction）改寫列表參照」的競態（HIGH：守門早退須清 loadingMore）。
class _GatedCircleRepo implements CircleRepository {
  _GatedCircleRepo(this.page1, this.page2);
  final CircleFeed page1;
  final CircleFeed page2;
  final Completer<void> gate = Completer<void>();

  @override
  Future<ApiResult<CircleFeed>> list({
    String category = 'latest',
    int? sectionId,
    String? keyword,
    int page = 1,
  }) async {
    if (page == 1) {
      return ApiSuccess<CircleFeed>(page1);
    }
    if (!gate.isCompleted) {
      await gate.future;
    }
    return ApiSuccess<CircleFeed>(page2);
  }

  @override
  Future<ApiResult<List<CircleSection>>> sections() async =>
      const ApiSuccess<List<CircleSection>>(<CircleSection>[]);
  @override
  Future<ApiResult<CirclePost>> detail(int topicId) async =>
      throw UnimplementedError();
  @override
  Future<ApiResult<CircleReplyPage>> replies({
    required int topicId,
    int page = 1,
  }) async => throw UnimplementedError();
  @override
  Future<ApiResult<ReactionCounts>> like({
    required int topicId,
    required int type,
  }) async => const ApiSuccess<ReactionCounts>(ReactionCounts());
  @override
  Future<ApiResult<ReactionCounts>> replyLike({
    required int postId,
    required int type,
  }) async => throw UnimplementedError();
  @override
  Future<ApiResult<int>> publish({
    required int sectionId,
    required String title,
    required String content,
    List<XFile> images = const <XFile>[],
  }) async => const ApiSuccess<int>(1);
  @override
  Future<ApiResult<CircleReply>> reply({
    required int topicId,
    required String posttext,
    int? replyPid,
    List<XFile> images = const <XFile>[],
  }) async => throw UnimplementedError();
}

CircleFeed _feedPage(int page, int count, {required bool hasMore}) =>
    CircleFeed(
      posts: List<CirclePost>.generate(count, (int i) => _post(page * 100 + i)),
      pageNum: page,
      pages: hasMore ? page + 1 : page,
      total: 999,
    );

CirclePost _post(int topicId, {int likeNum = 0}) => CirclePost(
  topicId: topicId,
  title: '標題$topicId',
  content: '內文$topicId',
  authorName: '作者$topicId',
  authorLevel: 'Lv3',
  avatarUrl: 'https://x/$topicId.png',
  sectionName: '版塊',
  likeNum: likeNum,
  badNum: 1,
  replies: 2,
  views: 100,
  postTime: 1700000000 + topicId,
  imageUrls: <String>['https://img/$topicId.jpg'],
  articleId: topicId * 10,
  articleName: '書$topicId',
);

Future<ProviderContainer> _seed(CircleFeed feed) async {
  final ProviderContainer container = ProviderContainer(
    overrides: [
      authControllerProvider.overrideWith(_LoggedInAuth.new),
      circleRepositoryProvider.overrideWithValue(_FakeCircleRepo(feed)),
    ],
  );
  addTearDown(container.dispose);
  await container.read(circleFeedControllerProvider.future);
  return container;
}

void main() {
  group('F-05 CirclePost.copyWithReaction（欄位保留）', () {
    test('只更新讚/倒讚/心情，其餘欄位原封不動', () {
      final CirclePost base = _post(7, likeNum: 10);
      final CirclePost next = base.copyWithReaction(
        likeNum: 88,
        badNum: 3,
        myReaction: Reaction.like,
      );
      expect(next.likeNum, 88);
      expect(next.badNum, 3);
      expect(next.myReaction, Reaction.like);
      // 其餘欄位全保留。
      expect(next.topicId, base.topicId);
      expect(next.title, base.title);
      expect(next.content, base.content);
      expect(next.authorName, base.authorName);
      expect(next.authorLevel, base.authorLevel);
      expect(next.avatarUrl, base.avatarUrl);
      expect(next.sectionName, base.sectionName);
      expect(next.replies, base.replies);
      expect(next.views, base.views);
      expect(next.postTime, base.postTime);
      expect(next.imageUrls, base.imageUrls);
      expect(next.articleId, base.articleId);
      expect(next.articleName, base.articleName);
    });
  });

  group('F-05 CircleFeedController.applyReaction（單筆 upsert，不重抓）', () {
    const CircleFeed feedMeta = CircleFeed(
      posts: <CirclePost>[],
      pageNum: 1,
      pages: 4,
      total: 88,
    );

    test('命中 topicId → 更新該筆，順序/其它筆/分頁狀態不變', () async {
      final CircleFeed seeded = CircleFeed(
        posts: <CirclePost>[
          _post(1, likeNum: 3),
          _post(2, likeNum: 7),
          _post(3, likeNum: 1),
        ],
        pageNum: feedMeta.pageNum,
        pages: feedMeta.pages,
        total: feedMeta.total,
      );
      final ProviderContainer container = await _seed(seeded);
      container
          .read(circleFeedControllerProvider.notifier)
          .applyReaction(
            2,
            const ReactionCounts(
              likeNum: 50,
              badNum: 2,
              myReaction: Reaction.like,
            ),
          );

      final CircleFeedState state = container
          .read(circleFeedControllerProvider)
          .requireValue;
      expect(state.posts.map((CirclePost p) => p.topicId), <int>[1, 2, 3]);
      expect(state.page, 1);
      expect(state.hasMore, isTrue);
      final CirclePost updated = state.posts[1];
      expect(updated.likeNum, 50);
      expect(updated.badNum, 2);
      expect(updated.myReaction, Reaction.like);
      expect(state.posts[0].likeNum, 3);
      expect(state.posts[2].likeNum, 1);
    });

    test('未命中 topicId → 狀態不變（no-op）', () async {
      final CircleFeed seeded = CircleFeed(
        posts: <CirclePost>[_post(1, likeNum: 3)],
        pageNum: feedMeta.pageNum,
        pages: feedMeta.pages,
        total: feedMeta.total,
      );
      final ProviderContainer container = await _seed(seeded);
      final CircleFeedState before = container
          .read(circleFeedControllerProvider)
          .requireValue;
      container
          .read(circleFeedControllerProvider.notifier)
          .applyReaction(999, const ReactionCounts(likeNum: 50));
      final CircleFeedState after = container
          .read(circleFeedControllerProvider)
          .requireValue;
      expect(after.posts.single.likeNum, 3);
      expect(identical(before.posts, after.posts), isTrue);
    });
  });

  group('F-14/F-15 圈子 feed 分頁四態（下拉刷新 / 載入更多重試）', () {
    Future<ProviderContainer> boot(
      Map<int, ApiResult<CircleFeed>> byPage,
    ) async {
      final ProviderContainer c = ProviderContainer(
        overrides: [
          authControllerProvider.overrideWith(_LoggedInAuth.new),
          circleRepositoryProvider.overrideWithValue(_ProgCircleRepo(byPage)),
        ],
      );
      addTearDown(c.dispose);
      c.listen(circleFeedControllerProvider, (_, _) {});
      await c.read(circleFeedControllerProvider.future);
      return c;
    }

    test(
      'F-15：loadMore 失敗 → loadMoreError（非 hasMore=false）；retry 成功清旗標',
      () async {
        final ProviderContainer c = await boot(<int, ApiResult<CircleFeed>>{
          1: ApiSuccess<CircleFeed>(_feedPage(1, 20, hasMore: true)),
          2: const ApiFailure<CircleFeed>(
            AppError(kind: AppErrorKind.network, message: '離線'),
          ),
        });
        await c.read(circleFeedControllerProvider.notifier).loadMore();
        CircleFeedState s = c.read(circleFeedControllerProvider).requireValue;
        expect(s.loadMoreError, isTrue);
        expect(s.hasMore, isTrue);
        expect(s.posts.length, 20);

        // retry：讓 page 2 這次成功。
        final _ProgCircleRepo repo =
            c.read(circleRepositoryProvider) as _ProgCircleRepo;
        repo.byPage[2] = ApiSuccess<CircleFeed>(
          _feedPage(2, 10, hasMore: false),
        );
        await c.read(circleFeedControllerProvider.notifier).retryLoadMore();
        s = c.read(circleFeedControllerProvider).requireValue;
        expect(s.loadMoreError, isFalse);
        expect(s.posts.length, 30);
        expect(s.hasMore, isFalse);
      },
    );

    test('F-14：refresh 保留列表、不進 AsyncLoading', () async {
      final ProviderContainer c = await boot(<int, ApiResult<CircleFeed>>{
        1: ApiSuccess<CircleFeed>(_feedPage(1, 5, hasMore: true)),
      });
      expect(c.read(circleFeedControllerProvider).requireValue.posts.length, 5);

      // 讓刷新回傳新的一頁。
      final _ProgCircleRepo repo =
          c.read(circleRepositoryProvider) as _ProgCircleRepo;
      repo.byPage[1] = ApiSuccess<CircleFeed>(_feedPage(1, 8, hasMore: false));
      final Future<void> r = c
          .read(circleFeedControllerProvider.notifier)
          .refresh();
      // 刷新期間維持 AsyncData（列表不消失）。
      expect(
        c.read(circleFeedControllerProvider),
        isA<AsyncData<CircleFeedState>>(),
      );
      await r;
      expect(c.read(circleFeedControllerProvider).requireValue.posts.length, 8);
    });

    test('F-15：refresh 失敗 → 保留現有列表（不變量#1）', () async {
      final ProviderContainer c = await boot(<int, ApiResult<CircleFeed>>{
        1: ApiSuccess<CircleFeed>(_feedPage(1, 6, hasMore: true)),
      });
      expect(c.read(circleFeedControllerProvider).requireValue.posts.length, 6);

      // 刷新時第 1 頁改為失敗 → 舊列表原封不動。
      final _ProgCircleRepo repo =
          c.read(circleRepositoryProvider) as _ProgCircleRepo;
      repo.byPage[1] = const ApiFailure<CircleFeed>(
        AppError(kind: AppErrorKind.network, message: '離線'),
      );
      await c.read(circleFeedControllerProvider.notifier).refresh();
      final CircleFeedState s = c
          .read(circleFeedControllerProvider)
          .requireValue;
      expect(s.posts.length, 6);
      expect(s.hasMore, isTrue);
    });

    test(
      'HIGH：applyReaction 於 loadMore 進行中不得卡死分頁（守門早退清 loadingMore）',
      () async {
        final _GatedCircleRepo repo = _GatedCircleRepo(
          _feedPage(1, 20, hasMore: true),
          _feedPage(2, 10, hasMore: false),
        );
        final ProviderContainer c = ProviderContainer(
          overrides: [
            authControllerProvider.overrideWith(_LoggedInAuth.new),
            circleRepositoryProvider.overrideWithValue(repo),
          ],
        );
        addTearDown(c.dispose);
        c.listen(circleFeedControllerProvider, (_, _) {});
        await c.read(circleFeedControllerProvider.future);

        // 觸發 loadMore（不 await）→ 進到 await gate、loadingMore=true。
        final Future<void> f = c
            .read(circleFeedControllerProvider.notifier)
            .loadMore();
        await Future<void>.delayed(Duration.zero);
        expect(
          c.read(circleFeedControllerProvider).requireValue.loadingMore,
          isTrue,
        );

        // 載入中對已載貼文做樂觀更新 → 改變 posts 參照。
        final int firstId = c
            .read(circleFeedControllerProvider)
            .requireValue
            .posts
            .first
            .topicId;
        c
            .read(circleFeedControllerProvider.notifier)
            .applyReaction(
              firstId,
              const ReactionCounts(likeNum: 999, myReaction: Reaction.like),
            );

        // 釋放 gate → page2 落地，但守門偵測 posts 參照已變 → 丟棄該頁。
        repo.gate.complete();
        await f;

        final CircleFeedState s = c
            .read(circleFeedControllerProvider)
            .requireValue;
        // 關鍵：loadingMore 必須被清（否則分頁永久卡假 loading）。
        expect(
          s.loadingMore,
          isFalse,
          reason: '守門早退未清 loadingMore → 分頁死掉（此測試守護 HIGH 修正）',
        );
        expect(s.posts.length, 20, reason: 'posts 參照已被樂觀更新換掉 → 丟棄本次分頁');
        expect(s.posts.first.likeNum, 999, reason: '樂觀更新保留');
        expect(s.hasMore, isTrue);

        // 證明分頁未死：再次 loadMore 應成功累積到 30。
        await c.read(circleFeedControllerProvider.notifier).loadMore();
        expect(
          c.read(circleFeedControllerProvider).requireValue.posts.length,
          30,
        );
      },
    );
  });
}
