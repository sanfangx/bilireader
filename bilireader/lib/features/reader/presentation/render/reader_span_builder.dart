import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../domain/reader_inline_node.dart';
import 'reader_style.dart';

/// 把 [InlineNode] 串轉成可渲染的 [InlineSpan]（design「閱讀器 .prose」+ doc 05 §5、§6）。
///
/// - 文字：色/上標(sup 0.55)/縮小(small) → `TextSpan`。
/// - ruby：`WidgetSpan`（base 上方金色注音 rt，design `.prose ruby rt`）。
/// - heimu：`WidgetSpan`（未揭露以 [ReaderStyle.heimuColor] 遮罩，點擊揭露；§6.2）。
/// - 傍点：逐字 `WidgetSpan` 於字上/下畫圓點或芝麻點（§6.3）。
///
/// 註：ruby/heimu/傍点 以 `PlaceholderAlignment.middle` 對齊（CJK 字形置中，近似基線；精準基線於
/// §10.1 ADB 微調）。傍点逐字 span 可正常換行；heimu 為不換行原子 span（劇透片段通常短）。
class ReaderSpanBuilder {
  const ReaderSpanBuilder();

  InlineSpan build(
    List<InlineNode> nodes,
    ReaderStyle style, {
    Set<int> revealedHeimu = const <int>{},
    void Function(int heimuIndex)? onHeimuTap,
  }) {
    final List<InlineSpan> children = <InlineSpan>[];
    int heimuIndex = 0;
    for (final InlineNode n in nodes) {
      switch (n) {
        case final TextRun t:
          children.addAll(_textRun(t, style));
        case final RubyRun r:
          children.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: _RubyText(base: r.base, rt: r.rt, style: style),
            ),
          );
        case final HeimuRun h:
          final int idx = heimuIndex++;
          children.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: _HeimuText(
                child: build(
                  h.children,
                  style,
                  revealedHeimu: revealedHeimu,
                  onHeimuTap: onHeimuTap,
                ),
                style: style,
                revealed: revealedHeimu.contains(idx),
                onTap: onHeimuTap == null ? null : () => onHeimuTap(idx),
              ),
            ),
          );
        case LineBreakRun():
          children.add(const TextSpan(text: '\n'));
      }
    }
    return TextSpan(style: style.baseTextStyle, children: children);
  }

  /// 純文字 span（供分頁量測）：ruby→base、heimu→內容、傍点→文字、sup/small 縮放。
  /// 產生的純文字＝[visibleText]，故 `TextPainter` 的字元 offset 對齊「可見字」空間
  /// （與 `mapReaderVisibleOffsetToOriginalText` 一致）。無 `WidgetSpan`（可用 offset/量測）。
  InlineSpan buildPlain(List<InlineNode> nodes, ReaderStyle style) {
    final List<InlineSpan> children = <InlineSpan>[];
    for (final InlineNode n in nodes) {
      switch (n) {
        case final TextRun t:
          children.add(TextSpan(text: t.text, style: _runStyle(t, style)));
        case final RubyRun r:
          children.add(TextSpan(text: r.base, style: style.baseTextStyle));
        case final HeimuRun h:
          children.add(buildPlain(h.children, style));
        case LineBreakRun():
          children.add(const TextSpan(text: '\n'));
      }
    }
    return TextSpan(style: style.baseTextStyle, children: children);
  }

  TextStyle _runStyle(TextRun t, ReaderStyle style) {
    double scale = 1;
    if (t.superscript) scale *= kSupTextScale;
    if (t.smallLevel > 0) {
      final double s = smallTextScale(style.fontSizePx, style.smallReductionPx);
      for (int i = 0; i < t.smallLevel; i++) {
        scale *= s;
      }
    }
    return style.baseTextStyle.copyWith(
      color: t.color != null ? Color(t.color!) : style.textColor,
      fontSize: style.fontSizePx * scale,
    );
  }

  List<InlineSpan> _textRun(TextRun t, ReaderStyle style) {
    final TextStyle ts = _runStyle(t, style);
    if (t.emphasis == null) {
      return <InlineSpan>[TextSpan(text: t.text, style: ts)];
    }
    // 傍点：逐字 WidgetSpan（可換行）。
    return <InlineSpan>[
      for (final String ch in t.text.characters)
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: _EmphasisChar(
            char: ch,
            style: ts,
            mark: t.emphasis!,
            color: style.emphasisColor,
          ),
        ),
    ];
  }
}

/// 振假名：base 上方標注 rt（金色、0.5 字級）。
class _RubyText extends StatelessWidget {
  const _RubyText({required this.base, required this.rt, required this.style});

  final String base;
  final String rt;
  final ReaderStyle style;

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = style.baseTextStyle.copyWith(height: 1.0);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          rt,
          maxLines: 1,
          style: baseStyle.copyWith(
            fontSize: style.fontSizePx * 0.5,
            color: style.rubyColor,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
          ),
        ),
        Text(base, maxLines: 1, style: baseStyle),
      ],
    );
  }
}

/// 黑幕：未揭露以遮罩色蓋住（保留尺寸），點擊揭露顯示原文（§6.2）。
class _HeimuText extends StatelessWidget {
  const _HeimuText({
    required this.child,
    required this.style,
    required this.revealed,
    this.onTap,
  });

  final InlineSpan child;
  final ReaderStyle style;
  final bool revealed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget content = Text.rich(child);
    if (revealed) {
      return GestureDetector(onTap: onTap, child: content);
    }
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: <Widget>[
          Opacity(opacity: 0, child: content), // 保留尺寸
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: style.heimuColor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 傍点：單一字元上/下畫圓點或芝麻點（§6.3）。
class _EmphasisChar extends StatelessWidget {
  const _EmphasisChar({
    required this.char,
    required this.style,
    required this.mark,
    required this.color,
  });

  final String char;
  final TextStyle style;
  final ReaderEmphasis mark;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final TextPainter tp = TextPainter(
      text: TextSpan(text: char, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    final double fs = style.fontSize ?? 16;
    final double r = math.max(fs * 0.075, 1);
    final bool over = mark != ReaderEmphasis.underDot;
    final double markGap = r * 2 + 2;
    final Size size = Size(tp.width, tp.height + markGap);
    // F-27b：芝麻點 TextPainter 於 build 期建構一次（隨字元/樣式重建），不再於每次 paint()
    // 逐字逐幀 new + layout。圓點以 canvas 直接畫、不需 painter。
    TextPainter? sesamePainter;
    if (mark == ReaderEmphasis.overSesame) {
      sesamePainter = TextPainter(
        text: TextSpan(
          text: '﹅',
          style: TextStyle(fontSize: fs * 0.34, color: color),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
    }
    return CustomPaint(
      size: size,
      painter: _EmphasisPainter(
        painter: tp,
        over: over,
        sesamePainter: sesamePainter,
        radius: r,
        gap: markGap,
        color: color,
      ),
    );
  }
}

class _EmphasisPainter extends CustomPainter {
  _EmphasisPainter({
    required this.painter,
    required this.over,
    required this.sesamePainter,
    required this.radius,
    required this.gap,
    required this.color,
  });

  final TextPainter painter;
  final bool over;

  /// 非 null＝芝麻點（已於 build 期 layout）；null＝圓點（canvas 直接畫）。
  final TextPainter? sesamePainter;
  final double radius;
  final double gap;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // 字元：over 時往下讓出頂部標記空間。
    final double charTop = over ? gap : 0;
    painter.paint(canvas, Offset(0, charTop));
    final double cx = size.width / 2;
    final double cy = over ? gap / 2 : size.height - gap / 2;
    final TextPainter? sp = sesamePainter;
    if (sp != null) {
      sp.paint(canvas, Offset(cx - sp.width / 2, cy - sp.height / 2));
    } else {
      canvas.drawCircle(Offset(cx, cy), radius, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _EmphasisPainter old) =>
      old.painter != painter ||
      old.over != over ||
      old.sesamePainter != sesamePainter ||
      old.radius != radius ||
      old.color != color;
}
