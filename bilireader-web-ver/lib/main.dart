import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/auth_gate.dart';
import 'core/di/infra_providers.dart';
import 'core/network/linovelib_api.dart';
import 'core/offline/offline_store.dart';
import 'core/reading/local_store.dart';
import 'core/session/auth_controller.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthController.instance.load(); // 讀回持久化的登入 session
  await LocalStore.instance.load(); // 讀回本機閱讀進度 + 分組 + 書籤
  final SharedPreferences prefs =
      await SharedPreferences.getInstance(); // 閱讀器移植：設定/主題持久化
  await OfflineStore.instance.init(); // 載入已下載清單
  // 若已登入但尚無使用者資訊，背景補抓 /user.php（失敗不影響啟動）。
  if (AuthController.instance.isLoggedIn &&
      AuthController.instance.session?.profile == null) {
    LinovelibApi.instance
        .userProfile()
        .then(AuthController.instance.applyProfile)
        .catchError((_) {});
  }
  // 預載閱讀字型 → 翻頁分頁的 TextPainter 量測才準（否則用 fallback 字型量測會溢出）
  try {
    await GoogleFonts.pendingFonts([
      GoogleFonts.notoSerifTc(),
      GoogleFonts.notoSansTc(),
    ]);
  } catch (_) {}
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const BiliReaderApp(),
    ),
  );
}

class BiliReaderApp extends StatelessWidget {
  const BiliReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '嗶哩輕小說',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const AuthGate(),
    );
  }
}
