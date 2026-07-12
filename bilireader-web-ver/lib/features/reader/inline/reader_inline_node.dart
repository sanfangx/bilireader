import 'package:flutter/foundation.dart';

/// 行內富文本 AST（`ReaderInlineParser` 的輸出）。純資料模型；由 `ReaderSpanBuilder`
/// 渲染成 `TextSpan`/`WidgetSpan`/`CustomPaint`。
///
/// 移植自 bilireader-api-ver 的 `reader_inline_node.dart`（達成閱讀器 parity 的地基）。
@immutable
sealed class InlineNode {
  const InlineNode();
}

/// 傍点（著重號）樣式：underDot=圓點·字下、overSesame=芝麻點「﹅」·字上、overDot=圓點·字上。
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

// ---- 渲染用尺寸常數（語意與 sup/small node 綁定）----

/// `<sup>` 相對字級。
const double kSupTextScale = 0.55;

/// `<small>` 相對字級下限。
const double kMinSmallTextScale = 0.6;

/// `<small>` 相對字級：`f4`=字級 px、`f5`=縮減 px。`max(f4-f5, 0.6*f4)/f4`；任一 ≤0 回 1.0。
double smallTextScale(double f4, double f5) {
  if (f4 <= 0 || f5 <= 0) return 1.0;
  final double v = (f4 - f5) > (kMinSmallTextScale * f4)
      ? (f4 - f5)
      : (kMinSmallTextScale * f4);
  return v / f4;
}

/// 去標籤後的「可見文字」：ruby 只留 base、heimu 留內容、`<br>`→`\n`。
/// 供分頁量測與 charOffset 對映（富文本章的字元位移一律以此為準）。
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
