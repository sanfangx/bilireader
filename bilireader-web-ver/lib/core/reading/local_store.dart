import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 本機閱讀進度。
class ReadProgress {
  ReadProgress({
    required this.novelId,
    required this.title,
    required this.chapterIndex,
    required this.totalChapters,
    required this.chapterTitle,
    required this.updatedAt,
    this.cover,
  });

  final String novelId;
  final String title;
  final int chapterIndex;
  final int totalChapters;
  final String chapterTitle;
  final int updatedAt;

  /// 封面 URL（絕對）。書架「繼續閱讀」卡縮圖用——不依賴目前分組清單反查，
  /// 切到不含該書的分組時封面才不會消失。由閱讀器進度寫入時帶入（poster）。
  final String? cover;

  /// 概略進度 0~1（以章節序計）。
  double get percent =>
      totalChapters <= 1 ? 1 : (chapterIndex / (totalChapters - 1)).clamp(0, 1);

  bool get finished => totalChapters > 0 && chapterIndex >= totalChapters - 1;

  Map<String, dynamic> toJson() => {
        'id': novelId,
        't': title,
        'ci': chapterIndex,
        'tc': totalChapters,
        'ct': chapterTitle,
        'ts': updatedAt,
        if (cover != null) 'cv': cover,
      };

  static ReadProgress fromJson(Map<String, dynamic> j) => ReadProgress(
        novelId: j['id'] as String,
        title: j['t'] as String? ?? '',
        chapterIndex: j['ci'] as int? ?? 0,
        totalChapters: j['tc'] as int? ?? 1,
        chapterTitle: j['ct'] as String? ?? '',
        updatedAt: j['ts'] as int? ?? 0,
        cover: j['cv'] as String?,
      );
}

/// 書籤（本機）。
class Bookmark {
  Bookmark({
    required this.novelId,
    required this.novelTitle,
    required this.chapterIndex,
    required this.chapterTitle,
    required this.snippet,
    required this.createdAt,
    this.charOffset = 0,
  });

  final String novelId;
  final String novelTitle;
  final int chapterIndex;
  final String chapterTitle;
  final String snippet;
  final int createdAt;
  final int charOffset; // 章內字元位移（精準閱讀位置；不受字級/螢幕影響）

  String get key => '$novelId#$chapterIndex#$charOffset';

  Map<String, dynamic> toJson() => {
        'id': novelId,
        'nt': novelTitle,
        'ci': chapterIndex,
        'ct': chapterTitle,
        'sn': snippet,
        'ts': createdAt,
        'co': charOffset,
      };

  static Bookmark fromJson(Map<String, dynamic> j) => Bookmark(
        novelId: j['id'] as String,
        novelTitle: j['nt'] as String? ?? '',
        chapterIndex: j['ci'] as int? ?? 0,
        chapterTitle: j['ct'] as String? ?? '',
        snippet: j['sn'] as String? ?? '',
        createdAt: j['ts'] as int? ?? 0,
        charOffset: j['co'] as int? ?? 0,
      );
}

/// 本機書庫資料：閱讀進度 + 書籤。純本機，flutter_secure_storage 持久化。
/// （收藏分組已改為伺服器端 `ShelfClass`；本機分組已移除。）
class LocalStore extends ChangeNotifier {
  LocalStore._();
  static final LocalStore instance = LocalStore._();

  static const _storage = FlutterSecureStorage();
  static const _kProgress = 'reading_progress_v1';
  static const _kBookmarks = 'bookmarks_v1';

  final Map<String, ReadProgress> _progress = {};
  final List<Bookmark> _bookmarks = [];
  bool _loaded = false;

  bool get loaded => _loaded;

  /// 通知監聽者——**若目前所處的幀階段會讓 widget 樹被鎖定，則延到本幀結束後再通知**。
  ///
  /// 坑：`ReaderPage.dispose()` 會 flush 最後一筆進度（→ [saveProgress] → notifyListeners），
  /// 而 element 的 dispose 跑在 `BuildOwner.finalizeTree` 的 `lockState` 內。此時任何
  /// `setState` / `markNeedsBuild` 都會被框架擋下並拋
  /// 「setState() or markNeedsBuild() called when widget tree was locked」。後果有兩個：
  /// (1) console 每次離開閱讀器都噴例外；
  /// (2) **更實際的傷害**——書架「繼續閱讀」與目錄「閱讀中」標記那些 `ListenableBuilder`
  ///     根本收不到這次更新，返回後畫面停在舊進度（它們正是靠監聽本 store 才即時更新的）。
  ///
  /// 修法是延到 post-frame callback：`finalizeTree` 屬於 `drawFrame` 的一部分，post-frame
  /// callback 在 `drawFrame` 之後才跑，那時樹已解鎖，監聽者照常於下一幀重建。
  /// 非幀期間的呼叫（捲動防抖存檔、App 進背景 flush、加/刪書籤）行為完全不變。
  @override
  void notifyListeners() {
    final SchedulerPhase phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.persistentCallbacks ||
        phase == SchedulerPhase.midFrameMicrotasks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        super.notifyListeners();
      });
      return;
    }
    super.notifyListeners();
  }

  Future<void> load() async {
    if (_loaded) return;
    try {
      final p = await _storage.read(key: _kProgress);
      if (p != null) {
        final m = jsonDecode(p) as Map<String, dynamic>;
        for (final e in m.entries) {
          _progress[e.key] =
              ReadProgress.fromJson(e.value as Map<String, dynamic>);
        }
      }
      final b = await _storage.read(key: _kBookmarks);
      if (b != null) {
        for (final e in jsonDecode(b) as List) {
          _bookmarks.add(Bookmark.fromJson(e as Map<String, dynamic>));
        }
      }
    } catch (_) {
      // 壞資料則忽略，從空開始。
    }
    _loaded = true;
    notifyListeners();
  }

  // ---- 書籤 ----
  List<Bookmark> bookmarksFor(String novelId) =>
      _bookmarks.where((b) => b.novelId == novelId).toList()
        ..sort((a, b) => a.chapterIndex.compareTo(b.chapterIndex));

  List<Bookmark> get allBookmarks =>
      _bookmarks.toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  bool addBookmark(Bookmark bm) {
    if (_bookmarks.any((x) => x.key == bm.key)) return false;
    _bookmarks.add(bm);
    notifyListeners();
    _storage.write(
        key: _kBookmarks,
        value: jsonEncode(_bookmarks.map((e) => e.toJson()).toList()));
    return true;
  }

  void removeBookmark(Bookmark bm) {
    _bookmarks.removeWhere((x) => x.key == bm.key);
    notifyListeners();
    _storage.write(
        key: _kBookmarks,
        value: jsonEncode(_bookmarks.map((e) => e.toJson()).toList()));
  }

  // ---- 進度 ----
  ReadProgress? progressOf(String novelId) => _progress[novelId];

  /// 最近閱讀（更新時間最大）。
  ReadProgress? get latest {
    ReadProgress? best;
    for (final p in _progress.values) {
      if (best == null || p.updatedAt > best.updatedAt) best = p;
    }
    return best;
  }

  int get readingCount => _progress.length;

  Future<void> saveProgress(ReadProgress p) async {
    final old = _progress[p.novelId];
    final cover = p.cover ?? old?.cover; // 新值優先；無新值保留既有封面
    final bool sameChapter = old != null &&
        old.chapterIndex == p.chapterIndex &&
        old.totalChapters == p.totalChapters &&
        old.cover == cover;
    // updatedAt 一律更新（記憶體即時）→ 「繼續閱讀」永遠指向最後開啟/閱讀的書，
    // 即使回到舊書同一章繼續看（修正舊版同章早退不更新 updatedAt → 卡指向錯書）。
    _progress[p.novelId] = ReadProgress(
      novelId: p.novelId,
      title: p.title,
      chapterIndex: p.chapterIndex,
      totalChapters: p.totalChapters,
      chapterTitle: p.chapterTitle,
      updatedAt: p.updatedAt,
      cover: cover,
    );
    notifyListeners();
    // 章內滾動（同章）不狂寫磁碟；換章 / 換書才落盤（節流保留）。
    if (!sameChapter) await _persistProgress();
  }

  Future<void> _persistProgress() async {
    final m = {for (final e in _progress.entries) e.key: e.value.toJson()};
    await _storage.write(key: _kProgress, value: jsonEncode(m));
  }

}
