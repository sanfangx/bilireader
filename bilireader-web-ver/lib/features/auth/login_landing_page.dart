import 'package:flutter/material.dart';

import '../../core/session/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_background.dart';
import '../../widgets/gold_button.dart';
import 'webview_login_page.dart';

/// ① 前往登入（登入落地頁）
///
/// 對齊設計稿 `ui_design.dc.html` 的 .login 畫面：
/// 品牌標誌 → 嗶哩 → 標語 → Cloudflare 說明卡 → 「前往登入頁」金按鈕 → 訪客瀏覽。
///
/// 因官網登入端點受 Cloudflare JS 挑戰保護，純表單無法送出，
/// 故登入改為「前往內嵌 WebView 於官方網域完成」。
class LoginLandingPage extends StatelessWidget {
  const LoginLandingPage({super.key});

  Future<void> _goLogin(BuildContext context) async {
    // 防連點：若已非當前路由（登入 WebView 已在上層）→ 不再重複 push（避免堆兩層）。
    if (!(ModalRoute.of(context)?.isCurrent ?? true)) return;
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const WebViewLoginPage()),
    );
  }

  void _browseAsGuest(BuildContext context) {
    // 訪客模式：書城/詳情/免費章可瀏覽；帳號功能（書架收藏/我的）各自降級提示登入。
    AuthController.instance.enterGuestMode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          // .login padding: 54px 30px 30px（SafeArea 已處理狀態列，頂部略收）
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 44, 30, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                _Brand(),
                const SizedBox(height: 30),
                _IntroCard(),
                const SizedBox(height: 18),
                GoldButton(
                  label: '前往登入頁  →',
                  onTap: () => _goLogin(context),
                ),
                const SizedBox(height: 18),
                Center(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _browseAsGuest(context),
                    child: Text(
                      '先以訪客身分瀏覽',
                      style: AppText.sans(size: 12.5, color: AppColors.mut),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 品牌區：金色標誌方塊「嗶」+ 嗶哩 + 標語
class _Brand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 68,
          height: 68,
          margin: const EdgeInsets.only(bottom: 22),
          decoration: BoxDecoration(
            color: AppColors.acc,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            '嗶',
            style: AppText.serif(
              size: 34,
              weight: FontWeight.w700,
              color: AppColors.btxt,
            ),
          ),
        ),
        Text(
          '嗶哩',
          style: AppText.serif(
            size: 26,
            weight: FontWeight.w700,
            color: AppColors.txt,
            letterSpacing: 2.0, // .08em
          ),
        ),
        const SizedBox(height: 11),
        Text(
          '夜讀不孤單 · 萬本輕小說隨身讀',
          style: AppText.sans(
            size: 12,
            color: AppColors.mut,
            letterSpacing: 0.5, // .04em
          ),
        ),
      ],
    );
  }
}

/// Cloudflare 說明卡（.li-card）：粗體金字標出 Cloudflare / 內嵌網頁
class _IntroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle body = AppText.sans(size: 12, color: AppColors.rtxt, height: 1.75);
    TextStyle bold = AppText.sans(
      size: 12,
      weight: FontWeight.w700,
      color: AppColors.acc,
      height: 1.75,
    );
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surf,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Text.rich(
        TextSpan(
          style: body,
          children: [
            const TextSpan(text: '嗶哩官網登入受 '),
            TextSpan(text: 'Cloudflare', style: bold),
            const TextSpan(text: ' 人機驗證保護，純表單無法送出。請在'),
            TextSpan(text: '內嵌網頁', style: bold),
            const TextSpan(text: '中完成登入與驗證——App 全程不經手你的帳號密碼。'),
          ],
        ),
      ),
    );
  }
}
