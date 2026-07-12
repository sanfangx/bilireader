import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bilireader_app/features/auth/login_landing_page.dart';
import 'package:bilireader_app/theme/app_theme.dart';

void main() {
  testWidgets('登入落地頁顯示品牌、Cloudflare 說明與前往登入按鈕',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.dark(), home: const LoginLandingPage()),
    );
    expect(find.text('嗶哩'), findsOneWidget);
    expect(find.text('前往登入頁  →'), findsOneWidget);
    expect(find.text('先以訪客身分瀏覽'), findsOneWidget);
    expect(find.byType(LoginLandingPage), findsOneWidget);
  });
}
