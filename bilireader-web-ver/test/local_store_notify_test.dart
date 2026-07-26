import 'package:bilireader_app/core/reading/local_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// 迴歸測試：`LocalStore` 在「widget 樹被鎖定」的幀階段通知監聽者，不得炸出
/// 「setState() or markNeedsBuild() called when widget tree was locked」。
///
/// 坑（2026-07-26 模擬器實測到的真實 stack）：
///   LocalStore.saveProgress → _ReaderPageState._saveProgressNow → _ReaderPageState.dispose
///   → StatefulElement.unmount → ConsumerStatefulElement.unmount → _InactiveElements._unmount
/// 閱讀器在 dispose 內 flush 最後一筆進度，而 element 的 dispose 跑在
/// `BuildOwner.finalizeTree` 的 `lockState` 內 → 同步 notifyListeners 會讓底下仍掛載的
/// 書架/目錄 `ListenableBuilder` 的 markNeedsBuild 被框架擋下。
///
/// 實際傷害不只是 console 噴例外：**那次更新整個遺失**，返回書架後「繼續閱讀」
/// 仍顯示舊進度——而它正是靠監聽本 store 才即時更新的。
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // flutter_secure_storage 在測試環境沒有原生實作；saveProgress 換章時會落盤，
  // 不 mock 會丟 MissingPluginException。回 null 即可（本測試不驗持久化）。
  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      (MethodCall call) async => null,
    );
  });

  ReadProgress progress(int chapterIndex) => ReadProgress(
        novelId: 'local-store-notify-test',
        title: '測試書',
        chapterIndex: chapterIndex,
        totalChapters: 10,
        chapterTitle: '第 $chapterIndex 章',
        updatedAt: 1000 + chapterIndex,
      );

  testWidgets('dispose（樹鎖定期）內 saveProgress：不拋例外，且監聽者仍收到更新',
      (WidgetTester tester) async {
    int builds = 0;

    Widget tree({required bool showProbe}) => MaterialApp(
          home: Column(
            children: <Widget>[
              // 代表書架「繼續閱讀」/ 目錄「閱讀中」標記：常駐、監聽 LocalStore。
              ListenableBuilder(
                listenable: LocalStore.instance,
                builder: (BuildContext _, Widget? _) {
                  builds++;
                  return const SizedBox.shrink();
                },
              ),
              if (showProbe) const _DisposeWritesProgress(),
            ],
          ),
        );

    await tester.pumpWidget(tree(showProbe: true));
    final int buildsBefore = builds;

    // 移除 probe → 其 dispose 在 finalizeTree 的 lockState 內呼叫 saveProgress。
    await tester.pumpWidget(tree(showProbe: false));

    expect(
      tester.takeException(),
      isNull,
      reason: '樹鎖定期的 notifyListeners 必須延到 post-frame，不能同步打 markNeedsBuild',
    );

    // 延後的通知在本幀結束後送達 → 下一幀監聽者重建（更新沒有遺失）。
    await tester.pump();
    expect(
      builds,
      greaterThan(buildsBefore),
      reason: '延後通知後監聽者必須真的重建，否則等於把更新吞掉',
    );
  });

  testWidgets('一般（非幀期間）呼叫維持同步通知，行為不變',
      (WidgetTester tester) async {
    int builds = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: ListenableBuilder(
          listenable: LocalStore.instance,
          builder: (BuildContext _, Widget? _) {
            builds++;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    final int before = builds;

    // 幀外呼叫（等同捲動防抖存檔 / App 進背景 flush）。
    await LocalStore.instance.saveProgress(progress(7));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(builds, greaterThan(before));
  });
}

/// dispose 時寫入進度的探針——重現 `ReaderPage.dispose()` 的 flush 行為。
class _DisposeWritesProgress extends StatefulWidget {
  const _DisposeWritesProgress();

  @override
  State<_DisposeWritesProgress> createState() => _DisposeWritesProgressState();
}

class _DisposeWritesProgressState extends State<_DisposeWritesProgress> {
  @override
  void dispose() {
    LocalStore.instance.saveProgress(
      ReadProgress(
        novelId: 'local-store-notify-test',
        title: '測試書',
        chapterIndex: 3,
        totalChapters: 10,
        chapterTitle: '第 3 章',
        updatedAt: 2000,
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
