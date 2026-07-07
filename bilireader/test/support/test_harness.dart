import 'package:bilireader/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// 以 App 深色主題包裝待測 widget，供 widget / golden 測試共用。
Widget harness(Widget child, {Alignment alignment = Alignment.center}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: buildDarkTheme(),
    home: Scaffold(
      body: Align(alignment: alignment, child: child),
    ),
  );
}
