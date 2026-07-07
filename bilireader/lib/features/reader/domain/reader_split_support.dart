import 'reader_inline_node.dart';
import 'reader_inline_parser.dart';
import 'reader_text_utils.dart' show kSplittableInlineTagNames;

/// 分頁「段中切分」所需的純函式，移植自反編譯（見 `apk/docs/flutter/05-閱讀器渲染管線.md`
/// §6.4、§6.7）：把「可見字 offset」映回原始 HTML offset，以及在切點補齊可分割行內標籤
/// （small/sup）的閉合/重開，避免切壞跨頁的 `<small>`/`<sup>`。
///
/// 全部純 Dart，可完整單元測試。低階掃描 helper 與 [ReaderInlineParser] 同源（刻意各自持有
/// 小型副本以維持模組獨立、不動已驗證的 parser）。

const ReaderInlineParser _parser = ReaderInlineParser();

/// 目前在 [offset] 處仍未閉合的可分割行內標籤（small/sup），依開啟順序。
/// 對應 `activeSplittableInlineTagsAt`。
List<SplittableTag> activeSplittableInlineTagsAt(String s, int offset) {
  final int end = offset.clamp(0, s.length);
  final List<SplittableTag> stack = <SplittableTag>[];
  int i = 0;
  while (i < end) {
    final int tagEnd = s[i] == '<' ? _findTagEnd(s, i) : -1;
    if (s[i] != '<' || tagEnd < 0 || tagEnd >= end) {
      i++;
      continue;
    }
    final String tag = s.substring(i, tagEnd + 1);
    final String? name = _splittableInlineTagName(tag);
    if (name != null) {
      if (_isClosingTag(tag)) {
        for (int k = stack.length - 1; k >= 0; k--) {
          if (stack[k].name == name) {
            stack.removeAt(k);
            break;
          }
        }
      } else if (!_isSelfClosingTag(tag)) {
        stack.add(SplittableTag(name, tag));
      }
    }
    i = tagEnd + 1;
  }
  return stack;
}

/// 在 [offset] 切分時，回傳 (前半要補的閉合標籤串, 後半要補的開啟標籤串)。
/// 對應 `readerInlineTagBalanceForSplit`：閉合以「反序」（先閉最內層），開啟以原始開標籤原序。
(String close, String open) readerInlineTagBalanceForSplit(
  String source,
  int offset,
) {
  final List<SplittableTag> active = activeSplittableInlineTagsAt(
    source,
    offset,
  );
  final String close = active.reversed
      .map((SplittableTag t) => '</${t.name}>')
      .join();
  final String open = active.map((SplittableTag t) => t.openingTag).join();
  return (close, open);
}

/// 把「可見字 offset」[target] 換算回 [original]（含標籤）中的 offset。
/// 對應 `mapReaderVisibleOffsetToOriginalText`（§6.7）：ruby 以 base 可見長度計、sup/small 遞迴、
/// span/font/heimu 以內容可見長度計、`<br>` 計 1、HTML 實體計 1。
int mapReaderVisibleOffsetToOriginalText(String original, int target) {
  if (target <= 0) return 0;
  int i = 0;
  int visible = 0;
  while (i < original.length) {
    final int tagEnd = original[i] == '<' ? _findTagEnd(original, i) : -1;
    if (original[i] != '<' || tagEnd < 0) {
      final int entEnd = _htmlEntityEnd(original, i);
      i = entEnd > i ? entEnd : i + 1;
      visible++;
      if (visible >= target) return i;
      continue;
    }
    final int after = tagEnd + 1;
    final String tag = original.substring(i, after);

    if (_isTag(tag, 'ruby')) {
      final int close = _findClosingTag(original, 'ruby', after);
      if (close >= 0) {
        final int end = close + 7;
        visible += _visibleLen(_extractRubyBase(original, after, close));
        if (visible >= target) return end;
        i = end;
      } else {
        i = after;
      }
    } else if (_isTag(tag, 'sup') || _isTag(tag, 'small')) {
      final String name = _isTag(tag, 'sup') ? 'sup' : 'small';
      final int close = _findClosingTag(original, name, after);
      if (close >= 0) {
        final int end = close + name.length + 3; // '</name>'
        final String inner = original.substring(after, close);
        final int total = visible + _visibleLen(inner);
        if (target < total) {
          return mapReaderVisibleOffsetToOriginalText(inner, target - visible) +
              after;
        }
        if (target == total) return end;
        visible = total;
        i = end;
      } else {
        i = after;
      }
    } else if (_isTag(tag, 'span') ||
        _isTag(tag, 'font') ||
        _isTag(tag, 'heimu')) {
      final String name = _isTag(tag, 'span')
          ? 'span'
          : (_isTag(tag, 'font') ? 'font' : 'heimu');
      final int close = _findClosingTag(original, name, after);
      if (close >= 0) {
        final int end = close + name.length + 3;
        visible += _visibleLen(original.substring(after, close));
        if (visible >= target) return end;
        i = end;
      } else {
        i = after;
      }
    } else if (_isTag(tag, 'br')) {
      visible++;
      if (visible >= target) return after;
      i = after;
    } else {
      i = after;
    }
  }
  return original.length;
}

/// 可分割行內標籤（small/sup）+ 其原始開啟標籤字串。對應 `ReaderInlineTag`。
class SplittableTag {
  const SplittableTag(this.name, this.openingTag);

  final String name;
  final String openingTag;

  @override
  bool operator ==(Object other) =>
      other is SplittableTag &&
      other.name == name &&
      other.openingTag == openingTag;

  @override
  int get hashCode => Object.hash(name, openingTag);
}

int _visibleLen(String html) => visibleText(_parser.parse(html)).length;

// ---- 低階掃描 helper（與 ReaderInlineParser 同源）----

int _findTagEnd(String s, int i) => s.indexOf('>', i + 1);

int _findClosingTag(String s, String name, int from) =>
    _indexOfCI(s, '</$name>', from);

/// HTML 實體結尾（`htmlEntityEnd`）：`&…;` 且 ≤12 字並可解碼 → 回結尾+1，否則 -1。
int _htmlEntityEnd(String s, int i) {
  if (s[i] != '&') return -1;
  final int semi = s.indexOf(';', i + 1);
  if (semi < 0 || semi - i > 12) return -1;
  return _canDecodeEntity(s.substring(i + 1, semi)) ? semi + 1 : -1;
}

bool _canDecodeEntity(String name) {
  switch (name.toLowerCase()) {
    case 'gt':
    case 'lt':
    case 'amp':
    case 'apos':
    case 'nbsp':
    case 'quot':
      return true;
  }
  try {
    if (name.toLowerCase().startsWith('#x')) {
      int.parse(name.substring(2), radix: 16);
      return true;
    }
    if (name.startsWith('#')) {
      int.parse(name.substring(1));
      return true;
    }
  } on Object {
    return false;
  }
  return false;
}

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

bool _isClosingTag(String tag) {
  String s = tag.trim();
  if (s.startsWith('<')) s = s.substring(1);
  return s.trimLeft().startsWith('/');
}

bool _isSelfClosingTag(String tag) {
  String s = tag.trim();
  if (s.endsWith('>')) s = s.substring(0, s.length - 1);
  return s.trimRight().endsWith('/');
}

String? _splittableInlineTagName(String tag) {
  String s = tag.trim();
  if (s.startsWith('<')) s = s.substring(1);
  if (s.endsWith('>')) s = s.substring(0, s.length - 1);
  s = s.trim().replaceFirst(RegExp(r'^/+'), '').trimLeft();
  final String lower = s.toLowerCase();
  for (final String name in kSplittableInlineTagNames) {
    if (lower.startsWith(name)) {
      if (s.length == name.length) return name;
      final String next = s[name.length];
      if (next.trim().isEmpty || next == '/') return name;
    }
  }
  return null;
}

String _extractRubyBase(String s, int start, int end) {
  final int rt = _indexOfCI(s, '<rt>', start);
  if (rt < start || rt >= end) return s.substring(start, end);
  return s.substring(start, rt);
}

int _indexOfCI(String s, String lowerNeedle, int from) {
  final int n = lowerNeedle.length;
  for (int i = from; i + n <= s.length; i++) {
    bool ok = true;
    for (int j = 0; j < n; j++) {
      int ch = s.codeUnitAt(i + j);
      if (ch >= 0x41 && ch <= 0x5A) ch += 0x20;
      if (ch != lowerNeedle.codeUnitAt(j)) {
        ok = false;
        break;
      }
    }
    if (ok) return i;
  }
  return -1;
}
