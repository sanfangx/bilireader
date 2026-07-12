import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/router/auth_controller.dart';
import '../data/discover_providers.dart';
import '../domain/novel_catalog.dart';
import '../domain/novel_summary.dart';

part 'novel_detail_providers.g.dart';

/// 詳情 / 目錄端點（`getNovelInfo`、`getchapter`）**需登入**（實測未登入回 401）。
/// 未登入時直接以 unauthorized 錯誤短路，不發網路請求——避免 401 觸發登入態刷新、
/// 頁面重建、再發請求的無限迴圈（規範 §6.3：重試需有上限，不得無限 retry）。
void _requireLogin(Ref ref) {
  if (!ref.watch(authControllerProvider).isLoggedIn) {
    throw ErrorMapper.fromBusinessCode(code: ApiConstants.codeTokenInvalid);
  }
}

/// 小說詳情（`novel/getNovelInfo`，計瀏覽）。失敗以 `AsyncError(AppError)` 呈現。
@riverpod
Future<NovelSummary> novelDetail(Ref ref, int articleId) async {
  _requireLogin(ref);
  return (await ref.watch(bookRepositoryProvider).novelDetail(articleId))
      .dataOrThrow();
}

/// 也在看推薦（`novel/alsoReading`）。獨立 provider，失敗不影響主詳情。
@riverpod
Future<List<NovelSummary>> alsoReading(Ref ref, int articleId) async {
  _requireLogin(ref);
  return (await ref.watch(bookRepositoryProvider).alsoReading(articleId))
      .dataOrThrow();
}

/// 章節目錄（`novel/getchapter`，永久快取優先，需登入）。
@riverpod
Future<NovelCatalog> novelCatalog(Ref ref, int articleId) async {
  _requireLogin(ref);
  return (await ref.watch(catalogRepositoryProvider).catalog(articleId))
      .dataOrThrow();
}
