import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'infra_providers.g.dart';

/// 全域 [SharedPreferences]。SharedPreferences 為非同步初始化，故此 provider 於 `main()` 以
/// `overrideWithValue` 注入（對齊 api-ver）。未 override 直接讀取即拋錯，提示啟動接線遺漏。
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) =>
    throw UnimplementedError('sharedPreferencesProvider 必須於 main() override');
