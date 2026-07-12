import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../core/app_config.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// 極簡內嵌 WebView 頁（唯讀檢視站方頁面，如書評詳情）。沿用登入 session cookie
/// （`CookieManager` 共享）與同一行動 UA（cf_clearance 綁 UA）。
class SimpleWebViewPage extends StatelessWidget {
  const SimpleWebViewPage({super.key, required this.url, this.title = ''});

  final String url;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        foregroundColor: AppColors.txt,
        elevation: 0,
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.serif(size: 15, color: AppColors.txt),
        ),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(url)),
        initialSettings: InAppWebViewSettings(
          userAgent: AppConfig.userAgent,
          thirdPartyCookiesEnabled: true,
        ),
      ),
    );
  }
}
