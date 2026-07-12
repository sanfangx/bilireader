import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/models/catalog.dart';
import '../../core/network/linovelib_api.dart';
import '../../core/storage/database/database_providers.dart';

part 'catalog_providers.g.dart';

/// 目錄 **cache-first**：drift `ChapterCatalogs` 有值先回（章節目錄不常變、手動下拉才刷）；
/// 未命中才打網路並寫回。曾快取者斷網也能離線瀏覽目錄（尤其已下載書）。
///
/// 強制重整：呼叫端 `deleteCatalog(articleId)` + `ref.invalidate` → 重跑即 cache miss 走網路。
@riverpod
Future<Catalog> novelCatalog(Ref ref, String novelId) async {
  final int articleId = int.tryParse(novelId) ?? 0;
  final dao = ref.watch(chapterCacheDaoProvider);

  if (articleId > 0) {
    final row = await dao.getCatalog(articleId);
    if (row != null) {
      try {
        return Catalog.fromJson(
          jsonDecode(row.payload) as Map<String, dynamic>,
        );
      } catch (_) {
        // 壞快取 → 落到網路重抓。
      }
    }
  }

  final Catalog cat = await LinovelibApi.instance.catalog(novelId);
  if (articleId > 0 && cat.volumes.isNotEmpty) {
    await dao.saveCatalog(
      articleId: articleId,
      articleName: '',
      payload: jsonEncode(cat.toJson()),
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
  }
  return cat;
}
