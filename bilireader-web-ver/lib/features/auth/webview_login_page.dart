import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../core/app_config.dart';
import '../../core/network/linovelib_api.dart';
import '../../core/session/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_background.dart';
import 'auth_status_view.dart';

/// ② WebView 登入。
///
/// 載入官網 login.php，由使用者完成 Cloudflare 驗證與登入；
/// 偵測導向離開 login.php 且取得 jieqiUserInfo → 收割 cookie（含 httpOnly 的 cf_clearance）
/// → 存入 AuthController → 補抓 /user.php 使用者資訊 → 顯示 ③ 登入成功 → 返回。
class WebViewLoginPage extends StatefulWidget {
  const WebViewLoginPage({super.key});

  @override
  State<WebViewLoginPage> createState() => _WebViewLoginPageState();
}

class _WebViewLoginPageState extends State<WebViewLoginPage> {
  final CookieManager _cookieManager = CookieManager.instance();
  String _url = AppConfig.loginUrl;
  double _progress = 0;
  bool _harvested = false;
  bool _success = false;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return _WebUnsupported();

    return PopScope(
      canPop: !_success,
      child: Scaffold(
        body: AppBackground(
          child: SafeArea(
            child: _success
                ? Center(
                    child: AuthStatusView.success(
                      name: AuthController.instance.session?.displayName ?? '書友',
                    ),
                  )
                : Column(
                    children: [
                      _toolbar(),
                      SizedBox(
                        height: 2,
                        child: _progress >= 1.0
                            ? const SizedBox.shrink()
                            : LinearProgressIndicator(
                                value: _progress == 0 ? null : _progress,
                                minHeight: 2,
                                backgroundColor: AppColors.surf,
                                color: AppColors.acc,
                              ),
                      ),
                      Expanded(
                        child: InAppWebView(
                          initialUrlRequest:
                              URLRequest(url: WebUri(AppConfig.loginUrl)),
                          initialSettings: InAppWebViewSettings(
                            userAgent: AppConfig.userAgent,
                            javaScriptEnabled: true,
                            thirdPartyCookiesEnabled: true,
                            transparentBackground: true,
                            useShouldOverrideUrlLoading: false,
                          ),
                          onProgressChanged: (c, p) =>
                              setState(() => _progress = p / 100),
                          onLoadStop: (c, uri) async {
                            if (mounted) {
                              setState(() => _url = uri?.toString() ?? _url);
                            }
                            await _maybeHarvest(uri);
                          },
                          onUpdateVisitedHistory: (c, uri, _) async {
                            if (mounted) {
                              setState(() => _url = uri?.toString() ?? _url);
                            }
                            await _maybeHarvest(uri);
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  bool _isLoggedInUrl(WebUri? uri) {
    final u = uri?.toString() ?? '';
    if (u.isEmpty) return false;
    return u.startsWith(AppConfig.origin) &&
        !u.contains('/login.php') &&
        !u.contains('/register.php');
  }

  Future<void> _maybeHarvest(WebUri? uri) async {
    if (_harvested || !_isLoggedInUrl(uri)) return;

    final cookies =
        await _cookieManager.getCookies(url: WebUri(AppConfig.origin));
    final map = <String, String>{};
    for (final c in cookies) {
      map[c.name] = c.value.toString();
    }
    // 必須真的拿到登入 cookie 才算成功（避免把過場頁誤判）
    if (map[AppConfig.loginMarkerCookie]?.isNotEmpty ?? false) {
      _harvested = true;
      map.putIfAbsent('night', () => '0');
      await AuthController.instance.saveSession(map);
      // 收割成功後補抓使用者中心資訊（暱稱/頭像/等級），best-effort、不阻斷登入成功。
      try {
        final profile = await LinovelibApi.instance
            .userProfile()
            .timeout(const Duration(seconds: 6));
        await AuthController.instance.applyProfile(profile);
      } catch (_) {}
      if (!mounted) return;
      setState(() => _success = true);
      await Future<void>.delayed(const Duration(milliseconds: 1300));
      if (!mounted) return;
      Navigator.of(context).pop(true);
    }
  }

  Widget _toolbar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 8, 14, 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surf,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Text('✕', style: AppText.sans(size: 16, color: AppColors.mut)),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.lock_outline, size: 13, color: Color(0xFF3FBF86)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              _shortUrl(_url),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.mono(size: 11, color: AppColors.mut),
            ),
          ),
        ],
      ),
    );
  }

  String _shortUrl(String u) =>
      u.replaceFirst('https://', '').replaceFirst(RegExp(r'\?.*$'), '');
}

/// flutter_inappwebview 不支援 web；行動裝置才有 WebView 登入。
class _WebUnsupported extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('WebView 登入僅支援行動裝置',
                      style: AppText.serif(size: 18, color: AppColors.acc)),
                  const SizedBox(height: 14),
                  Text(
                    '請在 iOS / Android 上執行以完成\nCloudflare 驗證與官網登入。',
                    textAlign: TextAlign.center,
                    style:
                        AppText.sans(size: 12.5, color: AppColors.mut, height: 1.8),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
