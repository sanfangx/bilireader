import 'package:bilireader/features/discover/domain/carousel_slide.dart';
import 'package:bilireader/features/discover/presentation/widgets/carousel_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

List<CarouselSlide> _slides(int n) => List<CarouselSlide>.generate(
  n,
  (int i) => CarouselSlide(articleId: i, describe: '書$i'),
);

Widget _host(Widget child, {bool reduceMotion = false}) => MediaQuery(
  data: MediaQueryData(disableAnimations: reduceMotion),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: Center(child: SizedBox(width: 360, child: child)),
  ),
);

void main() {
  // F-22 erratum：報告稱「輪播自動播放不會停」為誤報——carousel_banner 是純手動
  // PageView（無 Timer/autoplay）。此守門測試證明靜置不自行換頁，防後批誤加停用邏輯。
  testWidgets('F-22 輪播無 autoplay：靜置 10s 不自行換頁', (WidgetTester tester) async {
    await tester.pumpWidget(_host(CarouselBanner(slides: _slides(3))));
    await tester.pump(const Duration(seconds: 10));
    final PageView pv = tester.widget<PageView>(find.byType(PageView));
    final PageController controller = pv.controller!;
    expect(controller.hasClients, isTrue);
    expect(controller.page, 0.0, reason: '無 autoplay → 頁碼靜止在第一頁');
  });

  testWidgets('F-22 頁碼點 reduce-motion 折零：AnimatedContainer duration=0', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(CarouselBanner(slides: _slides(3)), reduceMotion: true),
    );
    await tester.pump();
    final Iterable<AnimatedContainer> dots = tester
        .widgetList<AnimatedContainer>(find.byType(AnimatedContainer));
    expect(dots, isNotEmpty);
    for (final AnimatedContainer c in dots) {
      expect(c.duration, Duration.zero);
    }
  });
}
