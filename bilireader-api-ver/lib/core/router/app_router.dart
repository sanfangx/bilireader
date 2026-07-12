import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/register_page.dart';
import '../../features/author/presentation/author_chapters_page.dart';
import '../../features/author/presentation/author_zone_page.dart';
import '../../features/author/presentation/chapter_editor_page.dart';
import '../../features/bookshelf/presentation/bookshelf_page.dart';
import '../../features/circle/presentation/circle_page.dart';
import '../../features/circle/presentation/circle_post_detail_page.dart';
import '../../features/circle/presentation/circle_publish_page.dart';
import '../../features/discover/domain/ranking_options.dart';
import '../../features/discover/presentation/catalog_page.dart';
import '../../features/discover/presentation/discover_page.dart';
import '../../features/discover/presentation/novel_detail_page.dart';
import '../../features/discover/presentation/ranking_page.dart';
import '../../features/discover/presentation/search_page.dart';
import '../../features/discover/presentation/tag_filter_page.dart';
import '../../features/message/presentation/chat_page.dart';
import '../../features/message/presentation/message_list_page.dart';
import '../../features/notification/presentation/notification_center_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/reader/presentation/reader_page.dart';
import '../../features/review/presentation/review_detail_page.dart';
import '../../features/review/presentation/review_list_page.dart';
import '../../features/system/presentation/changelog_page.dart';
import '../../features/system/presentation/feedback_page.dart';
import '../../features/system/presentation/settings_page.dart';
import 'app_routes.dart';
import 'auth_controller.dart';
import 'main_shell.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// 全域 GoRouter（規範 §2.2、§6.2）。底部分頁使用可保留狀態的
/// [StatefulShellRoute.indexedStack]；詳情／閱讀器／搜尋等為 shell 外全屏 route。
/// `refreshListenable` 綁定認證狀態，Phase 2 登入／登出後路由守衛會重新評估。
@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final ValueNotifier<AuthSnapshot> authListenable =
      ValueNotifier<AuthSnapshot>(ref.read(authControllerProvider));
  ref.onDispose(authListenable.dispose);
  ref.listen<AuthSnapshot>(authControllerProvider, (_, AuthSnapshot next) {
    authListenable.value = next;
  });

  final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.store,
    refreshListenable: authListenable,
    redirect: (BuildContext context, GoRouterState state) {
      // TODO(auth, P1): 依 apk/docs/flutter/09 實作登入守衛——login-required 頁
      //   改為頁面內登入引導；/author* 需 groupId ∈ {1,5,6}；401/666 導回 /login。
      //   登入成功後離開登入頁由 LoginPage 自身觀察認證狀態處理（見 login_page.dart），
      //   不在此守衛做（go_router 頂層 redirect 不會對 imperative push 的頁面生效）。
      return null;
    },
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder:
            (
              BuildContext context,
              GoRouterState state,
              StatefulNavigationShell navigationShell,
            ) => MainShell(navigationShell: navigationShell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.store,
                name: AppRoutes.storeName,
                builder: (BuildContext context, GoRouterState state) =>
                    const DiscoverPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.shelf,
                name: AppRoutes.shelfName,
                builder: (BuildContext context, GoRouterState state) =>
                    const BookshelfPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.quanzi,
                name: AppRoutes.quanziName,
                builder: (BuildContext context, GoRouterState state) =>
                    const CirclePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.user,
                name: AppRoutes.userName,
                builder: (BuildContext context, GoRouterState state) =>
                    const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
      // shell 外全屏 route（Phase 1 佔位；實作於各 feature 階段）。
      GoRoute(
        path: AppRoutes.novelDetail,
        name: AppRoutes.novelDetailName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) => NovelDetailPage(
          articleId: int.tryParse(state.pathParameters['articleId'] ?? '') ?? 0,
        ),
      ),
      GoRoute(
        path: AppRoutes.catalog,
        name: AppRoutes.catalogName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) => CatalogPage(
          articleId: int.tryParse(state.pathParameters['articleId'] ?? '') ?? 0,
          currentChapterId:
              int.tryParse(state.uri.queryParameters['chapterId'] ?? '') ?? 0,
        ),
      ),
      GoRoute(
        path: AppRoutes.reader,
        name: AppRoutes.readerName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) => ReaderPage(
          articleId: int.tryParse(state.pathParameters['articleId'] ?? '') ?? 0,
          initialChapterId:
              int.tryParse(state.uri.queryParameters['chapterId'] ?? '') ?? 0,
          poster: state.uri.queryParameters['poster'] ?? '',
        ),
      ),
      GoRoute(
        path: AppRoutes.search,
        name: AppRoutes.searchName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) =>
            const SearchPage(),
      ),
      GoRoute(
        path: AppRoutes.ranking,
        name: AppRoutes.rankingName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) => RankingPage(
          initialType: _rankingTypeFrom(state.uri.queryParameters['type']),
        ),
      ),
      GoRoute(
        path: AppRoutes.tag,
        name: AppRoutes.tagName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) =>
            TagFilterPage(tag: state.uri.queryParameters['tag'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.loginName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) =>
            const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: AppRoutes.registerName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) =>
            const RegisterPage(),
      ),
      // `/circle/publish` 必須排在 `/circle/:topicId` 之前，否則 publish 會被當成 topicId。
      GoRoute(
        path: AppRoutes.circlePublish,
        name: AppRoutes.circlePublishName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) =>
            const CirclePublishPage(),
      ),
      GoRoute(
        path: AppRoutes.circlePost,
        name: AppRoutes.circlePostName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) =>
            CirclePostDetailPage(
              topicId: int.tryParse(state.pathParameters['topicId'] ?? '') ?? 0,
            ),
      ),
      GoRoute(
        path: AppRoutes.bookReviewList,
        name: AppRoutes.bookReviewListName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) =>
            BookReviewListPage(
              articleId:
                  int.tryParse(state.pathParameters['articleId'] ?? '') ?? 0,
            ),
      ),
      GoRoute(
        path: AppRoutes.bookReview,
        name: AppRoutes.bookReviewName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) =>
            BookReviewDetailPage(
              topicId: int.tryParse(state.pathParameters['topicId'] ?? '') ?? 0,
              // 來源列表的 articleId（供返回列表計數同步，UX F-07）。
              articleId: int.tryParse(
                state.uri.queryParameters['articleId'] ?? '',
              ),
            ),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        name: AppRoutes.notificationsName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) =>
            const NotificationCenterPage(),
      ),
      GoRoute(
        path: AppRoutes.messages,
        name: AppRoutes.messagesName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) =>
            const MessageListPage(),
      ),
      GoRoute(
        path: AppRoutes.chat,
        name: AppRoutes.chatName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) => ChatPage(
          peerId: int.tryParse(state.pathParameters['peerId'] ?? '') ?? 0,
          peerName: state.uri.queryParameters['name'] ?? '',
        ),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: AppRoutes.settingsName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) =>
            const SettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.feedback,
        name: AppRoutes.feedbackName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) =>
            const FeedbackPage(),
      ),
      GoRoute(
        path: AppRoutes.changelog,
        name: AppRoutes.changelogName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) =>
            const ChangelogPage(),
      ),
      GoRoute(
        path: AppRoutes.authorZone,
        name: AppRoutes.authorZoneName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) =>
            const AuthorZonePage(),
      ),
      GoRoute(
        path: AppRoutes.authorChapters,
        name: AppRoutes.authorChaptersName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) =>
            AuthorChaptersPage(
              articleId:
                  int.tryParse(state.pathParameters['articleId'] ?? '') ?? 0,
              title: state.uri.queryParameters['name'],
            ),
      ),
      GoRoute(
        path: AppRoutes.chapterEditor,
        name: AppRoutes.chapterEditorName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          final int? chapterId = int.tryParse(
            state.uri.queryParameters['chapterId'] ?? '',
          );
          return ChapterEditorPage(
            articleId:
                int.tryParse(state.pathParameters['articleId'] ?? '') ?? 0,
            chapterId: chapterId,
            volumeId:
                int.tryParse(state.uri.queryParameters['volumeId'] ?? '') ?? 0,
            initialName: state.uri.queryParameters['name'],
          );
        },
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
}

/// 由路由 query 的 `type` 字串解析榜單型別；無效值回預設（點擊榜）。
RankingType _rankingTypeFrom(String? raw) {
  final int? value = int.tryParse(raw ?? '');
  for (final RankingType t in RankingType.values) {
    if (t.value == value) {
      return t;
    }
  }
  return RankingType.defaultValue;
}
