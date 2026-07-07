import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common_widgets/app_badge.dart';
import '../../../core/common_widgets/bili_error_view.dart';
import '../../../core/common_widgets/bili_loading_view.dart';
import '../../../core/common_widgets/book_cover.dart';
import '../../../core/network/api_result.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/router/auth_controller.dart';
import '../../../core/text/text_providers.dart';
import '../../../core/text/tw_error.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../bookshelf/data/bookshelf_providers.dart';
import '../../bookshelf/domain/bookcase_repository.dart';
import '../../bookshelf/presentation/bookshelf_controllers.dart';
import '../../interaction/presentation/gift_sheet.dart';
import '../../interaction/presentation/rating_sheet.dart';
import '../../interaction/presentation/vote_sheet.dart';
import '../../reader/domain/reading_progress.dart';
import '../../reader/reading_progress_providers.dart';
import '../domain/novel_catalog.dart';
import '../domain/novel_summary.dart';
import 'novel_detail_providers.dart';
import 'widgets/novel_card.dart';
import 'widgets/section_header.dart';

/// 書籍詳情頁（doc 09 §5、design Row3）。書頭 + 統計 + 簡介 + 也在看 + 底部目錄入口。
/// 加入書架（`bookcase/check`+`bookcase/add`）與評分 / 送花 / 投票（feature ④）已接上。
class NovelDetailPage extends ConsumerWidget {
  const NovelDetailPage({required this.articleId, super.key});

  final int articleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<NovelSummary> detail = ref.watch(
      novelDetailProvider(articleId),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('書籍詳情')),
      // F-14：下拉刷新詳情；skipLoadingOnReload + skipError 保留已載內容於重抓期間/失敗，
      // 不閃 loading/錯誤頁（不變量#1）。
      body: detail.when(
        skipLoadingOnReload: true,
        skipError: true,
        loading: () => const BiliLoadingView(message: '載入中'),
        error: (Object e, StackTrace _) => BiliErrorView(
          message: twErrorMessage(ref.read(chineseConverterProvider), e),
          onRetry: () => ref.invalidate(novelDetailProvider(articleId)),
        ),
        data: (NovelSummary novel) => RefreshIndicator(
          color: AppColors.acc,
          backgroundColor: AppColors.surf,
          onRefresh: () async {
            ref.invalidate(novelDetailProvider(articleId));
            await ref.read(novelDetailProvider(articleId).future);
          },
          child: _DetailBody(novel: novel),
        ),
      ),
      // 設計稿 .dtbar：開始閱讀 .pri（主）+ ＋書架 .sec（次）。
      // 開始閱讀 → 直達閱讀器（有本機進度→續讀該章；無→首章）；閱讀器內再依 ReaderAnchor
      // 還原章內位置（§5.5）。＋書架 → `bookcase/check` 後 `bookcase/add`（feature ④）。
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(18, 12, 18, 22),
        child: Row(
          children: <Widget>[
            _AddToShelfButton(articleId: articleId),
            const SizedBox(width: 10),
            _PrimaryAction(
              label: '開始閱讀',
              onTap: () => _startReading(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  /// 開始閱讀：解析要開的章節——有本機閱讀進度則續讀該章，否則取目錄首章；
  /// 皆無法解析（目錄錯誤）時退回目錄挑章。閱讀器內再依 `ReaderAnchor` 還原章內位置。
  Future<void> _startReading(BuildContext context, WidgetRef ref) async {
    int? chapterId;
    try {
      final int? uid = await ref.read(currentOwnerUidProvider.future);
      if (uid != null) {
        final ReadingProgress? p = await ref
            .read(readingProgressRepositoryProvider)
            .get(uid, articleId);
        chapterId = p?.anchor.chapterId;
      }
      chapterId ??= _firstChapterId(
        await ref.read(novelCatalogProvider(articleId).future),
      );
    } on Object {
      chapterId = null;
    }
    if (!context.mounted) return;
    // 已載入之詳情封面 → 帶入閱讀器，供本機進度存檔（書架「繼續閱讀」縮圖）。
    final String poster =
        ref.read(novelDetailProvider(articleId)).value?.coverUrl ?? '';
    if (chapterId != null) {
      unawaited(
        context.pushNamed(
          AppRoutes.readerName,
          pathParameters: <String, String>{'articleId': '$articleId'},
          queryParameters: <String, String>{
            'chapterId': '$chapterId',
            if (poster.isNotEmpty) 'poster': poster,
          },
        ),
      );
    } else {
      // 無法解析章節 → 退回目錄挑章。
      unawaited(
        context.pushNamed(
          AppRoutes.catalogName,
          pathParameters: <String, String>{'articleId': '$articleId'},
        ),
      );
    }
  }

  int? _firstChapterId(NovelCatalog c) {
    for (final CatalogVolume v in c.volumes) {
      if (v.chapters.isNotEmpty) return v.chapters.first.chapterId;
    }
    return null;
  }
}

/// 「＋ 書架」按鈕（F-01 + F-17）：`bookcase/check` → 未收藏才 `bookcase/add`；
/// 送出中 spinner + 停用不可連點（F-17）；成功後 `invalidate(bookshelfListProvider)`
/// 令書架列表自動同步（F-01，§6.2）。狀態變更端點（§7.0）僅由使用者主動觸發。
class _AddToShelfButton extends ConsumerStatefulWidget {
  const _AddToShelfButton({required this.articleId});

  final int articleId;

  @override
  ConsumerState<_AddToShelfButton> createState() => _AddToShelfButtonState();
}

class _AddToShelfButtonState extends ConsumerState<_AddToShelfButton> {
  bool _submitting = false;

  Future<void> _add() async {
    if (_submitting) {
      return;
    }
    if (!ref.read(authControllerProvider).isLoggedIn) {
      _toast('請先登入');
      return;
    }
    final NovelSummary? novel = ref
        .read(novelDetailProvider(widget.articleId))
        .value;
    if (novel == null) {
      _toast('請稍候，資料載入中');
      return;
    }
    setState(() => _submitting = true);
    try {
      final BookcaseRepository repo = ref.read(bookcaseRepositoryProvider);
      final ApiResult<bool> checked = await repo.check(widget.articleId);
      if (!mounted) {
        return;
      }
      if (checked is ApiSuccess<bool> && checked.data) {
        _toast('這本書已在書架中');
        return;
      }
      final ApiResult<String> added = await repo.add(
        articleId: widget.articleId,
        articleName: novel.title,
      );
      if (!mounted) {
        return;
      }
      switch (added) {
        case ApiSuccess<String>():
          // F-01：書架列表自動同步（比照移除/搬移已示範）。
          ref.invalidate(bookshelfListProvider);
          _toast('已加入書架');
        case ApiFailure<String>(:final error):
          _toast(twErrorMessage(ref.read(chineseConverterProvider), error));
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return _SecondaryAction(
      label: '＋ 書架',
      busy: _submitting,
      onTap: _submitting ? null : _add,
    );
  }
}

/// 主動作按鈕（設計稿 .pri：flex 2、高 46、radius 16、金底黑字）。
class _PrimaryAction extends StatelessWidget {
  const _PrimaryAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Material(
        color: AppColors.acc,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: InkWell(
          key: const Key('detail_read_button'),
          borderRadius: BorderRadius.circular(AppRadius.card),
          onTap: onTap,
          child: SizedBox(
            height: 46,
            child: Center(
              child: Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.btxt,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 詳情互動卡（設計稿 .dactc：flex 1、高 52、radius 14、surf、圖示+標籤）。
/// 評分 / 送花 / 推薦票，點擊開啟對應底部抽屜（feature ④）。
class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: AppColors.surf,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.button),
          onTap: onTap,
          child: SizedBox(
            height: 52,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(icon, color: AppColors.mut, size: 18),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.mut,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 次動作按鈕（設計稿 .sec：flex 1、高 46、radius 16、描邊）。
class _SecondaryAction extends StatelessWidget {
  const _SecondaryAction({
    required this.label,
    required this.onTap,
    this.busy = false,
  });

  final String label;

  /// null → 停用（送出中或不可點）。
  final VoidCallback? onTap;

  /// 送出中：顯示 spinner、停用點擊（F-17）。
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.line),
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.card),
          onTap: busy ? null : onTap,
          child: SizedBox(
            height: 46,
            child: Center(
              child: busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.acc,
                      ),
                    )
                  : Text(
                      label,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.txt,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 書友評論入口（doc 09 §5：書評自詳情頁進入）。點按進入書評列表（feature ⑤b）。
class _ReviewsEntry extends StatelessWidget {
  const _ReviewsEntry({required this.articleId});

  final int articleId;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surf,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: () => context.pushNamed(
          AppRoutes.bookReviewListName,
          pathParameters: <String, String>{'articleId': '$articleId'},
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: <Widget>[
              Icon(Icons.rate_review_outlined, size: 18, color: AppColors.acc),
              SizedBox(width: 10),
              Expanded(child: Text('書友評論', style: AppTypography.titleMedium)),
              Icon(Icons.chevron_right, size: 20, color: AppColors.mut),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailBody extends ConsumerWidget {
  const _DetailBody({required this.novel});

  final NovelSummary novel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.screen),
      children: <Widget>[
        _header(),
        const SizedBox(height: AppSpacing.lg),
        _stats(),
        const SizedBox(height: AppSpacing.md),
        // 設計稿 .dact：評分 / 送花 / 推薦票，點擊開啟對應底部抽屜（feature ④）。
        Row(
          children: <Widget>[
            _ActionCard(
              icon: Icons.star_border,
              label: '評分',
              onTap: () => showRatingSheet(context, articleId: novel.articleId),
            ),
            const SizedBox(width: 9),
            _ActionCard(
              icon: Icons.local_florist_outlined,
              label: '送花',
              onTap: () => showGiftSheet(context, articleId: novel.articleId),
            ),
            const SizedBox(width: 9),
            _ActionCard(
              icon: Icons.how_to_vote_outlined,
              label: '推薦票',
              onTap: () => showVoteSheet(context, articleId: novel.articleId),
            ),
          ],
        ),
        if ((novel.intro ?? '').isNotEmpty) ...<Widget>[
          const SizedBox(height: AppSpacing.lg),
          // 設計 `.dsec b` 用 var(--disp)：詳情區塊標題為 serif。
          Text(
            '簡介',
            style: AppTypography.titleMedium.copyWith(
              fontFamily: AppTypography.fontSerif,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(novel.intro!, style: AppTypography.bodyMedium),
        ],
        const SizedBox(height: AppSpacing.lg),
        _ReviewsEntry(articleId: novel.articleId),
        const SizedBox(height: AppSpacing.xl),
        _AlsoReadingSection(articleId: novel.articleId),
      ],
    );
  }

  Widget _header() {
    final String subtitle = <String>[
      if (novel.author != null && novel.author!.isNotEmpty)
        '作者：${novel.author}',
      if (novel.translator != null && novel.translator!.isNotEmpty)
        '譯者：${novel.translator}',
    ].join('   ');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 設計稿 .dtcov：100×142，radius 16。
        BookCover(
          url: novel.coverUrl,
          width: 100,
          height: 142,
          radius: AppRadius.card,
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                novel.title.isEmpty ? '未命名' : novel.title,
                // 設計 `.dtm h2` 用 var(--disp)：詳情書名為 serif。
                style: AppTypography.titleLarge.copyWith(
                  fontFamily: AppTypography.fontSerif,
                ),
              ),
              if (subtitle.isNotEmpty) ...<Widget>[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.mut),
                ),
              ],
              if (novel.tags.isNotEmpty) ...<Widget>[
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: <Widget>[
                    for (final String t in novel.tags.take(4))
                      AppBadge(label: t, variant: AppBadgeVariant.outline),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _stats() {
    // 設計稿 .dtstats：surf 底、radius 16、上下 padding 13。
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surf,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: <Widget>[
          _statCell(
            '評分',
            novel.ratingCount == 0 ? '暫無' : novel.rating.toStringAsFixed(1),
          ),
          _statCell('字數', _formatCount(novel.wordCount)),
          _statCell('狀態', novel.isFinished ? '完結' : '連載中'),
        ],
      ),
    );
  }

  Widget _statCell(String label, String value) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(
            value,
            // 設計 `.dst b` 用 'Space Grotesk'：數值統計（評分/字數）為 mono。
            style: AppTypography.mono.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.acc,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(color: AppColors.mut),
          ),
        ],
      ),
    );
  }

  /// 大數字以「萬」呈現（例：640000 → 64萬）。
  static String _formatCount(int n) {
    if (n <= 0) {
      return '—';
    }
    if (n < 10000) {
      return '$n';
    }
    final double w = n / 10000;
    return '${w % 1 == 0 ? w.toStringAsFixed(0) : w.toStringAsFixed(1)}萬';
  }
}

/// 也在看推薦（獨立 provider，失敗不影響主詳情）。
class _AlsoReadingSection extends ConsumerWidget {
  const _AlsoReadingSection({required this.articleId});

  final int articleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<NovelSummary>> state = ref.watch(
      alsoReadingProvider(articleId),
    );
    // F-28：次要區塊三態分明——資料空→不佔位；載入中→不佔位（skeleton 屬批 5 F-29）；
    // **失敗→顯示「載入失敗，點擊重試」而非靜默塌成空白**（使用者才能分辨「沒有 / 出錯」）。
    return state.when(
      loading: () => const SizedBox.shrink(),
      error: (Object e, StackTrace _) => Column(
        key: const Key('also_reading_error'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SectionHeader(title: '也在看'),
          _AlsoReadingRetry(
            onRetry: () => ref.invalidate(alsoReadingProvider(articleId)),
          ),
        ],
      ),
      data: (List<NovelSummary> items) {
        if (items.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SectionHeader(title: '也在看'),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              // 設計稿 .reco：寬 70、封面 70×98、書名 10 單行、無作者。
              // 封面 98.6 + 8 + 書名(10×1.5) ≈ 122，留緩衝防溢位。
              height: 134,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.md),
                itemBuilder: (BuildContext context, int i) => NovelCard(
                  novel: items[i],
                  width: 70,
                  titleSize: 10,
                  showAuthor: false,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// F-28：次要區塊失敗的淡色可重試列（比照 BiliErrorView 精簡版，設計稿無 `.reco`
/// 失敗態 → 採既有 token 預設）。44 命中區 + button 語意（F-12/F-13 一致）。
class _AlsoReadingRetry extends StatelessWidget {
  const _AlsoReadingRetry({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: InkWell(
        onTap: onRetry,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.refresh, size: 15, color: AppColors.mut),
              const SizedBox(width: 6),
              Text(
                '載入失敗，點擊重試',
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 12,
                  color: AppColors.mut,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
