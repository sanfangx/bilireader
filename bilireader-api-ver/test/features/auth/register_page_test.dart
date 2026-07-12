import 'package:bilireader/core/auth/auth_session_manager.dart';
import 'package:bilireader/core/di/infra_providers.dart';
import 'package:bilireader/core/network/api_result.dart';
import 'package:bilireader/features/auth/data/auth_providers.dart';
import 'package:bilireader/features/auth/domain/auth_repository.dart';
import 'package:bilireader/features/auth/domain/register_captcha.dart';
import 'package:bilireader/features/auth/domain/user_info.dart';
import 'package:bilireader/features/auth/presentation/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../support/fake_stores.dart';

// 1x1 透明 PNG（供驗證碼 Image.memory 解碼，不觸網）。
const String _kPngB64 =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk'
    '+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository(this._session);

  final AuthSessionManager _session;
  int registerCalls = 0;
  String? lastUname;
  String? lastNick;
  String? lastPass;

  @override
  Future<ApiResult<RegisterCaptcha>> loadCaptcha() async =>
      const ApiSuccess<RegisterCaptcha>(
        RegisterCaptcha(captchaId: 'CID', imageBase64: _kPngB64),
      );

  @override
  Future<ApiResult<UserInfo>> register({
    required String uname,
    required String nickname,
    required String pass,
    required String email,
    required String captchaId,
    required String captcha,
  }) async {
    registerCalls++;
    lastUname = uname;
    lastNick = nickname;
    lastPass = pass;
    await _session.persist(token: 'TOK', uid: 902220, groupId: 1);
    return const ApiSuccess<UserInfo>(
      UserInfo(uid: 902220, nickname: 'Oo', groupid: 1),
    );
  }

  @override
  Future<ApiResult<UserInfo>> login({
    required String uname,
    required String pass,
  }) async => throw UnimplementedError();

  @override
  Future<ApiResult<UserInfo>> getUserInfo() async => const ApiSuccess<UserInfo>(
    UserInfo(uid: 902220, nickname: 'Oo', groupid: 1),
  );

  @override
  Future<void> logout() async => _session.clear();
}

void main() {
  late _FakeAuthRepository repo;

  Future<void> pump(WidgetTester tester) async {
    final GoRouter router = GoRouter(
      initialLocation: '/home',
      routes: <RouteBase>[
        GoRoute(
          path: '/home',
          builder: (BuildContext context, GoRouterState state) => Scaffold(
            body: Center(
              child: ElevatedButton(
                key: const Key('go_reg'),
                onPressed: () => context.pushNamed('register'),
                child: const Text('go'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (BuildContext context, GoRouterState state) =>
              const RegisterPage(),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tokenStoreProvider.overrideWithValue(FakeTokenStore()),
          sessionStoreProvider.overrideWithValue(FakeSessionStore()),
          authRepositoryProvider.overrideWith((ref) {
            repo = _FakeAuthRepository(ref.watch(authSessionManagerProvider));
            return repo;
          }),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('go_reg')));
    await tester.pumpAndSettle();
  }

  testWidgets('渲染六欄位 + 驗證碼圖 + 送出鈕', (WidgetTester tester) async {
    await pump(tester);
    for (final String k in <String>[
      'reg_uname',
      'reg_nick',
      'reg_pass',
      'reg_confirm',
      'reg_email',
      'reg_captcha',
    ]) {
      expect(find.byKey(Key(k)), findsOneWidget);
    }
    expect(find.byKey(const Key('reg_captcha_image')), findsOneWidget);
    expect(find.byKey(const Key('reg_submit')), findsOneWidget);
  });

  testWidgets('前端驗證：密碼不一致 → 顯示錯誤、不呼叫 register', (WidgetTester tester) async {
    await pump(tester);
    await tester.enterText(find.byKey(const Key('reg_uname')), 'reader01');
    await tester.enterText(find.byKey(const Key('reg_nick')), '暱稱');
    await tester.enterText(find.byKey(const Key('reg_pass')), 'abc123');
    await tester.enterText(
      find.byKey(const Key('reg_confirm')),
      'abc124',
    ); // 不符
    await tester.enterText(find.byKey(const Key('reg_email')), 'a@b.com');
    await tester.enterText(find.byKey(const Key('reg_captcha')), '7Qk3');
    await tester.tap(find.byKey(const Key('reg_submit')));
    await tester.pump();
    expect(find.byKey(const Key('reg_error')), findsOneWidget);
    expect(repo.registerCalls, 0); // 前端擋下，未打 API
    expect(find.byKey(const Key('reg_submit')), findsOneWidget); // 仍在註冊頁
  });

  testWidgets('全部合法 → register + 自動登入 → 離開註冊頁', (WidgetTester tester) async {
    await pump(tester);
    await tester.enterText(find.byKey(const Key('reg_uname')), 'reader01');
    await tester.enterText(find.byKey(const Key('reg_nick')), '暱稱');
    await tester.enterText(find.byKey(const Key('reg_pass')), 'abc123');
    await tester.enterText(find.byKey(const Key('reg_confirm')), 'abc123');
    await tester.enterText(find.byKey(const Key('reg_email')), 'a@b.com');
    await tester.enterText(find.byKey(const Key('reg_captcha')), '7Qk3');
    await tester.tap(find.byKey(const Key('reg_submit')));
    await tester.pumpAndSettle();
    expect(repo.registerCalls, 1);
    // 成功自動登入 → RegisterPage 觀察認證態自動返回 /home。
    expect(find.byKey(const Key('reg_submit')), findsNothing);
    expect(find.byKey(const Key('go_reg')), findsOneWidget);
  });

  testWidgets('帳號/暱稱 trim 後驗證＋送出（比照原生；密碼不 trim）', (WidgetTester tester) async {
    await pump(tester);
    // 帳號含前後空白：trim 後長度合法（"ab"=2）；未 trim 會誤判並送出多餘空白。
    await tester.enterText(find.byKey(const Key('reg_uname')), '  ab  ');
    await tester.enterText(find.byKey(const Key('reg_nick')), '  暱  ');
    await tester.enterText(find.byKey(const Key('reg_pass')), 'abc123');
    await tester.enterText(find.byKey(const Key('reg_confirm')), 'abc123');
    await tester.enterText(find.byKey(const Key('reg_email')), '  a@b.com ');
    await tester.enterText(find.byKey(const Key('reg_captcha')), ' 7Qk3 ');
    await tester.tap(find.byKey(const Key('reg_submit')));
    await tester.pumpAndSettle();
    expect(repo.registerCalls, 1); // trim 後合法 → 有送出
    expect(repo.lastUname, 'ab'); // 送出值已 trim
    expect(repo.lastNick, '暱');
    expect(repo.lastPass, 'abc123'); // 密碼不 trim
  });
}
