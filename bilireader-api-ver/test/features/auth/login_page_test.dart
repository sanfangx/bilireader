import 'package:bilireader/core/auth/auth_session_manager.dart';
import 'package:bilireader/core/di/infra_providers.dart';
import 'package:bilireader/core/network/api_result.dart';
import 'package:bilireader/features/auth/data/auth_providers.dart';
import 'package:bilireader/features/auth/domain/auth_repository.dart';
import 'package:bilireader/features/auth/domain/register_captcha.dart';
import 'package:bilireader/features/auth/domain/user_info.dart';
import 'package:bilireader/features/auth/presentation/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../support/fake_stores.dart';

/// 假 repository：login 成功即寫入共享 session，讓 authController.refresh 讀到已登入。
class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository(this._session);

  final AuthSessionManager _session;

  @override
  Future<ApiResult<UserInfo>> login({
    required String uname,
    required String pass,
  }) async {
    await _session.persist(token: 'TOK', uid: 902220, groupId: 1);
    return const ApiSuccess<UserInfo>(
      UserInfo(uid: 902220, nickname: 'Oo', groupid: 1),
    );
  }

  @override
  Future<ApiResult<UserInfo>> getUserInfo() async => const ApiSuccess<UserInfo>(
    UserInfo(uid: 902220, nickname: 'Oo', groupid: 1),
  );

  @override
  Future<void> logout() async => _session.clear();

  @override
  Future<ApiResult<RegisterCaptcha>> loadCaptcha() async =>
      throw UnimplementedError();

  @override
  Future<ApiResult<UserInfo>> register({
    required String uname,
    required String nickname,
    required String pass,
    required String email,
    required String captchaId,
    required String captcha,
  }) async => throw UnimplementedError();
}

void main() {
  testWidgets('登入成功後自動離開登入頁（返回上一頁）', (WidgetTester tester) async {
    final GoRouter router = GoRouter(
      initialLocation: '/home',
      routes: <RouteBase>[
        GoRoute(
          path: '/home',
          builder: (BuildContext context, GoRouterState state) => Scaffold(
            body: Center(
              child: ElevatedButton(
                key: const Key('go_login'),
                onPressed: () => context.pushNamed('login'),
                child: const Text('go'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (BuildContext context, GoRouterState state) =>
              const LoginPage(),
        ),
        // LoginPage 的「前往註冊」以名稱導向；提供空 route 讓名稱解析成立。
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        // overrides 型別交由推斷（Riverpod 3 的 Override 為內部密封型別）。
        overrides: [
          tokenStoreProvider.overrideWithValue(FakeTokenStore()),
          sessionStoreProvider.overrideWithValue(FakeSessionStore()),
          authRepositoryProvider.overrideWith(
            (ref) => _FakeAuthRepository(ref.watch(authSessionManagerProvider)),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    // 由 /home push 進入登入頁。
    await tester.tap(find.byKey(const Key('go_login')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('login_submit')), findsOneWidget);

    // 送出登入。成功 → authController 刷新為已登入 → LoginPage 觀察後自動返回。
    await tester.enterText(find.byKey(const Key('login_uname')), 'izpollo0332');
    await tester.enterText(find.byKey(const Key('login_pass')), 'secret');
    await tester.tap(find.byKey(const Key('login_submit')));
    await tester.pumpAndSettle();

    // 登入頁已離開，回到 /home。
    expect(find.byKey(const Key('login_submit')), findsNothing);
    expect(find.byKey(const Key('go_login')), findsOneWidget);
  });
}
