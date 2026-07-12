import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/reader/chapter_extractor.dart';
import '../../features/reader/content_block.dart';
import '../app_config.dart';
import '../models/catalog.dart';
import '../network/api_client.dart';
import '../network/linovelib_api.dart';
import '../session/auth_controller.dart';

/// 離線章節中繼資料。
class OfflineChapterMeta {
  OfflineChapterMeta(this.index, this.title, this.ok, this.url, this.vip,
      {this.vol});
  final int index;
  final String title;
  final bool ok;
  final String? url;
  final bool vip;

  /// 所屬卷名 → 離線閱讀器內建目錄也能依卷分組（與線上開啟一致；舊下載無此欄則退化不分卷）。
  final String? vol;

  Map<String, dynamic> toJson() => {
        'i': index,
        't': title,
        'ok': ok,
        'u': url,
        'vip': vip,
        if (vol != null) 'vol': vol,
      };
  static OfflineChapterMeta fromJson(Map<String, dynamic> m) =>
      OfflineChapterMeta(
        m['i'] as int,
        m['t'] as String? ?? '',
        m['ok'] as bool? ?? true,
        m['u'] as String?,
        m['vip'] as bool? ?? false,
        vol: m['vol'] as String?,
      );
}

/// 下載生命週期狀態（持久化進 manifest，支援跨 App 重啟的續傳／暫停／停止判斷）。
/// - active：下載中或被中斷（App 被殺）→ 重啟時**自動續傳**。
/// - paused：使用者主動暫停 → 重啟時保留暫停態，等使用者手動繼續，不自動跑。
/// - stopped：使用者主動停止 → 保留已下載章節為離線書，不自動續傳。
/// - done：已跑完整本（即使少數章節永久失敗）→ 不再自動續傳。
enum OfflineStatus { active, paused, stopped, done }

String _statusWire(OfflineStatus s) => switch (s) {
      OfflineStatus.active => 'active',
      OfflineStatus.paused => 'paused',
      OfflineStatus.stopped => 'stopped',
      OfflineStatus.done => 'done',
    };

/// 舊 manifest 無 `st` 欄位 → 依完成度推斷（全完成當 done，未完成當 active 以便自動續傳修復卡死書）。
OfflineStatus _statusFromWire(String? w, {required bool complete}) {
  switch (w) {
    case 'active':
      return OfflineStatus.active;
    case 'paused':
      return OfflineStatus.paused;
    case 'stopped':
      return OfflineStatus.stopped;
    case 'done':
      return OfflineStatus.done;
  }
  return complete ? OfflineStatus.done : OfflineStatus.active;
}

/// 一本已下載小說的清單。
class OfflineManifest {
  OfflineManifest({
    required this.novelId,
    required this.title,
    required this.coverUrl,
    required this.chapters,
    required this.updatedAt,
    this.status = OfflineStatus.active,
  });
  final String novelId;
  final String title;
  final String? coverUrl;
  final List<OfflineChapterMeta> chapters;
  final int updatedAt;
  final OfflineStatus status;

  int get okCount => chapters.where((c) => c.ok).length;

  Map<String, dynamic> toJson() => {
        'id': novelId,
        't': title,
        'cv': coverUrl,
        'ts': updatedAt,
        'st': _statusWire(status),
        'ch': chapters.map((c) => c.toJson()).toList(),
      };
  static OfflineManifest fromJson(Map<String, dynamic> m) {
    final chapters = (m['ch'] as List? ?? const [])
        .map((e) => OfflineChapterMeta.fromJson(e as Map<String, dynamic>))
        .toList();
    final ok = chapters.where((c) => c.ok).length;
    final complete = chapters.isNotEmpty && ok >= chapters.length;
    return OfflineManifest(
      novelId: m['id'] as String,
      title: m['t'] as String? ?? '',
      coverUrl: m['cv'] as String?,
      updatedAt: m['ts'] as int? ?? 0,
      status: _statusFromWire(m['st'] as String?, complete: complete),
      chapters: chapters,
    );
  }
}

enum DlStatus { queued, running, paused, done, error }

class DownloadTask {
  DownloadTask(this.novelId, this.title, this.total);
  final String novelId;
  final String title;
  final int total;
  int done = 0;
  int failed = 0;
  String current = '';
  DlStatus status = DlStatus.queued;

  double get progress => total == 0 ? 0 : (done + failed) / total;
}

class _Job {
  _Job(this.novelId, this.title, this.coverUrl, this.chapters);
  final String novelId;
  final String title;
  final String? coverUrl;
  final List<Chapter> chapters;
}

/// 離線下載與儲存。渲染擷取章節文字 + 下載插圖至本機（相對路徑存 JSON，讀取時重組絕對路徑）。
class OfflineStore extends ChangeNotifier {
  OfflineStore._();
  static final OfflineStore instance = OfflineStore._();

  Directory? _root;
  final Map<String, OfflineManifest> _manifests = {};
  final Map<String, DownloadTask> _tasks = {};
  final List<_Job> _queue = [];
  bool _busy = false;

  /// 協作式中斷訊號：novelId → 'pause' | 'stop'。`_run` 於每章邊界檢查後生效。
  final Map<String, String> _control = {};

  /// 佇列中（尚未開跑、無 manifest）被暫停的新書 _Job，保留以便「繼續」時放回佇列續傳。
  final Map<String, _Job> _pausedJobs = {};

  /// 刪除中的書：`_run` 見到即中止且不再寫檔（避免刪除競態把 manifest 復活）。
  final Set<String> _deleted = {};

  /// 進行中任務的待生效中斷（'pause'/'stop'）；供 UI 顯示「暫停中…/停止中…」即時回饋。
  /// running 任務的暫停/停止於下一章邊界才生效（當前章 WebView 擷取可能數秒），此期間有回饋。
  String? pendingControl(String novelId) =>
      _tasks[novelId]?.status == DlStatus.running ? _control[novelId] : null;

  Future<void> init() async {
    final docs = await getApplicationDocumentsDirectory();
    _root = Directory('${docs.path}/offline');
    await _root!.create(recursive: true);
    for (final e in _root!.listSync()) {
      if (e is Directory) {
        final mf = File('${e.path}/manifest.json');
        if (mf.existsSync()) {
          try {
            final m = OfflineManifest.fromJson(
                jsonDecode(mf.readAsStringSync()) as Map<String, dynamic>);
            _manifests[m.novelId] = m;
          } catch (_) {}
        }
      }
    }
    _reconstructInterrupted();
    notifyListeners();
  }

  /// 重啟後重建未完成的下載任務：
  /// - active（上次被中斷）→ 排入佇列，首帧後自動續傳（WebView 擷取須待 App 起來）。
  /// - paused（使用者暫停）→ 重建暫停任務，等使用者手動繼續。
  void _reconstructInterrupted() {
    for (final m in _manifests.values) {
      if (m.chapters.isEmpty || m.okCount >= m.chapters.length) continue;
      if (m.status == OfflineStatus.active) {
        _tasks[m.novelId] = DownloadTask(m.novelId, m.title, m.chapters.length)
          ..done = m.okCount
          ..status = DlStatus.queued;
        _queue.add(_Job(m.novelId, m.title, m.coverUrl, chaptersFor(m.novelId)));
      } else if (m.status == OfflineStatus.paused) {
        _tasks[m.novelId] = DownloadTask(m.novelId, m.title, m.chapters.length)
          ..done = m.okCount
          ..status = DlStatus.paused;
      }
    }
    if (_queue.isNotEmpty) {
      // init() 在 runApp 前呼叫；延到首帧後再啟動 HeadlessInAppWebView 擷取。
      WidgetsBinding.instance.addPostFrameCallback((_) => _pump());
    }
  }

  // ---- 查詢 ----
  List<OfflineManifest> get novels =>
      _manifests.values.toList()..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  int get downloadedCount => _manifests.length;
  List<DownloadTask> get tasks =>
      _tasks.values.where((t) => t.status != DlStatus.done).toList();
  DownloadTask? taskFor(String id) => _tasks[id];
  bool hasNovel(String id) => _manifests.containsKey(id);

  bool hasChapter(String novelId, int index) =>
      _manifests[novelId]?.chapters.any((c) => c.index == index && c.ok) ?? false;

  OfflineManifest? manifest(String novelId) => _manifests[novelId];

  /// 由清單重建章節列表（供離線閱讀器使用；已下載章節走本機，未下載者保留原 URL 線上補抓）。
  List<Chapter> chaptersFor(String novelId) {
    final m = _manifests[novelId];
    if (m == null) return const [];
    final list = m.chapters.toList()..sort((a, b) => a.index.compareTo(b.index));
    return list
        .map((c) =>
            Chapter(title: c.title, url: c.url, vip: c.vip, volumeName: c.vol))
        .toList();
  }

  Future<List<ContentBlock>?> readChapter(String novelId, int index) async {
    if (_root == null) return null;
    final f = File('${_root!.path}/$novelId/ch_$index.json');
    if (!f.existsSync()) return null;
    try {
      final dir = '${_root!.path}/$novelId';
      final list = jsonDecode(await f.readAsString()) as List;
      return list.map<ContentBlock>((e) {
        final m = e as Map;
        if (m['t'] == 'i') return ContentBlock.image('$dir/${m['v']}');
        return ContentBlock.text(m['v']?.toString() ?? '');
      }).toList();
    } catch (_) {
      return null;
    }
  }

  static final RegExp _cidRe = RegExp(r'/novel/\d+/(\d+)(?:_\d+)?\.html');

  /// 依 (articleId, chapterId) 取回已下載章節內容（供新閱讀器內容管線的離線優先查找）。
  /// 以 manifest meta 的已解析 URL 對映 cid → `ch_{index}.json`；未下載/未命中回 null。
  /// 圖片為**本機絕對路徑**（渲染層以 Image.file 顯示；勿寫入 drift 快取）。
  Future<ChapterContent?> contentFor(int articleId, int chapterId) async {
    final m = _manifests['$articleId'];
    if (m == null) return null;
    for (final meta in m.chapters) {
      if (!meta.ok || meta.url == null) continue;
      final cid = _cidRe.firstMatch(meta.url!)?.group(1);
      if (cid == null || int.tryParse(cid) != chapterId) continue;
      final blocks = await readChapter(m.novelId, meta.index);
      if (blocks == null || blocks.isEmpty) return null;
      return ChapterContent(title: meta.title, blocks: blocks);
    }
    return null;
  }

  // ---- 下載控制 ----

  /// 開始/重下整本（詳情頁「下載」）。已有 manifest 者保留已完成章節、續傳未完成者（不重抓）。
  void enqueue(String novelId, String title, String? coverUrl,
      List<Chapter> chapters) {
    final existing = _tasks[novelId];
    if (existing != null &&
        (existing.status == DlStatus.running ||
            existing.status == DlStatus.queued)) {
      return; // 已在佇列/下載中
    }
    _control.remove(novelId);
    _deleted.remove(novelId);
    // 一律嘗試抓取所有章節（含被標 vip / 壞連結者；不預先排除）。
    _startJob(novelId, title, coverUrl, chapters, _manifests[novelId]?.okCount ?? 0);
  }

  /// 繼續一個已暫停/中斷的下載。優先放回「佇列中暫停」保留的 _Job（新書無 manifest 也能續）；
  /// 否則由 manifest 重建章節清單，跳過已完成者。
  void resumeDownload(String novelId) {
    final existing = _tasks[novelId];
    if (existing != null &&
        (existing.status == DlStatus.running ||
            existing.status == DlStatus.queued)) {
      return;
    }
    _control.remove(novelId);
    _deleted.remove(novelId);
    // 佇列中暫停的新書：把保留的 _Job 放回佇列（修正「新書暫停後按繼續無反應」）。
    final paused = _pausedJobs.remove(novelId);
    if (paused != null) {
      _tasks[novelId] =
          DownloadTask(novelId, paused.title, paused.chapters.length)
            ..done = _manifests[novelId]?.okCount ?? 0
            ..status = DlStatus.queued;
      _queue.add(paused);
      notifyListeners();
      _pump();
      return;
    }
    final m = _manifests[novelId];
    if (m == null) return;
    _startJob(novelId, m.title, m.coverUrl, chaptersFor(novelId), m.okCount);
  }

  /// 暫停：running → 於下一章邊界停下（當前章完成後；停止指令優先，不覆蓋）；
  /// queued → 立即移出佇列並**保留 _Job** 以便續傳。
  void pauseDownload(String novelId) {
    final task = _tasks[novelId];
    if (task == null) return;
    if (task.status == DlStatus.running) {
      if (_control[novelId] == 'stop') return; // 停止優先：不被暫停覆蓋
      _control[novelId] = 'pause';
      notifyListeners(); // 即時回饋（UI 顯示「暫停中…」）
    } else if (task.status == DlStatus.queued) {
      final idx = _queue.indexWhere((j) => j.novelId == novelId);
      if (idx >= 0) _pausedJobs[novelId] = _queue.removeAt(idx); // 保留 _Job
      task.status = DlStatus.paused;
      _persistStatus(novelId, OfflineStatus.paused);
      notifyListeners();
    }
  }

  /// 停止：終止此下載但**保留已下載章節**為離線書（欲整本移除用 [deleteNovel]）。
  void stopDownload(String novelId) {
    final task = _tasks[novelId];
    if (task == null) return;
    if (task.status == DlStatus.running) {
      _control[novelId] = 'stop'; // 覆蓋任何 pending pause（停止優先）；_run 邊界收尾
      notifyListeners(); // 即時回饋（UI 顯示「停止中…」）
    } else {
      _queue.removeWhere((j) => j.novelId == novelId);
      _pausedJobs.remove(novelId);
      _tasks.remove(novelId);
      _persistStatus(novelId, OfflineStatus.stopped);
      notifyListeners();
    }
  }

  void _startJob(String novelId, String title, String? coverUrl,
      List<Chapter> chapters, int initialDone) {
    _tasks[novelId] = DownloadTask(novelId, title, chapters.length)
      ..done = initialDone;
    _queue.add(_Job(novelId, title, coverUrl, chapters));
    notifyListeners();
    _pump();
  }

  /// 只改寫 manifest 的下載狀態（保留章節與內容檔）；供暫停/停止未在跑的任務落盤。
  Future<void> _persistStatus(String novelId, OfflineStatus st) async {
    final m = _manifests[novelId];
    if (m == null || _root == null) return;
    final updated = OfflineManifest(
      novelId: m.novelId,
      title: m.title,
      coverUrl: m.coverUrl,
      chapters: m.chapters,
      updatedAt: m.updatedAt,
      status: st,
    );
    _manifests[novelId] = updated;
    try {
      await File('${_root!.path}/$novelId/manifest.json')
          .writeAsString(jsonEncode(updated.toJson()));
    } catch (_) {}
  }

  Future<void> _pump() async {
    if (_busy) return;
    _busy = true;
    try {
      while (_queue.isNotEmpty) {
        await _run(_queue.removeAt(0));
      }
    } finally {
      _busy = false;
    }
  }

  Future<void> _run(_Job job) async {
    final task = _tasks[job.novelId];
    if (task == null || _root == null) return;
    if (_deleted.contains(job.novelId)) return;
    task.status = DlStatus.running;
    notifyListeners();

    final dir = Directory('${_root!.path}/${job.novelId}');
    await dir.create(recursive: true);
    final imgDir = Directory('${dir.path}/img');
    await imgDir.create(recursive: true);

    final dio = ApiClient.instance.dio;
    final cookie = AuthController.instance.session?.cookieHeader ?? 'night=0';
    final manifestFile = File('${dir.path}/manifest.json');

    // 合併既有 manifest：保留已完成章節的 ok/url → 續傳與重下都跳過已抓者。
    final existing = _manifests[job.novelId];
    final metas = List<OfflineChapterMeta>.generate(job.chapters.length, (i) {
      final ch = job.chapters[i];
      OfflineChapterMeta? prior;
      if (existing != null) {
        for (final p in existing.chapters) {
          if (p.index == i) {
            prior = p;
            break;
          }
        }
      }
      if (prior != null && prior.ok) return prior; // 已完成 → 保留，不重抓
      return OfflineChapterMeta(i, ch.title, false, ch.url, ch.vip,
          vol: ch.volumeName);
    });
    task.done = metas.where((m) => m.ok).length;
    task.failed = 0;

    Future<void> persist(OfflineStatus st) async {
      if (_deleted.contains(job.novelId)) return; // 刪除中不復活 manifest
      final manifest = OfflineManifest(
        novelId: job.novelId,
        title: job.title,
        coverUrl: job.coverUrl,
        chapters: metas,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        status: st,
      );
      await manifestFile.writeAsString(jsonEncode(manifest.toJson()));
      _manifests[job.novelId] = manifest;
    }

    await persist(OfflineStatus.active); // 立即建立/更新清單，離線書庫馬上看得到

    for (int i = 0; i < job.chapters.length; i++) {
      // 協作式中斷於每章邊界生效（保單章原子；不中斷進行中的章，不浪費已抓內容）。
      if (_deleted.contains(job.novelId)) return;
      final ctrl = _control[job.novelId];
      if (ctrl == 'pause') {
        _control.remove(job.novelId);
        task.status = DlStatus.paused;
        await persist(OfflineStatus.paused);
        notifyListeners();
        return;
      }
      if (ctrl == 'stop') {
        _control.remove(job.novelId);
        await persist(OfflineStatus.stopped);
        _tasks.remove(job.novelId); // 移出「下載中」；已下載章節留在離線書庫
        notifyListeners();
        return;
      }
      if (metas[i].ok) continue; // 續傳：已完成章節跳過

      final ch = job.chapters[i];
      task.current = ch.title;
      notifyListeners();
      try {
        // 不預先信任 vip 標記、不跳過壞連結 → 一律嘗試。
        // url==null（站方目錄 javascript:cid 假連結）先沿閱讀鏈解析真實 URL。
        final url = ch.url ??
            await LinovelibApi.instance.resolveBrokenChapterUrl(job.chapters, i);
        if (url == null) throw Exception('unresolved-url');
        final content = await ChapterExtractor().load(url);
        if (content.blocks.isEmpty) throw Exception('empty-content');
        final out = <Map<String, String>>[];
        int imgN = 0;
        for (final b in content.blocks) {
          if (b.isImage && b.image != null) {
            try {
              final resp = await dio.get<List<int>>(
                b.image!,
                options: Options(responseType: ResponseType.bytes, headers: {
                  'Referer': AppConfig.origin,
                  'User-Agent': AppConfig.userAgent,
                  'Cookie': cookie,
                }),
              );
              final ext = b.image!.toLowerCase().contains('.png') ? 'png' : 'jpg';
              final fname = 'c${i}_${imgN++}.$ext';
              await File('${imgDir.path}/$fname').writeAsBytes(resp.data!);
              out.add({'t': 'i', 'v': 'img/$fname'});
            } catch (_) {
              // 圖片失敗則略過該圖
            }
          } else if (b.html != null) {
            // 存原始 HTML（保留富文本標籤）；舊檔存的是純文字，讀回時亦為有效輸入。
            out.add({'t': 'p', 'v': b.html!});
          }
        }
        if (_deleted.contains(job.novelId)) return;
        await File('${dir.path}/ch_$i.json').writeAsString(jsonEncode(out));
        metas[i] =
            OfflineChapterMeta(i, ch.title, true, url, ch.vip, vol: ch.volumeName);
        task.done++;
      } catch (_) {
        task.failed++;
      }
      await persist(OfflineStatus.active);
      notifyListeners();
    }

    // 一章都沒成功（整本失敗）→ 標 error 保留於任務列可重試，不靜默當 done 消失、
    // 不在離線書庫留一本 0 章空書（M10）。
    if (task.done == 0 && task.total > 0) {
      task.status = DlStatus.error;
      await persist(OfflineStatus.paused); // 保留可續傳狀態（非 done）
    } else {
      task.status = DlStatus.done;
      await persist(OfflineStatus.done);
    }
    notifyListeners();
  }

  Future<void> deleteNovel(String novelId) async {
    if (_root == null) return;
    // 先標記刪除：進行中的 _run 見到即中止且不再寫檔（避免刪後 persist 復活 manifest）。
    _deleted.add(novelId);
    _control.remove(novelId);
    _queue.removeWhere((j) => j.novelId == novelId);
    _manifests.remove(novelId);
    _tasks.remove(novelId);
    notifyListeners();
    final dir = Directory('${_root!.path}/$novelId');
    if (dir.existsSync()) {
      try {
        await dir.delete(recursive: true);
      } catch (_) {}
    }
  }
}
