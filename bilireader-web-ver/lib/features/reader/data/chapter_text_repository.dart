// 私有注入依賴以具名參數傳入，只能用 `: _x = x`（Dart 不允許 `this._x` 具名形參）；
// prefer_initializing_formals 對此為誤報。與 api-ver ChapterTextRepositoryImpl 同一慣用法。
// ignore_for_file: prefer_initializing_formals
import 'dart:convert';

import '../../../core/storage/database/app_database.dart';
import '../content_block.dart';
import '../domain/chapter_text.dart';
import 'chapter_content_source.dart';
import 'chapter_text_assembler.dart';

/// 章節無法取得（多為 VIP 鎖章 / 空章 / 擷取失敗）。**不寫入快取**，由展示層提示登入或重試。
class ChapterUnavailableException implements Exception {
  const ChapterUnavailableException(
    this.articleId,
    this.chapterId, [
    this.reason = 'empty',
  ]);

  final int articleId;
  final int chapterId;
  final String reason;

  @override
  String toString() =>
      'ChapterUnavailableException($articleId:$chapterId, $reason)';
}

/// web 版章節正文倉儲。忠實對映 api-ver `ChapterTextRepositoryImpl`：
/// drift `ChapterContents` 永久快取優先（§7.5），未命中才用 [ChapterContentSource] 擷取並
/// 寫回；in-flight dedupe 合併同章並發。**快取存合成後整章 HTML**（OpenCC 不適用 tw 站）。
///
/// 與 api-ver 的差異（web 適配）：內容源為 WebView 擷取（需章節 [url]）而非 readpai
/// getNovelText；VIP/空章以 [hasRenderableContent] 偵測並拋 [ChapterUnavailableException]、
/// 不污染快取；回傳 [ChapterText]（切塊交由展示層的 `ReaderContentBuilder`），失敗以例外表達。
/// 離線下載內容查找（由組合根注入 `OfflineStore.contentFor`；測試可注入假函式）。
/// 回 null 表示該章未下載 → 走 drift 快取/線上擷取。
typedef OfflineChapterLookup =
    Future<ChapterContent?> Function(int articleId, int chapterId);

class ChapterTextRepository {
  ChapterTextRepository({
    required ChapterContentSource source,
    required ChapterCacheDao cacheDao,
    OfflineChapterLookup? offlineLookup,
    int Function()? clockMs,
  }) : _source = source,
       _cacheDao = cacheDao,
       _offlineLookup = offlineLookup,
       _clockMs = clockMs;

  final ChapterContentSource _source;
  final ChapterCacheDao _cacheDao;
  final OfflineChapterLookup? _offlineLookup;
  final int Function()? _clockMs;

  static const ChapterTextAssembler _assembler = ChapterTextAssembler();

  final Map<String, Future<ChapterText>> _inFlight =
      <String, Future<ChapterText>>{};

  /// 永久快取優先；未命中擷取（dedupe）並寫回。VIP/空章拋 [ChapterUnavailableException]。
  Future<ChapterText> getChapterText({
    required int articleId,
    required int chapterId,
    required String url,
    String chapterName = '',
  }) {
    final String key = '$articleId:$chapterId';
    final Future<ChapterText>? pending = _inFlight[key];
    if (pending != null) {
      return pending;
    }
    final Future<ChapterText> task = _load(
      articleId: articleId,
      chapterId: chapterId,
      url: url,
      chapterName: chapterName,
    );
    _inFlight[key] = task;
    return task.whenComplete(() => _inFlight.remove(key));
  }

  Future<bool> isCached({
    required int articleId,
    required int chapterId,
  }) async =>
      (await _cacheDao.getChapterContent(articleId, chapterId)) != null;

  Future<ChapterText> _load({
    required int articleId,
    required int chapterId,
    required String url,
    required String chapterName,
  }) async {
    // 0) 離線下載內容**最優先**（純本機、斷網可讀、圖片為本機路徑）。
    //    不寫 drift：本機絕對路徑不可持久化（iOS 容器路徑會變），且內容已在本機無需再快取。
    final ChapterContent? offline = await _offlineLookup?.call(
      articleId,
      chapterId,
    );
    if (offline != null && hasRenderableContent(offline)) {
      return _assembler.assemble(
        articleId: articleId,
        chapterId: chapterId,
        chapterName: chapterName,
        content: offline,
      );
    }
    // 1) drift 永久快取。
    final ChapterContentRow? row = await _cacheDao.getChapterContent(
      articleId,
      chapterId,
    );
    if (row != null) {
      return _decode(articleId, chapterId, row.payload);
    }
    final ChapterContent content = await _source.load(url);
    if (!hasRenderableContent(content)) {
      throw ChapterUnavailableException(articleId, chapterId);
    }
    final ChapterText text = _assembler.assemble(
      articleId: articleId,
      chapterId: chapterId,
      chapterName: chapterName,
      content: content,
    );
    await _cacheDao.saveChapterContent(
      articleId: articleId,
      chapterId: chapterId,
      payload: _encode(text),
      updatedAt: _now(),
    );
    return text;
  }

  String _encode(ChapterText t) => jsonEncode(<String, dynamic>{
    'name': t.chapterName,
    'text': t.text,
    'images': t.images
        .map(
          (ChapterImage i) =>
              <String, dynamic>{'u': i.url, 'a': i.aspectRatio},
        )
        .toList(),
    'isImage': t.isImage,
    'isbody': t.isbody,
  });

  ChapterText _decode(int articleId, int chapterId, String payload) {
    final Map<String, dynamic> j =
        jsonDecode(payload) as Map<String, dynamic>;
    return ChapterText(
      articleId: articleId,
      chapterId: chapterId,
      chapterName: j['name'] as String? ?? '',
      text: j['text'] as String? ?? '',
      images: (j['images'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic e) {
            final Map<String, dynamic> m = e as Map<String, dynamic>;
            return ChapterImage(
              url: m['u'] as String? ?? '',
              aspectRatio: (m['a'] as num?)?.toDouble() ?? 0.0,
            );
          })
          .toList(),
      isImage: j['isImage'] as bool? ?? false,
      isbody: j['isbody'] as int? ?? 0,
    );
  }

  int _now() => _clockMs?.call() ?? DateTime.now().millisecondsSinceEpoch;
}
