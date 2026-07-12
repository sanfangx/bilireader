import 'package:bilireader/core/di/infra_providers.dart';
import 'package:bilireader/features/discover/data/discover_providers.dart';
import 'package:bilireader/features/system/data/system_providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'fake_discover.dart';
import 'fake_stores.dart';

/// 以 fake stores override 包裝 App，供 widget / golden 測試避免觸及 secure storage、
/// SharedPreferences 平台 channel 與真實網路。回傳包好的 [Widget]（overrides 型別由推斷）。
///
/// 書城首頁會觀察多個資料 provider；此處以 [FakeBookRepository]（回傳空結果）override
/// [bookRepositoryProvider]，讓 shell / golden / smoke 測試在確定性空狀態下渲染。
Widget wrapAppForTest(Widget child) {
  return ProviderScope(
    overrides: [
      tokenStoreProvider.overrideWithValue(FakeTokenStore()),
      sessionStoreProvider.overrideWithValue(FakeSessionStore()),
      bookRepositoryProvider.overrideWithValue(const FakeBookRepository()),
      // MainShell 啟動流程（feature ⑧）走無網路 fake，測試不觸網、不彈公告。
      systemRepositoryProvider.overrideWithValue(const FakeSystemRepository()),
    ],
    child: child,
  );
}
