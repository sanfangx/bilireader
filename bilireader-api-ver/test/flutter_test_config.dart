import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// 所有測試執行前載入打包字體，確保 golden 以真實繁體字型渲染
/// （規範 §9.3、§5.0）。此檔名為 flutter_test 慣例，會被自動套用到 test/ 下全部測試。
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await _loadAppFonts();
  await testMain();
}

Future<void> _loadAppFonts() async {
  const Map<String, String> families = <String, String>{
    'NotoSansTC': 'assets/fonts/NotoSansTC-VariableFont_wght.ttf',
    'NotoSerifTC': 'assets/fonts/NotoSerifTC-VariableFont_wght.ttf',
    'SpaceGrotesk': 'assets/fonts/SpaceGrotesk-VariableFont_wght.ttf',
  };
  for (final MapEntry<String, String> entry in families.entries) {
    final File file = File(entry.value);
    if (!file.existsSync()) {
      continue;
    }
    final Uint8List bytes = await file.readAsBytes();
    final FontLoader loader = FontLoader(entry.key)
      ..addFont(Future<ByteData>.value(ByteData.view(bytes.buffer)));
    await loader.load();
  }
}
