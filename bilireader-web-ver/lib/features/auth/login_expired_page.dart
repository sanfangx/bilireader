import 'package:flutter/material.dart';

import '../../core/session/auth_controller.dart';
import '../../widgets/app_background.dart';
import 'auth_status_view.dart';
import 'webview_login_page.dart';

/// 登入逾期 · 重新驗證（cf_clearance / session 過期）。
class LoginExpiredPage extends StatelessWidget {
  const LoginExpiredPage({super.key});

  Future<void> _reauth(BuildContext context) async {
    // 防連點：登入 WebView 已在上層就不重複 push（避免堆兩層）。
    if (!(ModalRoute.of(context)?.isCurrent ?? true)) return;
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const WebViewLoginPage()),
    );
    // 成功後 AuthController → loggedIn，AuthGate 會自動切到首頁。
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: AuthStatusView(
              glyph: '⟳',
              tone: AuthTone.warn,
              title: '登入逾期，請重新驗證',
              description: 'Cloudflare 通行證已過期，\n需重新完成一次網頁驗證，\n才能繼續同步書架與閱讀。',
              primaryLabel: '重新驗證  →',
              onPrimary: () => _reauth(context),
              footer: '稍後再說',
              // 「稍後再說」＝非破壞性延後：進訪客模式瀏覽，**保留** session/cookie 供稍後重驗，
              // 不再誤觸 logout() 摧毀帳號（與文案相反的災難）。
              onFooter: () => AuthController.instance.enterGuestMode(),
            ),
          ),
        ),
      ),
    );
  }
}
