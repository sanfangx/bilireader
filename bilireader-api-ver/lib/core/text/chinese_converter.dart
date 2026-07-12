import 'package:flutter/services.dart' show rootBundle;

import 'opencc_converter.dart';

/// 字典載入函式（可注入，便於測試以檔案系統載入）。
typedef DictLoader = Future<String> Function(String assetKey);

/// 集中封裝的簡繁轉換（規範 §5.0、§5.4）。使用打包的官方 OpenCC 字典
/// （Apache-2.0）以純 Dart 最長匹配轉換：
/// - [toTraditionalTw]：簡→繁（台灣，s2twp）供**顯示**；產品預設繁體 tw。
/// - [toTraditional]：簡→繁（一般，s2t，無台灣詞彙）供**顯示**；閱讀器「簡繁轉換」的 `t` 選項
///   （§5.0：只允許繁體變體，**不得**提供簡體顯示）。
/// - [toSimplified]：繁→簡（t2s）僅供**後端搜尋 fallback 的內部查詢**，不得作為顯示。
///
/// 復刻原生行為：純漢字 early-out（無 CJK 直接原樣回傳）與短字串快取。
class ChineseConverter {
  ChineseConverter({DictLoader? loader})
    : _loader = loader ?? _rootBundleLoader;

  static const String _dir = 'assets/opencc';
  static const int _cacheKeyMaxLen = 64;
  static const int _cacheMax = 1024;

  final DictLoader _loader;
  final RegExp _hanRegex = RegExp(r'[一-鿿]');
  final Map<String, String> _cache = <String, String>{};

  OpenCcConverter? _s2twp;
  OpenCcConverter? _s2t;
  OpenCcConverter? _t2s;

  bool get isLoaded => _s2twp != null;

  static Future<String> _rootBundleLoader(String key) {
    return rootBundle.loadString(key);
  }

  /// 載入並建立轉換鏈（首次使用前呼叫；可於啟動時 warm up）。
  Future<void> ensureLoaded() async {
    if (_s2twp != null) {
      return;
    }
    final String stPhrases = await _loader('$_dir/STPhrases.txt');
    final String stChars = await _loader('$_dir/STCharacters.txt');
    final String twPhrases = await _loader('$_dir/TWPhrases.txt');
    final String twVariants = await _loader('$_dir/TWVariants.txt');
    final String tsPhrases = await _loader('$_dir/TSPhrases.txt');
    final String tsChars = await _loader('$_dir/TSCharacters.txt');

    // s2twp（標準 OpenCC 鏈）：S→T 片語+字元 → 台灣片語 → 台灣字元變體。
    _s2twp = OpenCcConverter(<OpenCcDictionary>[
      OpenCcDictionary.parse(<String>[stPhrases, stChars]),
      OpenCcDictionary.parse(<String>[twPhrases]),
      OpenCcDictionary.parse(<String>[twVariants]),
    ]);
    // s2t：S→T 片語+字元（一般繁體，不套台灣詞彙/變體）。
    _s2t = OpenCcConverter(<OpenCcDictionary>[
      OpenCcDictionary.parse(<String>[stPhrases, stChars]),
    ]);
    // t2s：T→S 片語+字元（對照原生 toSimple）。
    _t2s = OpenCcConverter(<OpenCcDictionary>[
      OpenCcDictionary.parse(<String>[tsPhrases, tsChars]),
    ]);
  }

  /// 簡→繁（台灣）供顯示。呼叫前須 [ensureLoaded]。
  String toTraditionalTw(String text) {
    final OpenCcConverter? conv = _s2twp;
    if (conv == null) {
      throw StateError('ChineseConverter.ensureLoaded() 尚未完成');
    }
    return _convert(text, conv, 'tw');
  }

  /// 簡→繁（一般，不套台灣詞彙）供顯示。閱讀器「簡繁轉換」的 `t` 選項。呼叫前須 [ensureLoaded]。
  String toTraditional(String text) {
    final OpenCcConverter? conv = _s2t;
    if (conv == null) {
      throw StateError('ChineseConverter.ensureLoaded() 尚未完成');
    }
    return _convert(text, conv, 't');
  }

  /// 繁→簡，僅供後端搜尋 fallback 的內部查詢轉換（規範 §5.0）。呼叫前須 [ensureLoaded]。
  String toSimplified(String text) {
    final OpenCcConverter? conv = _t2s;
    if (conv == null) {
      throw StateError('ChineseConverter.ensureLoaded() 尚未完成');
    }
    return _convert(text, conv, 's');
  }

  String _convert(String text, OpenCcConverter conv, String cachePrefix) {
    // 純漢字 early-out：無任何 CJK 字元則不需轉換。
    if (text.isEmpty || !_hanRegex.hasMatch(text)) {
      return text;
    }
    if (text.length > _cacheKeyMaxLen) {
      return conv.convert(text);
    }
    final String key = '$cachePrefix:$text';
    final String? cached = _cache[key];
    if (cached != null) {
      return cached;
    }
    final String result = conv.convert(text);
    if (_cache.length >= _cacheMax) {
      _cache.clear();
    }
    _cache[key] = result;
    return result;
  }
}
