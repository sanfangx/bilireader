import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'chinese_converter.dart';

part 'text_providers.g.dart';

/// 全域簡繁轉換器（規範 §5.0）。消費端（搜尋 fallback、閱讀器、顯示 server 文字）
/// 使用前先 `await ref.read(chineseConverterProvider).ensureLoaded()`。
@Riverpod(keepAlive: true)
ChineseConverter chineseConverter(Ref ref) => ChineseConverter();
