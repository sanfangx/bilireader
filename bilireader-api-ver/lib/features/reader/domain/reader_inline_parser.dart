import 'reader_inline_node.dart';

/// 行內富文本解析器（遞迴下降），移植自反編譯 `ReaderRichTextFormatterKt.appendFormattedText`
/// （見 `apk/docs/flutter/05-閱讀器渲染管線.md` §5）。把一段（已 OpenCC + 已切段）HTML
/// 解析成 [InlineNode] 串，供 ⑨e 渲染成 `TextSpan`/`WidgetSpan`/`CustomPaint`。
///
/// 樣式採「向下傳遞、就近生效」：外層 span/sup/small 的樣式沿遞迴傳入，內層可覆寫顏色/傍点
/// （巢狀 color/emphasis 以最內層為準——與 Android 疊 span 的罕見巢狀情形略有取捨，已註記）。
class ReaderInlineParser {
  const ReaderInlineParser();

  /// 全形/半形引號集合（`parseColorFromTag`/`hasClass` 容忍中文引號）。
  static final RegExp _colorStyleRe = RegExp(
    r'color\s*:\s*([#A-Za-z0-9]+)',
    caseSensitive: false,
  );
  static final RegExp _colorAttrRe = RegExp(
    'color\\s*=\\s*["\'“”‘’]?([^\\s"\'“”‘’>]+)',
    caseSensitive: false,
  );
  static final RegExp _classQuotedRe = RegExp(
    'class\\s*=\\s*["\'“”‘’]([^"\'“”‘’>]*)["\'“”‘’]',
    caseSensitive: false,
  );
  static final RegExp _classBareRe = RegExp(
    r'class\s*=\s*([^\s>]+)',
    caseSensitive: false,
  );
  static final RegExp _wsRe = RegExp(r'\s+');

  List<InlineNode> parse(String html) => _parse(html);

  List<InlineNode> _parse(
    String s, {
    int? color,
    bool superscript = false,
    int smallLevel = 0,
    ReaderEmphasis? emphasis,
  }) {
    final List<InlineNode> out = <InlineNode>[];
    final StringBuffer buf = StringBuffer();

    void flush() {
      if (buf.isNotEmpty) {
        out.add(
          TextRun(
            buf.toString(),
            color: color,
            superscript: superscript,
            smallLevel: smallLevel,
            emphasis: emphasis,
          ),
        );
        buf.clear();
      }
    }

    int i = 0;
    while (i < s.length) {
      final String c = s[i];
      final int tagEnd = c == '<' ? _findTagEnd(s, i) : -1;
      if (c != '<' || tagEnd < 0) {
        final (String ch, int next) = _decodeCharAt(s, i);
        buf.write(ch);
        i = next;
        continue;
      }

      final String tag = s.substring(i, tagEnd + 1);
      final int after = tagEnd + 1;

      if (_isTag(tag, 'ruby')) {
        final int close = _findClosingTag(s, 'ruby', after);
        if (close < 0) {
          i = after;
          continue;
        }
        final List<InlineNode> baseNodes = _parse(
          _extractRubyBase(s, after, close),
          color: color,
          superscript: superscript,
          smallLevel: smallLevel,
          emphasis: emphasis,
        );
        final String baseVisible = visibleText(baseNodes);
        final String rt = visibleText(
          _parse(
            _extractRubyText(s, after, close),
            color: color,
            superscript: superscript,
            smallLevel: smallLevel,
            emphasis: emphasis,
          ),
        );
        flush();
        // rt 非空白且 base 有內容 → ruby；否則 base 以原樣式呈現（無 ruby span）。
        if (rt.trim().isNotEmpty && baseVisible.isNotEmpty) {
          out.add(RubyRun(baseVisible, rt));
        } else {
          out.addAll(baseNodes);
        }
        i = close + 7; // '</ruby>'
      } else if (_isTag(tag, 'span') || _isTag(tag, 'font')) {
        final String name = _isTag(tag, 'span') ? 'span' : 'font';
        final int close = _findClosingTag(s, name, after);
        if (close < 0) {
          i = after;
          continue;
        }
        flush();
        out.addAll(
          _parse(
            s.substring(after, close),
            color: _parseColor(tag) ?? color,
            superscript: superscript,
            smallLevel: smallLevel,
            emphasis: _parseEmphasis(tag) ?? emphasis,
          ),
        );
        i = close + name.length + 3; // '</name>'
      } else if (_isTag(tag, 'heimu')) {
        final int close = _findClosingTag(s, 'heimu', after);
        if (close < 0) {
          i = after;
          continue;
        }
        final List<InlineNode> children = _parse(
          s.substring(after, close),
          color: color,
          superscript: superscript,
          smallLevel: smallLevel,
          emphasis: emphasis,
        );
        flush();
        if (children.isNotEmpty) out.add(HeimuRun(children));
        i = close + 8; // '</heimu>'
      } else if (_isTag(tag, 'br')) {
        flush();
        out.add(const LineBreakRun());
        i = after;
      } else if (_isTag(tag, 'rp')) {
        final int close = _findClosingTag(s, 'rp', after);
        i = close >= 0 ? close + 5 : after; // 丟棄 rp fallback 內容（'</rp>'）
      } else if (_isTag(tag, 'sup')) {
        final int close = _findClosingTag(s, 'sup', after);
        if (close < 0) {
          i = after;
          continue;
        }
        flush();
        out.addAll(
          _parse(
            s.substring(after, close),
            color: color,
            superscript: true,
            smallLevel: smallLevel,
            emphasis: emphasis,
          ),
        );
        i = close + 6; // '</sup>'
      } else if (_isTag(tag, 'small')) {
        final int close = _findClosingTag(s, 'small', after);
        if (close < 0) {
          i = after;
          continue;
        }
        flush();
        out.addAll(
          _parse(
            s.substring(after, close),
            color: color,
            superscript: superscript,
            smallLevel: smallLevel + 1,
            emphasis: emphasis,
          ),
        );
        i = close + 8; // '</small>'
      } else {
        i = after; // 未知標籤：跳過標籤本身，保留後續內容
      }
    }
    flush();
    return out;
  }

  // ---- 標籤 / 位置 ----

  int _findTagEnd(String s, int i) => s.indexOf('>', i + 1);

  int _findClosingTag(String s, String name, int from) =>
      _indexOfCI(s, '</$name>', from);

  bool _isTag(String tag, String name) {
    int start = 0;
    while (start < tag.length && '</ \t\n\r'.contains(tag[start])) {
      start++;
    }
    final String t = tag.substring(start);
    if (!t.toLowerCase().startsWith(name)) return false;
    if (t.length == name.length) return true;
    final String c = t[name.length];
    return c.trim().isEmpty || c == '>' || c == '/';
  }

  String _extractRubyBase(String s, int start, int end) {
    final int rt = _indexOfCI(s, '<rt>', start);
    if (rt < start || rt >= end) return s.substring(start, end);
    return s.substring(start, rt);
  }

  String _extractRubyText(String s, int start, int end) {
    final int rt = _indexOfCI(s, '<rt>', start);
    if (rt < start || rt >= end) return '';
    final int cStart = rt + 4;
    final int cEnd = _indexOfCI(s, '</rt>', cStart);
    if (cStart <= cEnd && cEnd <= end) return s.substring(cStart, cEnd);
    return '';
  }

  /// ASCII 大小寫不敏感 indexOf（保持索引不變，避免 toLowerCase 改變長度）。
  int _indexOfCI(String s, String lowerNeedle, int from) {
    final int n = lowerNeedle.length;
    for (int i = from; i + n <= s.length; i++) {
      bool ok = true;
      for (int j = 0; j < n; j++) {
        int ch = s.codeUnitAt(i + j);
        if (ch >= 0x41 && ch <= 0x5A) ch += 0x20; // A-Z → a-z
        if (ch != lowerNeedle.codeUnitAt(j)) {
          ok = false;
          break;
        }
      }
      if (ok) return i;
    }
    return -1;
  }

  // ---- 字元 / HTML 實體 ----

  (String, int) _decodeCharAt(String s, int i) {
    if (s[i] != '&') return (s[i], i + 1);
    final int semi = s.indexOf(';', i + 1);
    if (semi < 0 || semi - i > 12) return ('&', i + 1);
    final String? decoded = _decodeEntity(s.substring(i + 1, semi));
    if (decoded != null) return (decoded, semi + 1);
    return ('&', i + 1);
  }

  String? _decodeEntity(String name) {
    switch (name.toLowerCase()) {
      case 'gt':
        return '>';
      case 'lt':
        return '<';
      case 'amp':
        return '&';
      case 'apos':
        return "'";
      case 'nbsp':
        return ' '; // 反編譯字面為一般空格（0x20）
      case 'quot':
        return '"';
    }
    return _decodeNumericEntity(name);
  }

  String? _decodeNumericEntity(String name) {
    try {
      final int cp;
      if (name.toLowerCase().startsWith('#x')) {
        cp = int.parse(name.substring(2), radix: 16);
      } else if (name.startsWith('#')) {
        cp = int.parse(name.substring(1));
      } else {
        return null;
      }
      return String.fromCharCode(cp);
    } on Object {
      return null;
    }
  }

  // ---- 顏色（§5.1）----

  int? _parseColor(String tag) {
    String? raw =
        _colorStyleRe.firstMatch(tag)?.group(1) ??
        _colorAttrRe.firstMatch(tag)?.group(1);
    if (raw == null) return null;
    raw = raw.trim();
    while (raw!.endsWith(';')) {
      raw = raw.substring(0, raw.length - 1);
    }
    return _parseColorValue(_normalizeColor(raw));
  }

  String _normalizeColor(String s) {
    if (s.startsWith('#') && s.length == 4) {
      return '#${s[1]}${s[1]}${s[2]}${s[2]}${s[3]}${s[3]}';
    }
    return s;
  }

  int? _parseColorValue(String s) {
    if (s.startsWith('#')) {
      try {
        final String hex = s.substring(1);
        if (hex.length == 6) return 0xFF000000 | int.parse(hex, radix: 16);
        if (hex.length == 8) return int.parse(hex, radix: 16);
        return null;
      } on Object {
        return null;
      }
    }
    return _namedColors[s.toLowerCase()];
  }

  // Android Color.parseColor 支援的具名色（小寫比對）。
  static const Map<String, int> _namedColors = <String, int>{
    'black': 0xFF000000,
    'darkgray': 0xFF444444,
    'gray': 0xFF888888,
    'lightgray': 0xFFCCCCCC,
    'white': 0xFFFFFFFF,
    'red': 0xFFFF0000,
    'green': 0xFF00FF00,
    'blue': 0xFF0000FF,
    'yellow': 0xFFFFFF00,
    'cyan': 0xFF00FFFF,
    'magenta': 0xFFFF00FF,
    'aqua': 0xFF00FFFF,
    'fuchsia': 0xFFFF00FF,
    'darkgrey': 0xFF444444,
    'grey': 0xFF888888,
    'lightgrey': 0xFFCCCCCC,
    'lime': 0xFF00FF00,
    'maroon': 0xFF800000,
    'navy': 0xFF000080,
    'olive': 0xFF808000,
    'purple': 0xFF800080,
    'silver': 0xFFC0C0C0,
    'teal': 0xFF008080,
  };

  // ---- 傍点 class（§5.2）----

  ReaderEmphasis? _parseEmphasis(String tag) {
    if (_hasClass(tag, 'underdot')) return ReaderEmphasis.underDot;
    if (_hasClass(tag, 'oversesame')) return ReaderEmphasis.overSesame;
    if (_hasClass(tag, 'overdot')) return ReaderEmphasis.overDot;
    return null;
  }

  bool _hasClass(String tag, String cls) {
    final String? val =
        _classQuotedRe.firstMatch(tag)?.group(1) ??
        _classBareRe.firstMatch(tag)?.group(1);
    if (val == null) return false;
    return val.trim().split(_wsRe).contains(cls);
  }
}
