import 'package:bilireader_app/core/discovery/paged_list_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// 依 page → 回吐固定資料的 fetcher 工廠；記錄呼叫頁碼。
PagedListController<int> _ctrl(
  Future<List<int>> Function(int page, CancelToken token) fetch,
) =>
    PagedListController<int>(fetcher: fetch, idOf: (n) => n);

void main() {
  test('load：第一頁 → ready，items 到齊，hasMore true', () async {
    final c = _ctrl((page, _) async => [1, 2, 3]);
    await c.load();
    expect(c.status, PageStatus.ready);
    expect(c.items, [1, 2, 3]);
    expect(c.hasMore, isTrue);
  });

  test('load：第一頁空 → empty，hasMore false', () async {
    final c = _ctrl((page, _) async => []);
    await c.load();
    expect(c.status, PageStatus.empty);
    expect(c.items, isEmpty);
    expect(c.hasMore, isFalse);
  });

  test('loadMore：追加下一頁、頁碼遞增', () async {
    final pages = {
      1: [1, 2, 3],
      2: [4, 5, 6],
    };
    final calls = <int>[];
    final c = _ctrl((page, _) async {
      calls.add(page);
      return pages[page] ?? [];
    });
    await c.load();
    await c.loadMore();
    expect(c.items, [1, 2, 3, 4, 5, 6]);
    expect(calls, [1, 2]);
    expect(c.hasMore, isTrue);
  });

  test('loadMore：空的下一頁 → hasMore false，頁碼不前進（下次不再打）', () async {
    final calls = <int>[];
    final c = _ctrl((page, _) async {
      calls.add(page);
      return page == 1 ? [1, 2] : <int>[];
    });
    await c.load();
    await c.loadMore(); // page 2 空
    expect(c.hasMore, isFalse);
    expect(c.items, [1, 2]);
    await c.loadMore(); // 已 !hasMore → 不再打
    expect(calls, [1, 2]);
  });

  test('loadMore 去重：重複的最後一頁 → 不重複追加且 hasMore false', () async {
    // 站方對超範圍頁碼回吐與第一頁相同的內容。
    final c = _ctrl((page, _) async => [1, 2, 3]);
    await c.load();
    await c.loadMore(); // 回同一頁 → 0 筆新 → 到底
    expect(c.items, [1, 2, 3]);
    expect(c.hasMore, isFalse);
  });

  test('loadMore 部分重疊：只追加新項', () async {
    final c = _ctrl((page, _) async => page == 1 ? [1, 2, 3] : [3, 4, 5]);
    await c.load();
    await c.loadMore();
    expect(c.items, [1, 2, 3, 4, 5]); // 3 去重
    expect(c.hasMore, isTrue);
  });

  test('load 錯誤 → error 態', () async {
    final c = _ctrl((page, _) async => throw Exception('boom'));
    await c.load();
    expect(c.status, PageStatus.error);
    expect(c.items, isEmpty);
  });

  test('loadMore 錯誤 → loadMoreError，retry 後成功', () async {
    int attempt = 0;
    final c = _ctrl((page, _) async {
      if (page == 1) return [1, 2];
      attempt++;
      if (attempt == 1) throw Exception('flaky');
      return [3, 4];
    });
    await c.load();
    await c.loadMore(); // 第一次 page2 失敗
    expect(c.loadMoreError, isTrue);
    expect(c.items, [1, 2]);
    await c.retryLoadMore(); // 重試成功
    expect(c.loadMoreError, isFalse);
    expect(c.items, [1, 2, 3, 4]);
  });

  test('refresh：保留舊列表直到新第一頁到齊，再替換', () async {
    var payload = [1, 2, 3];
    final c = _ctrl((page, _) async => List<int>.from(payload));
    await c.load();
    expect(c.items, [1, 2, 3]);
    payload = [7, 8];
    await c.refresh();
    expect(c.items, [7, 8]);
    expect(c.status, PageStatus.ready);
  });

  test('refresh 失敗但保留舊資料 → 維持 ready + refreshFailed（不鎖死 loadMore）', () async {
    var fail = false;
    final c = _ctrl((page, _) async {
      if (fail) throw Exception('net');
      return page == 1 ? [1, 2] : [3, 4];
    });
    await c.load();
    fail = true;
    await c.refresh();
    // 舊清單仍在、狀態維持 ready（舊版會卡 error → loadMore 永久失效）。
    expect(c.status, PageStatus.ready);
    expect(c.items, [1, 2]);
    expect(c.refreshFailed, isTrue);
    // 關鍵回歸：刷新失敗後 loadMore 仍可運作（恢復成功後續抓下一頁）。
    fail = false;
    await c.loadMore();
    expect(c.items, [1, 2, 3, 4]);
    c.clearRefreshFailed();
    expect(c.refreshFailed, isFalse);
  });

  test('首次 load 失敗（無舊資料）→ error 態', () async {
    final c = _ctrl((page, _) async => throw Exception('net'));
    await c.load();
    expect(c.status, PageStatus.error);
    expect(c.refreshFailed, isFalse);
  });

  test('取消：舊 load 的遲到結果被丟棄（後發先至的新 load 勝出）', () async {
    // 用呼叫序號分辨兩次 load（都抓 page 1）：第一次慢且結果應作廢、第二次快勝出。
    int n = 0;
    final c = _ctrl((page, _) async {
      n++;
      if (n == 1) {
        await Future<void>.delayed(const Duration(milliseconds: 40));
        return [1, 1, 1]; // 過期，應被丟棄
      }
      return [9]; // 新 load，勝出
    });
    final slow = c.load(); // 觸發第 1 次（慢）
    final fast = c.load(); // 觸發第 2 次（快）→ 取消第 1 次的 token
    await Future.wait([slow, fast]);
    expect(c.items, [9]);
    expect(c.status, PageStatus.ready);
  });

  test('dispose 後不再 notify、在途取消', () async {
    var notified = 0;
    final c = _ctrl((page, _) async => [1]);
    c.addListener(() => notified++);
    await c.load();
    final before = notified;
    c.dispose();
    // dispose 後呼叫 loadMore 應為 no-op（status 檢查 + _disposed）。
    await c.loadMore();
    expect(notified, before);
  });

  test('items 為唯讀視圖（不可從外部變更內部列表）', () async {
    final c = _ctrl((page, _) async => [1, 2]);
    await c.load();
    expect(() => c.items.add(3), throwsUnsupportedError);
  });
}
