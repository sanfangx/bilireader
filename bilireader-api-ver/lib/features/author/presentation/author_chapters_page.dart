import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common_widgets/bili_error_view.dart';
import '../../../core/common_widgets/bili_loading_view.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/text/text_providers.dart';
import '../../../core/text/tw_error.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../domain/author_entities.dart';
import 'author_controllers.dart';

/// 作品章節管理（「管理」入口）。以設計 `.vol` 卷帶 + 章節列呈現 `author/chapter/tree`，
/// 點章節開章節編輯器；每卷底部可新增章節。設計稿僅明確定義作者專區與編輯器兩畫面，
/// 本頁為兩者間的連接，沿用既有設計基元（§5.1 不自創新樣式）。
class AuthorChaptersPage extends ConsumerWidget {
  const AuthorChaptersPage({required this.articleId, this.title, super.key});

  final int articleId;
  final String? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AuthorChapterTree> tree = ref.watch(
      authorChapterTreeProvider(articleId),
    );
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text((title ?? '').isEmpty ? '章節管理' : title!)),
      body: RefreshIndicator(
        color: AppColors.acc,
        backgroundColor: AppColors.surf,
        onRefresh: () async {
          ref.invalidate(authorChapterTreeProvider(articleId));
          await ref.read(authorChapterTreeProvider(articleId).future);
        },
        child: tree.when(
          loading: () => const BiliLoadingView(message: '載入章節'),
          error: (Object e, StackTrace _) => BiliErrorView(
            message: twErrorMessage(ref.read(chineseConverterProvider), e),
            onRetry: () => ref.invalidate(authorChapterTreeProvider(articleId)),
          ),
          data: (AuthorChapterTree t) => t.flat.isEmpty
              ? const _Empty()
              : ListView(
                  children: <Widget>[
                    for (final AuthorVolumeChapters v in t.grouped) ...<Widget>[
                      _VolumeBand(name: v.volumeName, count: v.chapters.length),
                      for (final AuthorChapter c in v.chapters)
                        _ChapterRow(articleId: articleId, chapter: c),
                      _NewChapterRow(
                        articleId: articleId,
                        volumeId: v.volumeId,
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}

/// `.vol`：卷帶（surf 底、mono、大寫、字距）。
class _VolumeBand extends StatelessWidget {
  const _VolumeBand({required this.name, required this.count});

  final String name;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.surf,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screen,
        vertical: 9,
      ),
      child: Text(
        '${name.isEmpty ? '未分卷' : name} · $count 章',
        style: AppTypography.mono.copyWith(
          fontSize: 10,
          letterSpacing: 1,
          color: AppColors.mut,
        ),
      ),
    );
  }
}

/// 章節列：章名 + 字數 + chevron；點擊開編輯器（既有章節）。
class _ChapterRow extends StatelessWidget {
  const _ChapterRow({required this.articleId, required this.chapter});

  final int articleId;
  final AuthorChapter chapter;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(
        AppRoutes.chapterEditorName,
        pathParameters: <String, String>{'articleId': '$articleId'},
        queryParameters: <String, String>{
          'chapterId': '${chapter.chapterId}',
          'volumeId': '${chapter.volumeId}',
          'name': chapter.chapterName,
        },
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screen,
          vertical: 14,
        ),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                chapter.chapterName.isEmpty ? '未命名章節' : chapter.chapterName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                // 章節名為內容標題 → serif（與編輯器章名一致）。
                style: AppTypography.bodyMedium.copyWith(
                  fontFamily: AppTypography.fontSerif,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${chapter.words} 字',
              style: AppTypography.mono.copyWith(
                fontSize: 10,
                color: AppColors.mut,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.mut),
          ],
        ),
      ),
    );
  }
}

/// 卷末「＋ 新章節」列 → 開編輯器（新章節，帶目標卷）。
class _NewChapterRow extends StatelessWidget {
  const _NewChapterRow({required this.articleId, required this.volumeId});

  final int articleId;
  final int volumeId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(
        AppRoutes.chapterEditorName,
        pathParameters: <String, String>{'articleId': '$articleId'},
        queryParameters: <String, String>{'volumeId': '$volumeId'},
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screen,
          vertical: 12,
        ),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: <Widget>[
            const Icon(Icons.add, size: 16, color: AppColors.acc),
            const SizedBox(width: 6),
            Text(
              '新章節',
              style: AppTypography.bodySmall.copyWith(
                fontSize: 12,
                color: AppColors.acc,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 80),
      child: Column(
        children: <Widget>[
          Icon(Icons.article_outlined, color: AppColors.mut, size: 44),
          SizedBox(height: AppSpacing.md),
          Center(child: Text('尚無章節', style: AppTypography.titleMedium)),
        ],
      ),
    );
  }
}
