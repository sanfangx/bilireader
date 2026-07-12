import 'package:flutter/material.dart';

import '../core/session/auth_controller.dart';
import '../features/auth/login_expired_page.dart';
import '../features/auth/login_landing_page.dart';
import 'app_shell.dart';
import '../theme/app_colors.dart';
import '../widgets/app_background.dart';

/// 根層守門：依登入狀態切換畫面。
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AuthController.instance,
      builder: (context, _) {
        switch (AuthController.instance.status) {
          case AuthStatus.unknown:
            return const _Splash();
          case AuthStatus.loggedOut:
            // 訪客模式：未登入仍進主殼瀏覽（帳號功能各自降級）。
            return AuthController.instance.guestMode
                ? const AppShell()
                : const LoginLandingPage();
          case AuthStatus.expired:
            // 逾期後點「稍後再說」（enterGuestMode）→ 以訪客模式續瀏覽，保留舊 session
            // 不強制重驗；未選擇則仍顯示逾期頁。
            return AuthController.instance.guestMode
                ? const AppShell()
                : const LoginExpiredPage();
          case AuthStatus.loggedIn:
            return const AppShell();
        }
      },
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AppBackground(
        child: Center(
          child: SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.acc),
          ),
        ),
      ),
    );
  }
}
