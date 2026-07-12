import 'package:flutter/foundation.dart';

/// 行內富文本 AST（`ReaderInlineParser` 的輸出），對應反編譯 `formatReaderText` 產生的
/// `Spannable`（見 `apk/docs/flutter/05-閱讀器渲染管線.md` §5）。純資料模型；渲染成
/// `TextSpan`/`WidgetSpan`/`CustomPaint`（依設計稿）屬 ⑨e。
@immutable
sealed class InlineNode {
  const InlineNode();
}

/// 傍点（著重號）樣式。對應 `ReaderTextEmphasisSpan(Mark, Position)`（§5.2）：
/// underdot=圓點·字下、oversesame=芝麻點「﹅」·字上、overdot=圓點·字上。
enum ReaderEmphasis { underDot, overSesame, overDot }

/// 一段文字 + 其累積樣式。[color]=ARGB（null 用主題文字色）；[superscript]=`<sup>`
/// （渲染時額外 ×[kSupTextScale]）；[smallLevel]=巢狀 `<small>` 層數（每層 ×smallScale）；
/// [emphasis]=傍点。
class TextRun extends InlineNode {
  const TextRun(
    this.text, {
    this.color,
    this.superscript = false,
    this.smallLevel = 0,
    this.emphasis,
  });

  final String text;
  final int? color;
  final bool superscript;
  final int smallLevel;
  final ReaderEmphasis? emphasis;

  @override
  bool operator ==(Object other) =>
      other is TextRun &&
      other.text == text &&
      other.color == color &&
      other.superscript == superscript &&
      other.smallLevel == smallLevel &&
      other.emphasis == emphasis;

  @override
  int get hashCode =>
      Object.hash(text, color, superscript, smallLevel, emphasis);

  @override
  String toString() =>
      'TextRun("$text"${color != null ? ', color: $color' : ''}'
      '${superscript ? ', sup' : ''}${smallLevel > 0 ? ', small: $smallLevel' : ''}'
      '${emphasis != null ? ', $emphasis' : ''})';
}

/// 振假名 ruby：[base] 上方標注 [rt]（皆為去標籤後可見文字）。
class RubyRun extends InlineNode {
  const RubyRun(this.base, this.rt);

  final String base;
  final String rt;

  @override
  bool operator ==(Object other) =>
      other is RubyRun && other.base == base && other.rt == rt;

  @override
  int get hashCode => Object.hash(base, rt);

  @override
  String toString() => 'RubyRun("$base" / "$rt")';
}

/// 黑幕（劇透遮罩）：整段以 [children] 包住，點擊揭露（reveal 狀態於渲染層）。
class HeimuRun extends InlineNode {
  const HeimuRun(this.children);

  final List<InlineNode> children;

  @override
  bool operator ==(Object other) =>
      other is HeimuRun && listEquals(other.children, children);

  @override
  int get hashCode => Object.hashAll(children);

  @override
  String toString() => 'HeimuRun($children)';
}

/// `<br>` 換行。
class LineBreakRun extends InlineNode {
  const LineBreakRun();

  @override
  bool operator ==(Object other) => other is LineBreakRun;

  @override
  int get hashCode => 0x0a;

  @override
  String toString() => 'LineBreakRun()';
}

// ---- 渲染用尺寸常數（供 ⑨e；語意與 sup/small node 綁定）----

/// `<sup>` 相對字級（`SUP_TEXT_SCALE`，§5.3）。
const double kSupTextScale = 0.55;

/// `<small>` 相對字級下限（`MIN_SMALL_TEXT_SCALE`，§5.3）。
const double kMinSmallTextScale = 0.6;

/// `<small>` 相對字級（`smallTextScale`，§5.3）：`f4`=字級 px、`f5`=縮減 px。
/// `max(f4-f5, 0.6*f4)/f4`；任一 ≤0 回 1.0（不縮放）。
double smallTextScale(double f4, double f5) {
  if (f4 <= 0 || f5 <= 0) return 1.0;
  final double v = (f4 - f5) > (kMinSmallTextScale * f4)
      ? (f4 - f5)
      : (kMinSmallTextScale * f4);
  return v / f4;
}

/// 去標籤後的「可見文字」（`readerVisibleText`，§5.4）：ruby 只留 base、heimu 留內容、
/// `<br>`→`\n`。供分頁量測與 offset 對映。
String visibleText(List<InlineNode> nodes) {
  final StringBuffer sb = StringBuffer();
  for (final InlineNode n in nodes) {
    switch (n) {
      case TextRun(:final text):
        sb.write(text);
      case RubyRun(:final base):
        sb.write(base);
      case HeimuRun(:final children):
        sb.write(visibleText(children));
      case LineBreakRun():
        sb.write('\n');
    }
  }
  return sb.toString();
}
