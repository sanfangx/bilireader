import 'package:bilireader/core/di/infra_providers.dart';
import 'package:bilireader/features/bookshelf/presentation/bookshelf_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_stores.dart';

/// 未登入時書架顯示登入引導，且不觸發 `bookcase/*` 網路請求（避免 401 迴圈）。
void main() {
  testWidgets('未登入 → 顯示登入引導', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tokenStoreProvider.overrideWithValue(FakeTokenStore()),
          sessionStoreProvider.overrideWithValue(FakeSessionStore()),
        ],
        child: const MaterialApp(home: BookshelfPage()),
      ),
    );
    await tester.pump();

    expect(find.text('尚未登入'), findsOneWidget);
    expect(find.text('前往登入'), findsOneWidget);
    // 書架 grid / 繼續閱讀卡不應出現。
    expect(find.byType(RefreshIndicator), findsNothing);
  });
}
