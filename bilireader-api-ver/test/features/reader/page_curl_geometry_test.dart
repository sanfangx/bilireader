import 'dart:math' as math;
import 'dart:ui';

import 'package:bilireader/features/reader/presentation/page_curl/page_curl_geometry.dart';
import 'package:flutter_test/flutter_test.dart';

// 讀取網格中 (x,y) 頂點座標。verts 排列：index = (y*(mw+1)+x)*2。
Offset vertAt(PageCurlGeometry g, int x, int y, {required bool front}) {
  final int i = (y * (g.meshWidth + 1) + x) * 2;
  final verts = front ? g.frontVerts : g.backVerts;
  return Offset(verts[i], verts[i + 1]);
}

void main() {
  const Size size = Size(300, 400);
  const int mw = 4;
  const int mh = 4;

  group('角落模式（CornerMode）', () {
    test('down.y < touch.y → topRight', () {
      final g = PageCurlGeometry.compute(
        size: size,
        downPos: const Offset(300, 100),
        touchPos: const Offset(150, 200),
        meshWidth: mw,
        meshHeight: mh,
      );
      expect(g!.corner, PageCurlCorner.topRight);
    });

    test('down.y > touch.y → bottomRight', () {
      final g = PageCurlGeometry.compute(
        size: size,
        downPos: const Offset(300, 300),
        touchPos: const Offset(150, 200),
        meshWidth: mw,
        meshHeight: mh,
      );
      expect(g!.corner, PageCurlCorner.bottomRight);
    });

    test('down.y == touch.y → landscape', () {
      final g = PageCurlGeometry.compute(
        size: size,
        downPos: const Offset(300, 200),
        touchPos: const Offset(150, 200),
        meshWidth: mw,
        meshHeight: mh,
      );
      expect(g!.corner, PageCurlCorner.landscape);
    });
  });

  group('半徑 r = |downAlignRight − touch| / π', () {
    test('landscape 水平拖動', () {
      final g = PageCurlGeometry.compute(
        size: size,
        downPos: const Offset(300, 200),
        touchPos: const Offset(150, 200),
        meshWidth: mw,
        meshHeight: mh,
      )!;
      // downAlignRight = (300,200)，touch=(150,200) → 距離 150。
      expect(g.radius, closeTo(150 / math.pi, 1e-6));
    });
  });

  test('手指貼右緣（無捲曲）→ 回傳 null', () {
    expect(
      PageCurlGeometry.compute(
        size: size,
        downPos: const Offset(300, 200),
        touchPos: const Offset(300, 200),
      ),
      isNull,
    );
  });

  group('圓柱 warp（front 網格）', () {
    late PageCurlGeometry g;
    setUp(() {
      g = PageCurlGeometry.compute(
        size: size,
        downPos: const Offset(300, 200),
        touchPos: const Offset(150, 200),
        meshWidth: mw,
        meshHeight: mh,
      )!;
    });

    test('折線左側（s<0）平貼不動', () {
      // x=0 column，位於 axis(150) 左側 → 保持初始格點。
      expect(vertAt(g, 0, 2, front: true), const Offset(0, 200));
    });

    test('右緣被捲入（x 座標小於原本 300）', () {
      final Offset p = vertAt(g, mw, 2, front: true); // x=300 col, 中列
      // curveX = r（θ=π 被夾住）→ newX = 150 + r ≈ 197.75。
      const double r = 150 / math.pi;
      expect(p.dx, closeTo(150 + r, 1e-3));
      expect(p.dy, closeTo(200, 1e-3));
      expect(p.dx, lessThan(300)); // 確實往內捲。
    });
  });

  test('背面網格與正面不同（有 warp + 鏡射）', () {
    final g = PageCurlGeometry.compute(
      size: size,
      downPos: const Offset(300, 200),
      touchPos: const Offset(150, 200),
      meshWidth: mw,
      meshHeight: mh,
    )!;
    final Offset f = vertAt(g, mw, 2, front: true);
    final Offset b = vertAt(g, mw, 2, front: false);
    expect((f - b).distance, greaterThan(1));
  });

  test('pathB（露出的下一頁）在捲曲時非空', () {
    final g = PageCurlGeometry.compute(
      size: size,
      downPos: const Offset(300, 200),
      touchPos: const Offset(120, 200),
      meshWidth: 20,
      meshHeight: 20,
    )!;
    final Rect b = g.pathB.getBounds();
    expect(b.isEmpty, isFalse);
    // 露出區靠右側（正面右緣已捲入）。
    expect(b.right, closeTo(300, 1));
  });
}
