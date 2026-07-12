import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

import 'page_curl_geometry.dart';

/// 把 [PageCurlGeometry] 畫成仿真翻頁畫面。移植自 `IBookCurlRenderer.render`（文件 §8）：
/// 依序畫「露出的下一頁 B → 正面 A → 淡化的背面 C → 折線陰影」。
///
/// [topImage]＝正在翻走、會捲曲的那一頁（front）；[bottomImage]＝底下露出的頁。
/// 兩張皆為已渲染的整頁點陣圖（`RepaintBoundary.toImage`）。
class PageCurlPainter extends CustomPainter {
  const PageCurlPainter({
    required this.topImage,
    required this.bottomImage,
    required this.geometry,
    required this.backTint,
  });

  final ui.Image topImage;
  final ui.Image bottomImage;

  /// `null` 代表尚未捲曲（手指貼右緣）→ 直接畫平面的 [topImage]。
  final PageCurlGeometry? geometry;

  /// 紙張背面淡化目標色（建議＝閱讀器主題背景色）。
  final Color backTint;

  @override
  void paint(Canvas canvas, Size size) {
    final PageCurlGeometry? g = geometry;
    if (g == null) {
      _drawImageCover(canvas, topImage, size);
      return;
    }

    final _MeshCache cache = _meshCacheFor(g, topImage);

    // 1) 露出的下一頁（Region B）+ 抬起頁投影。
    canvas.save();
    canvas.clipPath(g.pathB);
    _drawImageCover(canvas, bottomImage, size);
    _drawBottomPageShadow(canvas, g, size);
    canvas.restore();

    // 2) 正面（Region A）：整片網格（含平貼區）貼 topImage。
    final ui.Paint frontPaint = ui.Paint()
      ..shader = _shaderForCached(topImage)
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.low;
    canvas.save();
    canvas.clipPath(g.frontSilhouette);
    canvas.drawVertices(
      _vertices(g.frontVerts, cache),
      BlendMode.srcOver,
      frontPaint,
    );
    canvas.restore();

    // 3) 背面（Region C）：貼 topImage，套背面淡化 ColorFilter。
    final ui.Paint backPaint = ui.Paint()
      ..shader = _shaderForCached(topImage)
      ..colorFilter = _backFaceFilterCached(backTint)
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.low;
    canvas.save();
    canvas.clipPath(g.backSilhouette);
    canvas.drawVertices(
      _vertices(g.backVerts, cache),
      BlendMode.srcOver,
      backPaint,
    );
    canvas.restore();

    // 4) 圓柱自陰影（沿折線，寬 = 半徑），裁到正面剪影內。
    canvas.save();
    canvas.clipPath(g.frontSilhouette);
    _drawCylinderShadow(canvas, g);
    canvas.restore();
  }

  // ---- 陰影 ----------------------------------------------------------------

  /// 圓柱自陰影：折線處透明、向捲起方向漸深的灰帶（對應 `drawCylinderShadow`）。
  void _drawCylinderShadow(Canvas canvas, PageCurlGeometry g) {
    final double bandLen = (g.shadowCross - g.axisLineStart).distance;
    if (bandLen < 1 || g.radius < 1) return;
    final ui.Offset anchor;
    final double rot;
    switch (g.corner) {
      case PageCurlCorner.bottomRight:
        anchor = g.shadowCross;
        rot = _foldAngle(g) + math.pi;
      case PageCurlCorner.topRight:
        anchor = g.axisLineStart;
        rot = _foldAngle(g);
      case PageCurlCorner.landscape:
        anchor = g.axisLineStart;
        rot = 0;
    }
    final Rect band = Rect.fromLTWH(0, 0, g.radius, bandLen);
    final ui.Paint paint = ui.Paint()
      ..shader = ui.Gradient.linear(
        band.topLeft,
        Offset(g.radius, 0),
        const <Color>[Color(0x00000000), Color(0x33000000)],
      );
    canvas.save();
    canvas.translate(anchor.dx, anchor.dy);
    canvas.rotate(rot);
    canvas.drawRect(band, paint);
    canvas.restore();
  }

  /// 抬起頁在下一頁上的投影：折線處最深、向外淡出的黑帶（對應 `drawBottomPageShadow`）。
  void _drawBottomPageShadow(Canvas canvas, PageCurlGeometry g, Size size) {
    final double bandLen = (g.shadowCross - g.axisLineStart).distance;
    if (bandLen < 1) return;
    final double width = math.max(g.radius * 1.2, 18);
    final ui.Offset anchor;
    final double rot;
    switch (g.corner) {
      case PageCurlCorner.bottomRight:
        anchor = g.shadowCross;
        rot = _foldAngle(g) + math.pi;
      case PageCurlCorner.topRight:
        anchor = g.axisLineStart;
        rot = _foldAngle(g);
      case PageCurlCorner.landscape:
        anchor = g.axisLineStart;
        rot = 0;
    }
    // 折線位於帶的一側（local x=0），向頁面內側（−x）淡出。
    final Rect band = Rect.fromLTWH(-width, 0, width, bandLen);
    final ui.Paint paint = ui.Paint()
      ..shader = ui.Gradient.linear(
        Offset(-width, 0),
        Offset.zero,
        const <Color>[Color(0x00000000), Color(0x40000000)],
      );
    canvas.save();
    canvas.translate(anchor.dx, anchor.dy);
    canvas.rotate(rot);
    canvas.drawRect(band, paint);
    canvas.restore();
  }

  /// 折線角度：`atan2(axis − axisLineStart) − 90°`，讓帶的長邊對齊折線。
  double _foldAngle(PageCurlGeometry g) {
    final double dx = g.axis.dx - g.axisLineStart.dx;
    final double dy = g.axis.dy - g.axisLineStart.dy;
    return math.atan2(dy, dx) - math.pi / 2;
  }

  // ---- drawVertices 輔助 ----------------------------------------------------

  ui.Vertices _vertices(Float32List positions, _MeshCache cache) =>
      ui.Vertices.raw(
        VertexMode.triangles,
        positions,
        textureCoordinates: cache.texCoords,
        indices: cache.indices,
      );

  void _drawImageCover(Canvas canvas, ui.Image image, Size size) {
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, size.width, size.height),
      ui.Paint()..filterQuality = FilterQuality.low,
    );
  }

  @override
  bool shouldRepaint(covariant PageCurlPainter old) =>
      old.geometry != geometry ||
      old.topImage != topImage ||
      old.bottomImage != bottomImage ||
      old.backTint != backTint;
}

/// 每種 (mesh 尺寸, 影像尺寸) 對應一組固定的紋理座標 + 三角形索引，跨幀重用。
class _MeshCache {
  _MeshCache(this.texCoords, this.indices);

  final Float32List texCoords;
  final Uint16List indices;
}

_MeshCache? _cached;
int _cachedKey = 0;

_MeshCache _meshCacheFor(PageCurlGeometry g, ui.Image image) {
  final int key = Object.hash(
    g.meshWidth,
    g.meshHeight,
    image.width,
    image.height,
  );
  final _MeshCache? c = _cached;
  if (c != null && key == _cachedKey) return c;

  final int mw = g.meshWidth;
  final int mh = g.meshHeight;
  final double iw = image.width.toDouble();
  final double ih = image.height.toDouble();

  // 紋理座標＝均勻格點（影像像素空間）。
  final Float32List tex = Float32List((mw + 1) * (mh + 1) * 2);
  int t = 0;
  for (int y = 0; y <= mh; y++) {
    final double fy = ih * y / mh;
    for (int x = 0; x <= mw; x++) {
      tex[t++] = iw * x / mw;
      tex[t++] = fy;
    }
  }

  // 三角形索引：每格兩個三角形。
  final Uint16List idx = Uint16List(mw * mh * 6);
  int k = 0;
  for (int y = 0; y < mh; y++) {
    for (int x = 0; x < mw; x++) {
      final int n = y * (mw + 1) + x;
      final int nr = n + 1;
      final int nb = n + (mw + 1);
      final int nbr = nb + 1;
      idx[k++] = n;
      idx[k++] = nr;
      idx[k++] = nb;
      idx[k++] = nr;
      idx[k++] = nbr;
      idx[k++] = nb;
    }
  }

  final _MeshCache built = _MeshCache(tex, idx);
  _cached = built;
  _cachedKey = key;
  return built;
}

// F-27a：ImageShader / 背面 ColorFilter 跨幀重用（painter 每幀重建，但 topImage /
// backTint 於一次捲曲期間不變）。避免每次 paint() 逐幀 new 2 個 ImageShader + 1 個
// ColorFilter.matrix。與 _MeshCache 同為模組級 LRU-1（依身分/值重建）。
ui.Shader? _cachedShader;
ui.Image? _cachedShaderImage;

ui.Shader _shaderForCached(ui.Image image) {
  if (_cachedShader == null || !identical(image, _cachedShaderImage)) {
    _cachedShader = ui.ImageShader(
      image,
      TileMode.clamp,
      TileMode.clamp,
      Matrix4.identity().storage,
    );
    _cachedShaderImage = image;
  }
  return _cachedShader!;
}

const double _backMix = 0.2; // 背面淡化混合比（對應正面貼圖）。
ColorFilter? _cachedBackFilter;
Color? _cachedBackTint;

ColorFilter _backFaceFilterCached(Color tint) {
  if (_cachedBackFilter == null || tint != _cachedBackTint) {
    final double tr = (tint.r * 255.0) * (1 - _backMix);
    final double tg = (tint.g * 255.0) * (1 - _backMix);
    final double tb = (tint.b * 255.0) * (1 - _backMix);
    _cachedBackFilter = ColorFilter.matrix(<double>[
      _backMix, 0, 0, 0, tr, //
      0, _backMix, 0, 0, tg, //
      0, 0, _backMix, 0, tb, //
      0, 0, 0, 1, 0, //
    ]);
    _cachedBackTint = tint;
  }
  return _cachedBackFilter!;
}
