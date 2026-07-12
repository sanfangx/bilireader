import 'package:bilireader/core/common_widgets/bili_empty_view.dart';
import 'package:bilireader/core/common_widgets/bili_list_footer.dart';
import 'package:bilireader/core/theme/app_colors.dart';
import 'package:bilireader/core/theme/app_spacing.dart';
import 'package:bilireader/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// 批 3 新元件的 gallery golden（§9.3：loading/error/empty 樣式課有 golden 義務）。
/// BiliListFooter 三態（載入中 / 失敗+重試 / 已無更多）+ BiliEmptyView，兩尺寸鎖定。
void main() {
  Future<void> pump(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildDarkTheme(),
        home: const Scaffold(body: _Gallery()),
      ),
    );
    await tester.pump(const Duration(milliseconds: 50));
  }

  testWidgets('四態元件 gallery golden 360x640', (WidgetTester tester) async {
    await pump(tester, const Size(360, 640));
    await expectLater(
      find.byType(_Gallery),
      matchesGoldenFile('goldens/four_state_360x640.png'),
    );
  });

  testWidgets('四態元件 gallery golden 390x844', (WidgetTester tester) async {
    await pump(tester, const Size(390, 844));
    await expectLater(
      find.byType(_Gallery),
      matchesGoldenFile('goldens/four_state_390x844.png'),
    );
  });

  group('BiliListFooter.stateOf（F-24 尾端狀態推導）', () {
    test('載入中 → loading（優先）', () {
      expect(
        BiliListFooter.stateOf(
          loadingMore: true,
          loadMoreError: false,
          hasMore: true,
        ),
        BiliListFooterState.loading,
      );
    });
    test('失敗 → error', () {
      expect(
        BiliListFooter.stateOf(
          loadingMore: false,
          loadMoreError: true,
          hasMore: true,
        ),
        BiliListFooterState.error,
      );
    });
    test('無更多 → end', () {
      expect(
        BiliListFooter.stateOf(
          loadingMore: false,
          loadMoreError: false,
          hasMore: false,
        ),
        BiliListFooterState.end,
      );
    });
    test('還有更多、未載入、無錯 → null（不顯示 footer）', () {
      expect(
        BiliListFooter.stateOf(
          loadingMore: false,
          loadMoreError: false,
          hasMore: true,
        ),
        isNull,
      );
    });
  });
}

class _Gallery extends StatelessWidget {
  const _Gallery();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.bg,
      child: Column(
        children: <Widget>[
          const SizedBox(height: AppSpacing.lg),
          // BiliListFooter 三態。
          const BiliListFooter(state: BiliListFooterState.loading),
          const Divider(height: 1, color: AppColors.line),
          BiliListFooter(state: BiliListFooterState.error, onRetry: () {}),
          const Divider(height: 1, color: AppColors.line),
          const BiliListFooter(state: BiliListFooterState.end),
          const Divider(height: 1, color: AppColors.line),
          // BiliEmptyView（含動作按鈕）。
          Expanded(
            child: BiliEmptyView(
              message: '找不到相關作品',
              icon: Icons.search_off,
              detail: '換個關鍵字或標籤試試',
              actionLabel: '重新搜尋',
              onAction: () {},
            ),
          ),
        ],
      ),
    );
  }
}
