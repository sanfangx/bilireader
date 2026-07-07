/// 單一 OpenCC 字典：key → 首個候選 value。記錄最長 key 長度供最長匹配。
///
/// OpenCC 字典檔格式（Apache-2.0，來源 github.com/ByVoid/OpenCC）：每行
/// `key<TAB>candidate1 candidate2 ...`，取第一個候選；`#` 開頭為註解。
class OpenCcDictionary {
  const OpenCcDictionary._(this._map, this.maxKeyLength);

  /// 解析並合併多個字典檔內容為單一 map（後載入者覆蓋先載入者）。
  factory OpenCcDictionary.parse(List<String> contents) {
    final Map<String, String> map = <String, String>{};
    int maxKeyLength = 1;
    for (final String content in contents) {
      for (final String rawLine in content.split('\n')) {
        final String line = rawLine.trimRight();
        if (line.isEmpty || line.startsWith('#')) {
          continue;
        }
        final int tab = line.indexOf('\t');
        if (tab <= 0) {
          continue;
        }
        final String key = line.substring(0, tab);
        final String valuePart = line.substring(tab + 1);
        final int space = valuePart.indexOf(' ');
        final String value = space < 0
            ? valuePart
            : valuePart.substring(0, space);
        if (key.isEmpty || value.isEmpty) {
          continue;
        }
        map[key] = value;
        if (key.length > maxKeyLength) {
          maxKeyLength = key.length;
        }
      }
    }
    return OpenCcDictionary._(map, maxKeyLength);
  }

  final Map<String, String> _map;
  final int maxKeyLength;

  String? lookup(String key) => _map[key];

  int get length => _map.length;
}

/// OpenCC 轉換器：依序套用多個字典 pass（config chain）。每個 pass 對整段文字做
/// 由左而右的**貪婪最長匹配**（標準 OpenCC 演算法），無匹配則原字輸出。
class OpenCcConverter {
  const OpenCcConverter(this._passes);

  final List<OpenCcDictionary> _passes;

  String convert(String input) {
    String text = input;
    for (final OpenCcDictionary pass in _passes) {
      text = _applyPass(text, pass);
    }
    return text;
  }

  static String _applyPass(String text, OpenCcDictionary dict) {
    final StringBuffer buffer = StringBuffer();
    final int n = text.length;
    final int maxLen = dict.maxKeyLength;
    int i = 0;
    while (i < n) {
      final int end = (i + maxLen <= n) ? i + maxLen : n;
      String? matchedValue;
      int matchedLen = 0;
      for (int len = end - i; len >= 1; len--) {
        final String? value = dict.lookup(text.substring(i, i + len));
        if (value != null) {
          matchedValue = value;
          matchedLen = len;
          break;
        }
      }
      if (matchedValue != null) {
        buffer.write(matchedValue);
        i += matchedLen;
      } else {
        buffer.write(text[i]);
        i += 1;
      }
    }
    return buffer.toString();
  }
}
