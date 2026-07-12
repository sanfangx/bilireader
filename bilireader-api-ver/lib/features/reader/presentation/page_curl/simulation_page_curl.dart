import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../core/theme/app_motion.dart';
import 'page_curl_geometry.dart';
import 'page_curl_painter.dart';

/// 對外的翻頁控制器：讓外部（章節切換、目錄跳頁）程式化翻頁。
class PageCurlController extends ChangeNotifier {
  PageCurlController({int initialIndex = 0}) : _index = initialIndex;

  int _index;
  int get index => _index;

  _SimulationPageCurlState? _state;

  void _attach(_SimulationPageCurlState state) => _state = state;
  void _detach(_SimulationPageCurlState state) {
    if (identical(_state, state)) _state = null;
  }

  /// 由內部 state 回報目前頁碼（notifyListeners 只能在本類別內呼叫）。
  void _sync(int index) {
    _index = index;
    notifyListeners();
  }

  /// 動畫翻到下一頁。
  void next() => _state?.turnNext();

  /// 動畫翻到上一頁。
  void previous() => _state?.turnPrevious();

  /// 不帶動畫直接跳頁（例如切章）。
  void jumpTo(int index) => _state?.jumpTo(index);
}

/// 仿真翻頁容器（iBooks 風格圓柱模型），跨 iOS/Android 純 Flutter 實作。
///
/// 平時直接顯示目前頁（可互動）；拖動或點擊邊緣時，擷取「目前頁 + 相鄰頁」為點陣圖，
/// 交給 [PageCurlPainter] 做捲曲，放開後以 [AnimationController] 播完翻頁/回彈。
///
/// 供 Phase 5 ⑨e 橫向閱讀器使用：把「分頁後的整頁 widget」透過 [itemBuilder] 餵入。
class SimulationPageCurl extends StatefulWidget {
  const SimulationPageCurl({
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.onIndexChanged,
    this.backgroundColor = const Color(0xFF15110D),
    this.animDuration = AppMotion.page,
    this.meshWidth = 30,
    this.meshHeight = 40,
    this.tapToTurn = true,
    super.key,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final PageCurlController? controller;
  final ValueChanged<int>? onIndexChanged;

  /// 背面淡化目標色（＝閱讀主題背景色，見文件 §6）。
  final Color backgroundColor;
  final Duration animDuration;
  final int meshWidth;
  final int meshHeight;

  /// 點擊是否翻頁（預設 true）。閱讀器內設 false：點擊留給「切換控制列」，拖曳仍翻頁。
  final bool tapToTurn;

  @override
  State<SimulationPageCurl> createState() => _SimulationPageCurlState();
}

class _SimulationPageCurlState extends State<SimulationPageCurl>
    with SingleTickerProviderStateMixin {
  static const int _next = 1;
  static const int _prev = -1;
  static const double _slop = 8;

  final GlobalKey _prevKey = GlobalKey();
  final GlobalKey _curKey = GlobalKey();
  final GlobalKey _nextKey = GlobalKey();

  late final AnimationController _ctrl;

  late int _index = widget.controller?.index ?? 0;

  // 進行中的翻頁狀態。
  bool _active = false; // 拖動或動畫中：顯示 curl 疊層。
  bool _dragging = false; // 手指按著。
  int _dir = 0; // _next / _prev / 0
  ui.Image? _top; // 捲曲的那一頁
  ui.Image? _bottom; // 底下露出的頁
  Size _size = Size.zero;
  Offset _down = Offset.zero;
  Offset _touch = Offset.zero;
  Offset _animStart = Offset.zero;
  Offset _animEnd = Offset.zero;
  bool _commitOnEnd = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.animDuration)
      ..addListener(_onTick);
    widget.controller?._attach(this);
  }

  @override
  void didUpdateWidget(covariant SimulationPageCurl old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller?._detach(this);
      widget.controller?._attach(this);
    }
  }

  @override
  void dispose() {
    widget.controller?._detach(this);
    _ctrl.dispose();
    _top?.dispose();
    _bottom?.dispose();
    super.dispose();
  }

  bool get _hasPrev => _index > 0;
  bool get _hasNext => _index < widget.itemCount - 1;

  // ---- 對外 API ----

  void turnNext() {
    if (_active || !_hasNext) return;
    _startProgrammatic(_next);
  }

  void turnPrevious() {
    if (_active || !_hasPrev) return;
    _startProgrammatic(_prev);
  }

  void jumpTo(int index) {
    if (_active) return;
    final int clamped = index.clamp(0, widget.itemCount - 1);
    if (clamped == _index) return;
    setState(() => _index = clamped);
    _emit();
  }

  // ---- 影像擷取 ----

  ui.Image? _capture(GlobalKey key) {
    final RenderObject? ro = key.currentContext?.findRenderObject();
    if (ro is! RenderRepaintBoundary) return null;
    final double dpr = MediaQuery.devicePixelRatioOf(context);
    try {
      return ro.toImageSync(pixelRatio: dpr);
    } on Object {
      return null; // 邊界尚未合成 → 交給呼叫端 fallback（直接跳頁）。
    }
  }

  void _setImages(ui.Image? top, ui.Image? bottom) {
    _top?.dispose();
    _bottom?.dispose();
    _top = top;
    _bottom = bottom;
  }

  // ---- 程式化 / 點擊翻頁（水平 landscape 捲曲）----

  void _startProgrammatic(int dir) {
    final Size s = _size;
    if (s.isEmpty) {
      // 尚未 layout：直接跳頁。
      jumpTo(_index + dir);
      return;
    }
    final ui.Image? top = _capture(dir == _next ? _curKey : _prevKey);
    final ui.Image? bottom = _capture(dir == _next ? _nextKey : _curKey);
    if (top == null || bottom == null) {
      // 非對稱擷取：一張成功一張失敗時，成功的 ui.Image 未進 _setImages 故須自行釋放，
      // 否則每次擷取競態都漏一張原生/GPU 影像（ui.Image 需顯式 dispose）。
      top?.dispose();
      bottom?.dispose();
      jumpTo(_index + dir);
      return;
    }
    _setImages(top, bottom);
    _dir = dir;
    _down = Offset(s.width, s.height / 2);
    // NEXT：touch 由右緣捲到畫面外左側；PREV：由左側外捲入到右緣攤平。
    final Offset start = dir == _next
        ? Offset(s.width, s.height / 2)
        : Offset(-s.width, s.height / 2);
    final Offset end = dir == _next
        ? Offset(-s.width, s.height / 2)
        : Offset(s.width, s.height / 2);
    _runAnim(startTouch: start, endTouch: end, commit: true);
  }

  void _runAnim({
    required Offset startTouch,
    required Offset endTouch,
    required bool commit,
  }) {
    _animStart = startTouch;
    _animEnd = endTouch;
    _commitOnEnd = commit;
    // F-22：reduce-motion 時跳過捲曲補間、直接提交（不把 Duration.zero 塞給 controller，
    // 以免 _onTick 不觸發而卡在 _active=true）。
    if (AppMotion.reduceMotion(context)) {
      _finishAnim();
      return;
    }
    setState(() {
      _active = true;
      _touch = startTouch;
    });
    _ctrl
      ..reset()
      ..forward();
  }

  void _onTick() {
    if (!_active) return;
    final double t = Curves.easeOut.transform(_ctrl.value);
    setState(() {
      _touch = Offset.lerp(_animStart, _animEnd, t)!;
    });
    if (_ctrl.status == AnimationStatus.completed) _finishAnim();
  }

  void _finishAnim() {
    final int dir = _dir;
    final bool commit = _commitOnEnd;
    _setImages(null, null);
    setState(() {
      _active = false;
      _dragging = false;
      _dir = 0;
      if (commit) _index = (_index + dir).clamp(0, widget.itemCount - 1);
    });
    if (commit) _emit();
  }

  void _emit() {
    widget.controller?._sync(_index);
    widget.onIndexChanged?.call(_index);
  }

  // ---- 互動拖動 ----

  void _onPanStart(DragStartDetails d) {
    if (_active) return;
    _down = d.localPosition;
    _touch = d.localPosition;
    _dragging = true;
    _dir = 0;
  }

  void _onPanUpdate(DragUpdateDetails d) {
    if (!_dragging || _active && _dir == 0) return;
    _touch = d.localPosition;

    if (_dir == 0) {
      final double dxTotal = _touch.dx - _down.dx;
      if (dxTotal.abs() < _slop) return; // 尚未確定方向。
      final int dir = dxTotal < 0 ? _next : _prev;
      if (dir == _next && !_hasNext) {
        _dragging = false;
        return;
      }
      if (dir == _prev && !_hasPrev) {
        _dragging = false;
        return;
      }
      final ui.Image? top = _capture(dir == _next ? _curKey : _prevKey);
      final ui.Image? bottom = _capture(dir == _next ? _nextKey : _curKey);
      if (top == null || bottom == null) {
        // 非對稱擷取：成功的一張未進 _setImages，須自行釋放避免漏原生/GPU 影像。
        top?.dispose();
        bottom?.dispose();
        _dragging = false;
        return;
      }
      _setImages(top, bottom);
      _dir = dir;
      _active = true;
    }
    setState(() {});
  }

  void _onPanEnd(DragEndDetails d) {
    if (!_active || _dir == 0) {
      _dragging = false;
      return;
    }
    final double w = _size.width;
    final bool commit = _dir == _next ? _touch.dx < w / 2 : _touch.dx > w / 2;
    final Offset target = _dir == _next
        ? Offset(commit ? -w : w, _down.dy)
        : Offset(commit ? w : -w, _down.dy);
    _runAnim(startTouch: _touch, endTouch: target, commit: commit);
  }

  void _onTapUp(TapUpDetails d) {
    if (_active) return;
    final double w = _size.width;
    // 左 1/3 上一頁；其餘下一頁。
    if (d.localPosition.dx < w / 3) {
      turnPrevious();
    } else {
      turnNext();
    }
  }

  // ---- build ----

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints c) {
        _size = Size(c.maxWidth, c.maxHeight);
        final PageCurlGeometry? geometry = _active
            ? PageCurlGeometry.compute(
                size: _size,
                downPos: _down,
                touchPos: _touch,
                meshWidth: widget.meshWidth,
                meshHeight: widget.meshHeight,
              )
            : null;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: widget.tapToTurn ? _onTapUp : null,
          onHorizontalDragStart: _onPanStart,
          onHorizontalDragUpdate: _onPanUpdate,
          onHorizontalDragEnd: _onPanEnd,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              // 擷取層：prev / next 墊在底下（被目前頁覆蓋），供翻頁時截圖。
              if (_hasPrev) _boundary(_prevKey, _index - 1),
              if (_hasNext) _boundary(_nextKey, _index + 1),
              _boundary(_curKey, _index),
              // 捲曲疊層。
              if (_active && _top != null && _bottom != null)
                Positioned.fill(
                  child: CustomPaint(
                    painter: PageCurlPainter(
                      topImage: _top!,
                      bottomImage: _bottom!,
                      geometry: geometry,
                      backTint: widget.backgroundColor,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _boundary(GlobalKey key, int index) => Positioned.fill(
    child: RepaintBoundary(
      key: key,
      child: ColoredBox(
        color: widget.backgroundColor,
        child: widget.itemBuilder(context, index),
      ),
    ),
  );
}
