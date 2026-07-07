/// 閱讀器正文的純文字工具，逐一對應反編譯的 `TextUtils` 與
/// `ReaderRichTextFormatterKt`（見 `apk/docs/flutter/05-閱讀器渲染管線.md` §3、§4.2、§6.5、§6.6）。
///
/// 全部為純 Dart（無 Flutter 依賴），可完整單元測試。
library;

/// 行內標籤集合（`TextUtils.INLINE_TAG_NAMES`）。切段時遇到這些標籤內的 `\n` 不切，
/// 保證 `<ruby>…</ruby>` 等不被拆散。
const List<String> kInlineTagNames = <String>[
  'small',
  'sup',
  'ruby',
  'rt',
  'rp',
  'span',
  'font',
  'heimu',
];

/// 分頁時可在段中補閉合/重開的行內標籤（`splittableInlineTagNames`）。
const List<String> kSplittableInlineTagNames = <String>['small', 'sup'];

/// 置中判定符號集（`readerCenterSymbols`，47 個，含 emoji）。順序即原始碼順序。
const List<String> kReaderCenterSymbols = <String>[
  '＊',
  '*',
  '◇',
  '◆',
  '§',
  '〇',
  '●',
  '▽',
  '▼',
  '△',
  '▲',
  '✽',
  '※',
  '❊',
  '†',
  '┼',
  '☐',
  '□',
  '■',
  '★',
  '♠',
  '♥',
  '♡',
  '✿',
  '♧',
  '×',
  '＋',
  '😈',
  '🔥',
  '☆',
  '✘',
  '﹆',
  '﹅',
  'ฅ',
  '🐾',
  '○',
  '♨',
  '☾',
  '◖',
  'δ',
  'γ',
  '♢',
  '·',
  '✝',
  '☂',
  '☀',
  '∴',
];

/// 依 UTF-16 長度由長到短排序（emoji 為代理對長度 2，需優先比對），對應
/// `readerCenterSymbolsByLength`。
final List<String> _centerSymbolsByLength = List<String>.of(
  kReaderCenterSymbols,
)..sort((String a, String b) => b.length.compareTo(a.length));

// img3 → img2/attachment 主機改寫（§4.2 normalizeImageUrl）。
const String _imgBase = 'https://img3.readpai.com';
const String _imgRepl = 'https://img2.readpai.com/attachment';

/// `normalizeImageUrl`（`NovelReadActivity.java:1589-1591`）：trim 後，開頭符合
/// `img3.readpai.com` 才換成 `img2.readpai.com/attachment`（僅取代開頭）。
String normalizeImageUrl(String s) {
  final String t = s.trim();
  return t.startsWith(_imgBase) ? _imgRepl + t.substring(_imgBase.length) : t;
}

/// 依「換行」切段，且避開行內標籤（`TextUtils.splitTextByNewLine`）。
///
/// 逐字掃描：遇 `<…>` 整段吃掉並更新未閉合行內標籤堆疊；只有在堆疊為空時遇 `\n`
/// 才真正切段。回傳的每行**保留行內 HTML**（供 §5 富文本解析）。
List<String> splitTextByNewLine(String text) {
  final String t = text.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
  final List<String> lines = <String>[];
  final StringBuffer sb = StringBuffer();
  final List<String> open = <String>[];
  int i = 0;
  while (i < t.length) {
    final String c = t[i];
    if (c == '<') {
      final int gt = t.indexOf('>', i + 1);
      if (gt >= 0) {
        final String tag = t.substring(i, gt + 1);
        _updateOpenInlineTags(open, tag);
        sb.write(tag);
        i = gt + 1;
        continue;
      }
    }
    if (c == '\n' && open.isEmpty) {
      lines.add(sb.toString()); // normalizeLine 為 identity
      sb.clear();
    } else {
      sb.write(c);
    }
    i++;
  }
  lines.add(sb.toString());
  return lines;
}

/// 置中行判定（`isReaderCenterLine`，§6.5）。
///
/// trim 後：空字串→false；**全為數字**（半形 0-9 或全形 ０-９）→true；否則從頭掃描、
/// 跳過空白、逐一比對置中符號（長者優先），全部由符號組成才→true。
bool isReaderCenterLine(String text) {
  final String s = text.trim();
  if (s.isEmpty) return false;
  for (int i = 0; i < s.length; i++) {
    final int code = s.codeUnitAt(i);
    final bool isHalfDigit = code >= 0x30 && code <= 0x39; // '0'..'9'
    final bool isFullDigit = code >= 0xFF10 && code <= 0xFF19; // '０'..'９'
    if (!isHalfDigit && !isFullDigit) {
      // 非數字字元 → 進入符號模式，從頭掃描整行。
      int p = 0;
      while (p < s.length) {
        if (s[p].trim().isEmpty) {
          p++;
          continue;
        }
        final String? sym = _matchCenterSymbolAt(s, p);
        if (sym == null) return false;
        p += sym.length;
      }
      return true;
    }
  }
  return true; // 全數字
}

/// 段落顯示文字（`readerDisplayText`，§6.6）：空→單一空白；連續段或置中段不縮排；
/// 一般段首行縮排兩個全形空格。
String readerDisplayText(
  String text,
  bool isContinuation,
  bool isCenterAligned,
) {
  if (text.isEmpty) return ' ';
  if (isContinuation || isCenterAligned) return text;
  return '　　$text';
}

// ---- 內部：行內標籤堆疊維護（updateOpenInlineTags 家族）----

String? _matchCenterSymbolAt(String s, int index) {
  for (final String sym in _centerSymbolsByLength) {
    if (s.startsWith(sym, index)) return sym;
  }
  return null;
}

void _updateOpenInlineTags(List<String> open, String tag) {
  final String? name = _readerInlineTagName(tag);
  if (name == null) return;
  if (!_isClosingTag(tag)) {
    if (_isSelfClosingTag(tag)) return;
    open.add(name);
    return;
  }
  for (int k = open.length - 1; k >= 0; k--) {
    if (open[k] == name) {
      open.removeAt(k);
      return;
    }
  }
}

/// `readerInlineTagName`：抽出標籤名並比對 [kInlineTagNames]（大小寫不敏感）；名稱後須為
/// 空白或 `/` 才算命中（避免 `spanish` 誤判為 `span`）。非行內標籤回 `null`。
String? _readerInlineTagName(String tag) {
  String s = tag.trim();
  if (s.startsWith('<')) s = s.substring(1);
  if (s.endsWith('>')) s = s.substring(0, s.length - 1);
  s = s.trim().replaceFirst(RegExp(r'^/+'), '').trimLeft();
  final String lower = s.toLowerCase();
  for (final String name in kInlineTagNames) {
    if (lower.startsWith(name)) {
      if (s.length == name.length) return name;
      final String next = s[name.length];
      if (next.trim().isEmpty || next == '/') return name;
    }
  }
  return null;
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
