// 私有 final 欄位須由具名參數轉寫初始化（不能 `required this._fetcher`——具名參數
// 不可私有），故此檔停用 prefer_initializing_formals。
// ignore_for_file: prefer_initializing_formals
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// 抓某一頁；[cancelToken] 於篩選變更 / dispose 時取消。回傳該頁項目（可空）。
typedef PageFetcher<T> = Future<List<T>> Function(int page, CancelToken cancelToken);

/// 取項目的唯一鍵，用於跨頁去重（避免站方對「超出範圍的頁碼」回吐重複的最後一頁 →
/// 造成無限載入）。
typedef ItemId<T> = Object Function(T item);

/// 首頁載入的四態（尾端「載入更多」另由 [loadingMore]/[loadMoreError]/[hasMore] 表示）。
enum PageStatus { loading, ready, empty, error }

/// 通用分頁清單控制器（`ChangeNotifier`，不引入 riverpod）。
///
/// 對齊 api-ver 清單互動規範：
/// - F-14 下拉刷新**保留舊列表**直到新第一頁到齊（[refresh]）。
/// - F-15/F-30 載入更多三態：進行中 / 失敗可重試 / 已無更多（[loadingMore]/[loadMoreError]/[hasMore]）。
/// - F-16 競態防護：切篩選 / 換 query 前取消在途請求，取消結果**靜默**不進錯誤態。
///
/// [hasMore] 判定不靠「每頁固定筆數」魔法常數，改用**去重**：某頁沒帶來任何新 id
/// （空頁或重複的最後一頁）即視為到底。
class PagedListController<T> extends ChangeNotifier {
  PagedListController({
    required PageFetcher<T> fetcher,
    required ItemId<T> idOf,
    this.firstPage = 1,
  })  : _fetcher = fetcher,
        _idOf = idOf;

  final PageFetcher<T> _fetcher;
  final ItemId<T> _idOf;
  final int firstPage;

  final List<T> _items = <T>[];
  final Set<Object> _seen = <Object>{};

  PageStatus _status = PageStatus.loading;
  bool _loadingMore = false;
  bool _loadMoreError = false;
  bool _hasMore = true;
  bool _refreshFailed = false; // 下拉刷新失敗（但保留了舊清單）→ 供 UI 提示，不鎖死清單
  int _page = 1;

  CancelToken? _token;
  bool _disposed = false;

  /// 目前已載入的項目（唯讀視圖）。
  List<T> get items => List<T>.unmodifiable(_items);
  PageStatus get status => _status;
  bool get loadingMore => _loadingMore;
  bool get loadMoreError => _loadMoreError;

  /// 上一次下拉刷新是否失敗（但舊清單仍在、仍可瀏覽/載入更多）。UI 讀取後應提示並清旗標。
  bool get refreshFailed => _refreshFailed;
  void clearRefreshFailed() => _refreshFailed = false;

  /// 是否還有下一頁（尚未證實到底）。空清單時無意義。
  bool get hasMore => _hasMore;

  /// 首次載入 / 篩選變更後重載：**清空**列表、回到第一頁。取消任何在途請求。
  Future<void> load() => _loadFirst(keepWhileLoading: false);

  /// 下拉刷新：**保留**舊列表直到新第一頁到齊（F-14）。
  Future<void> refresh() => _loadFirst(keepWhileLoading: true);

  Future<void> _loadFirst({required bool keepWhileLoading}) async {
    _cancelInFlight();
    final CancelToken token = _token = CancelToken();

    _page = firstPage;
    _hasMore = true;
    _loadingMore = false;
    _loadMoreError = false;
    _refreshFailed = false;
    if (!keepWhileLoading) {
      _items.clear();
      _seen.clear();
    }
    // 刷新（keepWhileLoading）時若已有舊資料，維持 ready 顯示舊清單，不切 loading 骨架。
    final bool keepReady = keepWhileLoading && _items.isNotEmpty;
    if (!keepReady) _status = PageStatus.loading;
    _notify();

    List<T> fetched;
    try {
      fetched = await _fetcher(_page, token);
    } on DioException catch (e) {
      if (_isStale(token) || e.type == DioExceptionType.cancel) return;
      _failFirstLoad(keepReady);
      return;
    } catch (_) {
      if (_isStale(token)) return;
      _failFirstLoad(keepReady);
      return;
    }
    if (_isStale(token)) return;

    // 刷新成功才換掉舊資料（keepWhileLoading 情況下先前未清空）。
    _items.clear();
    _seen.clear();
    final int added = _appendNew(fetched);
    _hasMore = added > 0; // 第一頁若為空 → 無更多。
    _status = _items.isEmpty ? PageStatus.empty : PageStatus.ready;
    _notify();
  }

  /// 首頁載入/刷新失敗的收尾：有舊清單可留（刷新）→ 回 ready + 標記 refreshFailed，
  /// 讓清單仍可瀏覽與載入更多（修正舊版「刷新失敗把 status 卡在 error → loadMore 永久失效」）；
  /// 無舊清單（首載）→ 進 error 態顯示錯誤畫面。
  void _failFirstLoad(bool keepReady) {
    if (keepReady) {
      _status = PageStatus.ready;
      _refreshFailed = true;
    } else {
      _status = PageStatus.error;
    }
    _notify();
  }

  /// 載入下一頁（尾端觸發）。只在 ready 且尚有更多且非進行中時動作。
  Future<void> loadMore() async {
    if (_status != PageStatus.ready ||
        _loadingMore ||
        !_hasMore ||
        _disposed) {
      return;
    }
    final CancelToken token = _token ??= CancelToken();
    _loadingMore = true;
    _loadMoreError = false;
    _notify();

    final int nextPage = _page + 1;
    List<T> fetched;
    try {
      fetched = await _fetcher(nextPage, token);
    } on DioException catch (e) {
      if (_isStale(token) || e.type == DioExceptionType.cancel) return;
      _loadingMore = false;
      _loadMoreError = true;
      _notify();
      return;
    } catch (_) {
      if (_isStale(token)) return;
      _loadingMore = false;
      _loadMoreError = true;
      _notify();
      return;
    }
    if (_isStale(token)) return;

    final int added = _appendNew(fetched);
    if (added == 0) {
      _hasMore = false; // 空頁或重複最後一頁 → 到底。
    } else {
      _page = nextPage;
    }
    _loadingMore = false;
    _notify();
  }

  /// 尾端載入更多失敗後的重試。
  Future<void> retryLoadMore() {
    _loadMoreError = false;
    return loadMore();
  }

  /// 追加尚未見過的項目；回傳實際新增筆數。
  int _appendNew(List<T> fetched) {
    int added = 0;
    for (final T item in fetched) {
      final Object id = _idOf(item);
      if (_seen.add(id)) {
        _items.add(item);
        added++;
      }
    }
    return added;
  }

  void _cancelInFlight() {
    _token?.cancel('superseded');
    _token = null;
  }

  /// 該 token 是否已被更新的請求取代 / 控制器已釋放 → 其結果應丟棄。
  bool _isStale(CancelToken token) => _disposed || token != _token;

  void _notify() {
    if (_disposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _cancelInFlight();
    super.dispose();
  }
}
