import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common_widgets/app_badge.dart';
import '../../../core/common_widgets/bili_empty_view.dart';
import '../../../core/common_widgets/bili_error_view.dart';
import '../../../core/common_widgets/bili_loading_view.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/text/text_providers.dart';
import '../../../core/text/tw_error.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../domain/novel_catalog.dart';
import 'novel_detail_providers.dart';

/// 章節目錄頁（doc 09 §6.3、design Row3）。卷為分組標頭、章為清單列；
/// VIP 章顯示膠囊。點章導向閱讀器（Phase 5 建置；目前為佔位頁）。
class CatalogPage extends ConsumerWidget {
  const CatalogPage({
    required this.articleId,
    this.currentChapterId = 0,
    super.key,
  });

  final int articleId;

  /// 由閱讀器開啟時傳入目前閱讀章，於該列標「閱讀中」（設計 `.chr-on`）。0 = 不標。
  final int currentChapterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<NovelCatalog> state = ref.watch(
      novelCatalogProvider(articleId),
    );
    Future<void> refresh() async {
      ref.invalidate(novelCatalogProvider(articleId));
      await ref.read(novelCatalogProvider(articleId).future);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('目錄')),
      // F-14：下拉刷新期間/失敗時保留已載目錄（skipLoadingOnReload + skipError →
      // 不閃 loading/錯誤頁、不掉捲動；不變量#1）。
      body: state.when(
        skipLoadingOnReload: true,
        skipError: true,
        loading: () => const BiliLoadingView(),
        error: (Object e, StackTrace _) => BiliErrorView(
          message: twErrorMessage(ref.read(chineseConverterProvider), e),
          onRetry: () => ref.invalidate(novelCatalogProvider(articleId)),
        ),
        data: (NovelCatalog catalog) {
          if (catalog.volumes.isEmpty) {
            // F-24：統一空狀態；包在可捲動容器讓下拉刷新可用。
            return RefreshIndicator(
              color: AppColors.acc,
              backgroundColor: AppColors.surf,
              onRefresh: refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const <Widget>[
                  SizedBox(height: 120),
                  BiliEmptyView(message: '暫無章節'),
                ],
              ),
            );
          }
          return RefreshIndicator(
            color: AppColors.acc,
            backgroundColor: AppColors.surf,
            onRefresh: refresh,
            child: _CatalogList(
              catalog: catalog,
              currentChapterId: currentChapterId,
            ),
          );
        },
      ),
    );
  }
}

class _CatalogList extends StatelessWidget {
  const _CatalogList({required this.catalog, this.currentChapterId = 0});

  final NovelCatalog catalog;
  final int currentChapterId;

  @override
  Widget build(BuildContext context) {
    // 攤平為 [卷標頭, 章, 章, ..., 卷標頭, ...] 的線性項目清單；章號於卷內從 1 起。
    final List<_Row> rows = <_Row>[];
    for (final CatalogVolume v in catalog.volumes) {
      if ((v.title ?? '').isNotEmpty) {
        rows.add(_Row.volume(v.title!));
      }
      int n = 0;
      for (final CatalogChapter c in v.chapters) {
        rows.add(_Row.chapter(c, ++n));
      }
    }

    return Column(
      children: <Widget>[
        _summaryHeader(),
        const Divider(height: 1, color: AppColors.line),
        Expanded(
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: rows.length,
            itemBuilder: (BuildContext context, int i) {
              final _Row row = rows[i];
              return row.chapter == null
                  ? _VolumeHeader(title: row.volumeTitle!)
                  : _ChapterTile(
                      articleId: catalog.articleId,
                      number: row.number,
                      chapter: row.chapter!,
                      current:
                          currentChapterId != 0 &&
                          row.chapter!.chapterId == currentChapterId,
                    );
            },
          ),
        ),
      ],
    );
  }

  Widget _summaryHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screen),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(catalog.articleName ?? '', style: AppTypography.titleMedium),
          const SizedBox(height: 4),
          Text(
            '共 ${catalog.chapterCount} 章',
            style: AppTypography.bodySmall.copyWith(color: AppColors.mut),
          ),
        ],
      ),
    );
  }
}

/// 卷標頭（設計稿 `.vol`：等寬字、mut 色、surf 底、字距，非金色）。
class _VolumeHeader extends StatelessWidget {
  const _VolumeHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.surf,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screen,
      ).copyWith(top: 9, bottom: 9),
      child: Text(
        title,
        style: AppTypography.mono.copyWith(
          color: AppColors.mut,
          fontSize: 11,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

/// 章節列（設計稿 `.chr`）：章號 `.cn`（等寬 mut 寬 24）+ 章名 `.ct` + VIP 膠囊 `.vlk`。
class _ChapterTile extends StatelessWidget {
  const _ChapterTile({
    required this.articleId,
    required this.number,
    required this.chapter,
    this.current = false,
  });

  final int articleId;
  final int number;
  final CatalogChapter chapter;

  /// 目前閱讀章（設計 `.chr-on`）：章名 acc、列尾標「閱讀中」。
  final bool current;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: current ? AppColors.accFill : null,
        border: const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: InkWell(
        onTap: () => context.pushNamed(
          AppRoutes.readerName,
          pathParameters: <String, String>{'articleId': '$articleId'},
          queryParameters: <String, String>{
            'chapterId': '${chapter.chapterId}',
          },
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screen,
          ).copyWith(top: 13, bottom: 13),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 24,
                child: Text(
                  number.toString().padLeft(2, '0'),
                  style: AppTypography.mono.copyWith(
                    color: current ? AppColors.acc : AppColors.mut,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  chapter.title ?? '未命名章節',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: current
                      ? AppTypography.bodyMedium.copyWith(
                          color: AppColors.acc,
                          fontWeight: FontWeight.w600,
                        )
                      : AppTypography.bodyMedium,
                ),
              ),
              if (current) ...<Widget>[
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '閱讀中',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.acc,
                    fontSize: 10,
                  ),
                ),
              ] else if (chapter.isVip) ...<Widget>[
                const SizedBox(width: AppSpacing.sm),
                const AppBadge(label: 'VIP', variant: AppBadgeVariant.outline),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 目錄線性項目：卷標頭或章（含卷內章號）。
class _Row {
  const _Row.volume(String title)
    : volumeTitle = title,
      chapter = null,
      number = 0;
  const _Row.chapter(this.chapter, this.number) : volumeTitle = null;

  final String? volumeTitle;
  final CatalogChapter? chapter;
  final int number;
}
