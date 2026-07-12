import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/offline/offline_store.dart';
import '../../../core/storage/database/database_providers.dart';
import 'chapter_content_source.dart';
import 'chapter_text_repository.dart';

part 'chapter_text_providers.g.dart';

/// 章節內容來源（正式：WebView 擷取）。測試可 override 為假來源。
/// 對應 api-ver `chapterTextRemoteDataSourceProvider`。
@Riverpod(keepAlive: true)
ChapterContentSource chapterContentSource(Ref ref) =>
    const WebViewChapterContentSource();

/// 章節正文倉儲：**離線下載優先** → drift 快取 → WebView 擷取寫回 + VIP 偵測。
/// 對應 api-ver `chapterTextRepositoryProvider`（web 適配：離線層接 OfflineStore）。
@Riverpod(keepAlive: true)
ChapterTextRepository chapterTextRepository(Ref ref) => ChapterTextRepository(
  source: ref.watch(chapterContentSourceProvider),
  cacheDao: ref.watch(chapterCacheDaoProvider),
  offlineLookup: (int articleId, int chapterId) =>
      OfflineStore.instance.contentFor(articleId, chapterId),
);
