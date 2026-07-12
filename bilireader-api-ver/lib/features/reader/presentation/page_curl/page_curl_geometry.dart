import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

/// 翻頁時被拖動的角落。對應 libreadview `IBookCurlRenderer.CornerMode`：
/// 由 `downPos.y` 與 `touchPos.y` 的高低關係決定（見 `reader_page_curl_algorithm.md` §3）。
enum PageCurlCorner {
  /// 翻右上角（`downPos.y < touchPos.y`）。
  topRight,

  /// 翻右下角（`downPos.y > touchPos.y`）。
  bottomRight,

  /// 水平翻整條右邊（`downPos.y == touchPos.y`）。
  landscape,
}

/// 仿真翻頁（iBooks 風格圓柱模型）的**純幾何**。
///
/// 由 [PageCurlGeometry.compute] 依「按下起點 [downPos] + 目前手指 [touchPos]」算出：
/// 正面網格頂點 [frontVerts]、背面網格頂點 [backVerts]、正面輪廓 [frontSilhouette]、
/// 露出的下一頁區域 [pathB]、以及陰影所需的錨點與角度。
///
/// 座標系：頁面填滿 `[0,W]×[0,H]`，書脊在左邊緣 `x=0`，手指自右邊緣往左拖。
/// 移植自 libreadview `IBookCurlRenderer.kt`；公式對照 `reader_page_curl_algorithm.md`。
class PageCurlGeometry {
  const PageCurlGeometry._({
    required this.size,
    required this.corner,
    required this.meshWidth,
    required this.meshHeight,
    required this.frontVerts,
    required this.backVerts,
    required this.frontSilhouette,
    required this.backSilhouette,
    required this.pathB,
    required this.radius,
    required this.axis,
    required this.axisLineStart,
    required this.shadowCross,
  });

  /// 頁面尺寸（邏輯像素）。
  final Size size;
  final PageCurlCorner corner;
  final int meshWidth;
  final int meshHeight;

  /// 正面（front）變形後網格頂點，`(meshWidth+1)*(meshHeight+1)` 個點，`Float32List` 交錯 `x,y`。
  final Float32List frontVerts;

  /// 背面（back）變形 + 鏡射後網格頂點，排列同 [frontVerts]。
  final Float32List backVerts;

  /// 正面實際輪廓（捲曲後的剪影），用來裁切正面與計算 [pathB]。
  final Path frontSilhouette;

  /// 背面輪廓，用來裁切背面淡化區。
  final Path backSilhouette;

  /// 露出的下一頁區域 = 整頁矩形 − [frontSilhouette]。
  final Path pathB;

  /// 圓柱半徑 `r = |downAlignRight − touch| / π`。
  final double radius;

  /// 圓柱軸位置（= 目前手指位置）。
  final Offset axis;

  /// 軸線與頁面上/下緣的交點（陰影錨點之一）。
  final Offset axisLineStart;

  /// 折線與右緣的交點（BottomRight 陰影錨點）。
  final Offset shadowCross;

  static const double _eps = 1e-4;

  /// 依手勢兩點算出整套幾何。若手指幾乎貼在右邊緣（無捲曲）則回傳 `null`（畫平面即可）。
  static PageCurlGeometry? compute({
    required Size size,
    required Offset downPos,
    required Offset touchPos,
    int meshWidth = 30,
    int meshHeight = 40,
  }) {
    final double w = size.width;
    final double h = size.height;
    if (w <= 0 || h <= 0) return null;

    // downAlignRightPos：釘在右邊緣、與起點同高。
    final Offset downAlignRight = Offset(w, downPos.dy);

    // mouseDir = normalize(downAlignRight − touch)。
    final double rawX = downAlignRight.dx - touchPos.dx;
    final double rawY = downAlignRight.dy - touchPos.dy;
    final double mouseLen = math.sqrt(rawX * rawX + rawY * rawY);
    if (mouseLen < _eps) return null; // 手指貼右緣起點 → 尚未捲曲。
    final double mdx = rawX / mouseLen;
    final double mdy = rawY / mouseLen;

    final PageCurlCorner corner = downPos.dy < touchPos.dy
        ? PageCurlCorner.topRight
        : (downPos.dy > touchPos.dy
              ? PageCurlCorner.bottomRight
              : PageCurlCorner.landscape);

    final Offset axis = touchPos; // cylinderAxisPos
    // 半徑：r = |downAlignRight − touch| / π（原碼 else 分支為死碼，見文件 §3）。
    final double radius = mouseLen / math.pi;
    if (radius < _eps) return null;

    // 投影點：沿 mouseDir 展開半周長。
    final Offset engleProj = Offset(
      axis.dx + mdx * radius * math.pi / 2,
      axis.dy + mdy * radius * math.pi / 2,
    );
    final Offset axisProj = Offset(
      axis.dx + mdx * radius * math.pi,
      axis.dy + mdy * radius * math.pi,
    );

    // 各條「線與頁緣交點」：分角落模式。topMiddle.y=0、bottomMiddle.y=H。
    // 為避免 mdx==0 除零，夾一個極小值（手指落在右緣時才可能發生）。
    final double safeMdx = mdx.abs() < _eps ? (mdx < 0 ? -_eps : _eps) : mdx;
    final double safeMdy = mdy.abs() < _eps ? (mdy < 0 ? -_eps : _eps) : mdy;

    late final Offset axisLineStart;
    late final Offset engleLineProjStart;
    switch (corner) {
      case PageCurlCorner.topRight:
        axisLineStart = Offset(axis.dx + mdy / safeMdx * (axis.dy - 0), 0);
        engleLineProjStart = Offset(
          engleProj.dx + mdy / safeMdx * (engleProj.dy - 0),
          0,
        );
      case PageCurlCorner.bottomRight:
        axisLineStart = Offset(axis.dx + mdy / safeMdx * (axis.dy - h), h);
        engleLineProjStart = Offset(
          engleProj.dx + mdy / safeMdx * (engleProj.dy - h),
          h,
        );
      case PageCurlCorner.landscape:
        axisLineStart = Offset(axis.dx, 0);
        engleLineProjStart = Offset(engleProj.dx, 0);
    }

    // axisLineEnd + shadowCross（陰影落點）。
    final Offset shadowCross = _computeShadowCross(
      corner: corner,
      w: w,
      h: h,
      axis: axis,
      axisLineStart: axisLineStart,
      mdx: mdx,
      safeMdy: safeMdy,
    );

    // ---- 正面 Region A 網格 ----
    final Float32List frontVerts = _initGrid(w, h, meshWidth, meshHeight);
    _warpCylinder(
      verts: frontVerts,
      originX: axis.dx,
      originY: axis.dy,
      ux: mdx, // u = mouseDir
      uy: mdy,
      radius: radius,
    );

    // ---- 背面 Region C 網格：反向 warp + 鏡射 ----
    final Float32List backVerts = _initGrid(w, h, meshWidth, meshHeight);
    _warpCylinder(
      verts: backVerts,
      originX: axisProj.dx,
      originY: axisProj.dy,
      ux: -mdx, // u = −mouseDir
      uy: -mdy,
      radius: radius,
    );
    _reflectAboutPoint(
      verts: backVerts,
      pivot: engleProj,
      axisStart: engleLineProjStart,
    );

    // ---- 輪廓 + pathB ----
    final Path frontSilhouette = _buildSilhouette(
      frontVerts,
      meshWidth,
      meshHeight,
    );
    final Path backSilhouette = _buildSilhouette(
      backVerts,
      meshWidth,
      meshHeight,
    );
    final Path pageRect = Path()..addRect(Rect.fromLTWH(0, 0, w, h));
    final Path pathB = Path.combine(
      PathOperation.difference,
      pageRect,
      frontSilhouette,
    );

    return PageCurlGeometry._(
      size: size,
      corner: corner,
      meshWidth: meshWidth,
      meshHeight: meshHeight,
      frontVerts: frontVerts,
      backVerts: backVerts,
      frontSilhouette: frontSilhouette,
      backSilhouette: backSilhouette,
      pathB: pathB,
      radius: radius,
      axis: axis,
      axisLineStart: axisLineStart,
      shadowCross: shadowCross,
    );
  }

  /// 在 `[0,W]×[0,H]` 鋪均勻格點（y 外 x 內），對應 `initMeshVerts`。
  static Float32List _initGrid(double w, double h, int mw, int mh) {
    final Float32List verts = Float32List((mw + 1) * (mh + 1) * 2);
    int i = 0;
    for (int y = 0; y <= mh; y++) {
      final double fy = h * y / mh;
      for (int x = 0; x <= mw; x++) {
        verts[i++] = w * x / mw;
        verts[i++] = fy;
      }
    }
    return verts;
  }

  /// 圓柱 warp（就地修改）：對應 `computeRegionAMeshVerts` / C 的迴圈本體。
  static void _warpCylinder({
    required Float32List verts,
    required double originX,
    required double originY,
    required double ux,
    required double uy,
    required double radius,
  }) {
    const double halfPi = math.pi / 2;
    for (int i = 0; i < verts.length; i += 2) {
      final double dx = verts[i] - originX;
      final double dy = verts[i + 1] - originY;
      final double s = dx * ux + dy * uy; // 沿翻頁軸投影
      final double t = -dx * uy + dy * ux; // 垂直投影
      if (s < 0) continue; // 折線左側：平貼不動。
      final double theta = s / radius;
      final double curveX = theta < halfPi ? radius * math.sin(theta) : radius;
      verts[i] = originX + curveX * ux - t * uy;
      verts[i + 1] = originY + curveX * uy + t * ux;
    }
  }

  /// 繞 [pivot] 對「pivot→axisStart」軸做鏡射（就地）。對應 `regionCMatrix`（文件 §5）。
  static void _reflectAboutPoint({
    required Float32List verts,
    required Offset pivot,
    required Offset axisStart,
  }) {
    final double ddx = pivot.dx - axisStart.dx;
    final double ddy = pivot.dy - axisStart.dy;
    final double dis = math.sqrt(ddx * ddx + ddy * ddy);
    if (dis < _eps) return; // 軸退化 → 不鏡射。
    final double sinv = ddx / dis; // 注意：sin 取 Δx
    final double cosv = ddy / dis; // cos 取 Δy
    final double l00 = -(1 - 2 * sinv * sinv);
    final double l01 = 2 * sinv * cosv;
    final double l10 = 2 * sinv * cosv;
    final double l11 = 1 - 2 * sinv * sinv;
    for (int i = 0; i < verts.length; i += 2) {
      final double px = verts[i] - pivot.dx;
      final double py = verts[i + 1] - pivot.dy;
      verts[i] = pivot.dx + l00 * px + l01 * py;
      verts[i + 1] = pivot.dy + l10 * px + l11 * py;
    }
  }

  /// 沿變形網格四邊描出封閉輪廓。對應 `buildPath`（上緣→右緣→下緣反向→左緣反向）。
  static Path _buildSilhouette(Float32List verts, int mw, int mh) {
    final Path path = Path();
    int idx(int x, int y) => (y * (mw + 1) + x) * 2;
    // 上緣 y=0，左→右
    path.moveTo(verts[idx(0, 0)], verts[idx(0, 0) + 1]);
    for (int x = 0; x <= mw; x++) {
      path.lineTo(verts[idx(x, 0)], verts[idx(x, 0) + 1]);
    }
    // 右緣 x=mw，上→下
    for (int y = 0; y <= mh; y++) {
      path.lineTo(verts[idx(mw, y)], verts[idx(mw, y) + 1]);
    }
    // 下緣 y=mh，右→左
    for (int x = mw; x >= 0; x--) {
      path.lineTo(verts[idx(x, mh)], verts[idx(x, mh) + 1]);
    }
    // 左緣 x=0，下→上
    for (int y = mh; y >= 0; y--) {
      path.lineTo(verts[idx(0, y)], verts[idx(0, y) + 1]);
    }
    path.close();
    return path;
  }

  /// 陰影落點：對應 `computeShadowPoints`（文件 §9）。
  static Offset _computeShadowCross({
    required PageCurlCorner corner,
    required double w,
    required double h,
    required Offset axis,
    required Offset axisLineStart,
    required double mdx,
    required double safeMdy,
  }) {
    if (corner == PageCurlCorner.landscape) {
      // axisLineEnd = (axis.x, H)
      return Offset(axis.dx, h);
    }
    // axisLineEnd：右緣 x=W 上，y = axis.y + (−mdx)/mdy*(W − axis.x)
    final Offset topRight = Offset(w, 0);
    final Offset bottomRight = Offset(w, h);
    final Offset? cross = _lineIntersection(
      axis,
      axisLineStart,
      topRight,
      bottomRight,
    );
    if (corner == PageCurlCorner.topRight) {
      if (cross == null || cross.dy > bottomRight.dy) {
        return _perpendicularFoot(bottomRight, axis, axisLineStart);
      }
      return cross;
    } else {
      if (cross == null || cross.dy < topRight.dy) {
        return _perpendicularFoot(topRight, axis, axisLineStart);
      }
      return cross;
    }
  }

  /// 兩直線交點；平行回 `null`。對應 `computeCrossPoint`。
  static Offset? _lineIntersection(Offset p1, Offset p2, Offset p3, Offset p4) {
    final double a1 = p2.dy - p1.dy;
    final double b1 = p1.dx - p2.dx;
    final double c1 = a1 * p1.dx + b1 * p1.dy;
    final double a2 = p4.dy - p3.dy;
    final double b2 = p3.dx - p4.dx;
    final double c2 = a2 * p3.dx + b2 * p3.dy;
    final double det = a1 * b2 - a2 * b1;
    if (det.abs() < _eps) return null;
    return Offset((b2 * c1 - b1 * c2) / det, (a1 * c2 - a2 * c1) / det);
  }

  /// 點 a 到直線 bc 的垂足。對應 `perpendicularFoot`。
  static Offset _perpendicularFoot(Offset a, Offset b, Offset c) {
    final double vx = c.dx - b.dx;
    final double vy = c.dy - b.dy;
    final double wx = a.dx - b.dx;
    final double wy = a.dy - b.dy;
    final double vv = vx * vx + vy * vy;
    if (vv < _eps) return b;
    final double tt = (wx * vx + wy * vy) / vv;
    return Offset(b.dx + tt * vx, b.dy + tt * vy);
  }
}
