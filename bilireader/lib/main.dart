import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/di/infra_providers.dart';
import 'core/router/app_router.dart';
import 'core/text/chinese_converter.dart';
import 'core/text/text_providers.dart';
import 'core/theme/app_theme.dart';
import 'features/system/presentation/splash_screen.dart';
import 'features/system/presentation/startup_dialogs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final ChineseConverter chineseConverter = ChineseConverter();
  // F-26：不在 runApp **之前** await 字典（同步 parse ~58K 行會硬阻塞首幀）；改先 runApp
  // 顯示品牌 splash，字典於背景（runApp 後）載入。§5.0 由 splash gate 保障——內容畫面
  // 只在 ensureLoaded() 完成後才進入（首個內容畫面前字典必就緒，UI 可同步轉繁）。
  final Future<void> dictReady = chineseConverter.ensureLoaded();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        chineseConverterProvider.overrideWithValue(chineseConverter),
      ],
      child: BiliReaderApp(dictReady: dictReady),
    ),
  );
}

/// BiliReader 根 App。字典就緒前顯示品牌 splash（F-26 gate），就緒後進入路由 App。
class BiliReaderApp extends StatelessWidget {
  const BiliReaderApp({required this.dictReady, super.key});

  /// OpenCC 字典載入 Future（§5.0：內容畫面前須就緒）。
  final Future<void> dictReady;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = buildDarkTheme();
    return FutureBuilder<void>(
      future: dictReady,
      builder: (BuildContext context, AsyncSnapshot<void> snap) {
        if (snap.connectionState != ConnectionState.done) {
          // 字典載入中 → 品牌 splash。此時不渲染任何需轉繁的內容（§5.0）。
          return MaterialApp(
            title: 'BiliReader',
            debugShowCheckedModeBanner: false,
            theme: theme,
            darkTheme: theme,
            themeMode: ThemeMode.dark,
            home: const SplashScreen(),
          );
        }
        return const _RootRouterApp();
      },
    );
  }
}

/// 字典就緒後的路由 App。規範 §5.0：可見語言繁體中文（zh-TW）；§5.1：唯一深色主題。
class _RootRouterApp extends ConsumerWidget {
  const _RootRouterApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.watch(goRouterProvider);
    final ThemeData theme = buildDarkTheme();
    return MaterialApp.router(
      title: 'BiliReader',
      debugShowCheckedModeBanner: false,
      theme: theme,
      darkTheme: theme,
      themeMode: ThemeMode.dark,
      localizationsDelegates: const <LocalizationsDelegate<Object?>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[Locale('zh', 'TW')],
      locale: const Locale('zh', 'TW'),
      routerConfig: router,
      // 強制更新覆蓋層（規範 §7.0 501）：套在所有路由之上，強更時阻斷全 App。
      builder: (BuildContext context, Widget? child) =>
          ForceUpdateOverlay(child: child ?? const SizedBox.shrink()),
    );
  }
}
