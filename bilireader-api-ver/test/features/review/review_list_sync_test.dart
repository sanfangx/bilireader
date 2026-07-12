import 'package:bilireader/core/network/api_result.dart';
import 'package:bilireader/core/router/auth_controller.dart';
import 'package:bilireader/core/social/reaction.dart';
import 'package:bilireader/features/review/data/review_providers.dart';
import 'package:bilireader/features/review/domain/review_entities.dart';
import 'package:bilireader/features/review/domain/review_options.dart';
import 'package:bilireader/features/review/domain/review_repository.dart';
import 'package:bilireader/features/review/presentation/review_controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 強制登入態，讓 `_requireLogin` 通過，且不觸及 session 儲存（測試不觸網/平台 channel）。
class _LoggedInAuth extends AuthController {
  @override
  AuthSnapshot build() => const AuthSnapshot(isLoggedIn: true, groupId: 2);
}

/// 回傳固定一頁書評的 fake；like 回傳可設定的 ReactionCounts。
class _FakeReviewRepo implements ReviewRepository {
  _FakeReviewRepo(this._page);

  final BookReviewPage _page;

  @override
  Future<ApiResult<BookReviewPage>> list({
    required int articleId,
    BookReviewSort sort = BookReviewSort.defaultValue,
    int page = 1,
  }) async => ApiSuccess<BookReviewPage>(_page);

  @override
  Future<ApiResult<BookReview>> detail(int topicId) async =>
      throw UnimplementedError();

  @override
  Future<ApiResult<BookReview?>> mine(int articleId) async =>
      const ApiSuccess<BookReview?>(null);

  @override
  Future<ApiResult<BookReviewReplyList>> replies({
    required int topicId,
    int page = 1,
  }) async => throw UnimplementedError();

  @override
  Future<ApiResult<int>> add({
    required int articleId,
    required String content,
    bool isSpoiler = false,
  }) async => const ApiSuccess<int>(1);

  @override
  Future<ApiResult<void>> delete(int topicId) async =>
      const ApiSuccess<void>(null);

  @override
  Future<ApiResult<BookReviewReply>> reply({
    required int topicId,
    required String posttext,
    int? replyPid,
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
}

BookReview _review(int topicId, {int likeNum = 0, int replies = 0}) =>
    BookReview(
      topicId: topicId,
      content: '評論 $topicId',
      authorName: '作者$topicId',
      title: '標題$topicId',
      authorLevel: 'Lv5',
      avatarUrl: 'https://x/$topicId.png',
      likeNum: likeNum,
      badNum: 1,
      replies: replies,
      posttime: 1700000000 + topicId,
      isSpoiler: true,
      isGood: true,
    );

Future<ProviderContainer> _seed(BookReviewPage page) async {
  final ProviderContainer container = ProviderContainer(
    overrides: [
      authControllerProvider.overrideWith(_LoggedInAuth.new),
      reviewRepositoryProvider.overrideWithValue(_FakeReviewRepo(page)),
    ],
  );
  addTearDown(container.dispose);
  // 觸發並等待列表首頁載入。
  await container.read(reviewListControllerProvider(1).future);
  return container;
}

void main() {
  group('F-07 BookReview.copyWith（欄位保留）', () {
    test('只更新讚/回覆數，其餘欄位原封不動', () {
      final BookReview base = _review(7, likeNum: 10, replies: 3);
      final BookReview next = base.copyWith(likeNum: 99, replies: 5);
      expect(next.likeNum, 99);
      expect(next.replies, 5);
      // 未指定者不變。
      expect(next.badNum, base.badNum);
      expect(next.myReaction, base.myReaction);
      // 其餘識別/顯示欄位一律保留。
      expect(next.topicId, base.topicId);
      expect(next.content, base.content);
      expect(next.authorName, base.authorName);
      expect(next.title, base.title);
      expect(next.authorLevel, base.authorLevel);
      expect(next.avatarUrl, base.avatarUrl);
      expect(next.posttime, base.posttime);
      expect(next.isSpoiler, base.isSpoiler);
      expect(next.isGood, base.isGood);
      expect(next.isTop, base.isTop);
    });

    test('null 參數 → 對應欄位沿用原值', () {
      final BookReview base = _review(7, likeNum: 10);
      final BookReview next = base.copyWith(myReaction: Reaction.like);
      expect(next.likeNum, 10);
      expect(next.myReaction, Reaction.like);
    });
  });

  group('F-07 ReviewListController.applyStats（單筆 upsert，不重抓）', () {
    const BookReviewPage page = BookReviewPage(
      reviews: <BookReview>[],
      pageNum: 1,
      pages: 3,
      total: 42,
    );

    test('命中 topicId → 更新該筆讚/心情，順序與其它筆不變', () async {
      final BookReviewPage seeded = BookReviewPage(
        reviews: <BookReview>[
          _review(1, likeNum: 5),
          _review(2, likeNum: 8),
          _review(3, likeNum: 2),
        ],
        pageNum: page.pageNum,
        pages: page.pages,
        total: page.total,
      );
      final ProviderContainer container = await _seed(seeded);
      container
          .read(reviewListControllerProvider(1).notifier)
          .applyStats(2, likeNum: 100, badNum: 4, myReaction: Reaction.like);

      final ReviewListState state = container
          .read(reviewListControllerProvider(1))
          .requireValue;
      // 長度、順序、分頁狀態全部保留（不變量#1）。
      expect(state.reviews.map((BookReview r) => r.topicId), <int>[1, 2, 3]);
      expect(state.page, 1);
      expect(state.hasMore, isTrue);
      expect(state.total, 42);
      final BookReview updated = state.reviews[1];
      expect(updated.likeNum, 100);
      expect(updated.badNum, 4);
      expect(updated.myReaction, Reaction.like);
      // 未動到的筆數維持原值。
      expect(state.reviews[0].likeNum, 5);
      expect(state.reviews[2].likeNum, 2);
    });

    test('repliesDelta 累加回覆數', () async {
      final BookReviewPage seeded = BookReviewPage(
        reviews: <BookReview>[_review(9, replies: 4)],
        pageNum: page.pageNum,
        pages: page.pages,
        total: page.total,
      );
      final ProviderContainer container = await _seed(seeded);
      container
          .read(reviewListControllerProvider(1).notifier)
          .applyStats(9, repliesDelta: 1);
      expect(
        container
            .read(reviewListControllerProvider(1))
            .requireValue
            .reviews
            .single
            .replies,
        5,
      );
    });

    test('未命中 topicId → 狀態不變（no-op）', () async {
      final BookReviewPage seeded = BookReviewPage(
        reviews: <BookReview>[_review(1, likeNum: 5)],
        pageNum: page.pageNum,
        pages: page.pages,
        total: page.total,
      );
      final ProviderContainer container = await _seed(seeded);
      final ReviewListState before = container
          .read(reviewListControllerProvider(1))
          .requireValue;
      container
          .read(reviewListControllerProvider(1).notifier)
          .applyStats(999, likeNum: 100);
      final ReviewListState after = container
          .read(reviewListControllerProvider(1))
          .requireValue;
      expect(after.reviews.single.likeNum, 5);
      expect(identical(before.reviews, after.reviews), isTrue);
    });
  });
}
