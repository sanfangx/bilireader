import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common_widgets/app_bottom_sheet.dart';
import '../../../core/common_widgets/app_capsule_button.dart';
import '../../../core/common_widgets/bili_error_view.dart';
import '../../../core/common_widgets/bili_skeleton.dart';
import '../../../core/common_widgets/book_cover.dart';
import '../../../core/common_widgets/brand_header.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/app_error.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/router/auth_controller.dart';
import '../../../core/text/text_providers.dart';
import '../../../core/text/tw_error.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../reader/domain/reading_progress.dart';
import '../../reader/reading_progress_providers.dart';
import '../domain/bookcase_options.dart';
import '../domain/bookshelf_entry.dart';
import 'bookshelf_controllers.dart';

/// 書架分頁（規範 §2.2、§5.5、設計稿「書架」）。
///
/// - 未登入：顯示登入引導（`bookcase/*` 需登入，避免未登入送出而觸發 401）。
/// - 已登入：`繼續閱讀 · 本機`（觀察本地 reading progress）＋分類 chips＋排序＋
///   書籍 grid。進度百分比優先取本機 reading progress（設計稿註記「進度為本機
///   書籤合成」；App 不呼叫 `bookcase/updateProgress`，§5.5）。
class BookshelfPage extends ConsumerWidget {
  const BookshelfPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthSnapshot auth = ref.watch(authControllerProvider);
    return Scaffold(
      key: const Key('page_bookshelf'),
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: auth.isLoggedIn ? const _ShelfView() : const _LoginGuide(),
      ),
    );
  }
}

/// 未登入引導（沿用「我的」頁樣式）。
class _LoginGuide extends StatelessWidget {
  const _LoginGuide();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screen),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.collections_bookmark_outlined,
              color: AppColors.mut,
              size: 48,
            ),
            const SizedBox(height: AppSpacing.md),
            const Text('尚未登入', style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              '登入後即可收藏書籍、同步繼續閱讀與閱讀歷史。',
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCapsuleButton(
              label: '前往登入',
              shape: AppButtonShape.capsule,
              onPressed: () => context.pushNamed(AppRoutes.loginName),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShelfView extends ConsumerWidget {
  const _ShelfView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BookshelfQuery query = ref.watch(bookshelfFilterProvider);
    final AsyncValue<List<BookshelfEntry>> list = ref.watch(
      bookshelfListProvider,
    );
    // 本機 reading progress：既驅動「繼續閱讀」卡，也提供 grid 進度%（§5.5）。
    final List<ReadingProgress> progress =
        ref.watch(continueReadingProvider).value ?? const <ReadingProgress>[];
    final Map<int, ReadingProgress> byArticle = <int, ReadingProgress>{
      for (final ReadingProgress p in progress) p.anchor.articleId: p,
    };
    final ReadingProgress? latest = progress.isEmpty ? null : progress.first;

    return RefreshIndicator(
      color: AppColors.acc,
      backgroundColor: AppColors.surf,
      onRefresh: () async {
        ref.invalidate(bookshelfListProvider);
        await ref.read(bookshelfListProvider.future);
      },
      child: CustomScrollView(
        slivers: <Widget>[
          const SliverToBoxAdapter(child: _ShelfHeader()),
          if (latest != null)
            SliverToBoxAdapter(child: _ContinueCard(progress: latest)),
          SliverToBoxAdapter(child: _ClassChips(selected: query.cls)),
          SliverToBoxAdapter(
            child: _ClassBar(sort: query.sort, count: list.value?.length),
          ),
          ..._buildBody(context, ref, list, byArticle),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
        ],
      ),
    );
  }

  List<Widget> _buildBody(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<BookshelfEntry>> list,
    Map<int, ReadingProgress> byArticle,
  ) {
    return <Widget>[
      list.when(
        // F-29：3 欄封面骨架（對齊 _BookGrid 幾何），取代置中轉圈。
        loading: () => const _BookGridSkeleton(),
        error: (Object e, StackTrace _) => SliverToBoxAdapter(
          child: SizedBox(
            height: 260,
            child: BiliErrorView(
              message: twErrorMessage(ref.read(chineseConverterProvider), e),
              onRetry: () => ref.invalidate(bookshelfListProvider),
            ),
          ),
        ),
        data: (List<BookshelfEntry> books) => books.isEmpty
            ? const SliverToBoxAdapter(child: _EmptyShelf())
            : _BookGrid(books: books, byArticle: byArticle),
      ),
    ];
  }
}

/// 品牌標頭（四分頁共用 [BrandHeader]，標題樣式一致）。右側 ⋯ 開啟排序。
class _ShelfHeader extends ConsumerWidget {
  const _ShelfHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BrandHeader(
      title: '書架',
      subtitle: 'BOOKSHELF · 我的書架',
      trailing: BrandIconButton(
        icon: Icons.more_horiz,
        semanticLabel: '排序',
        onTap: () => _showSortSheet(
          context,
          ref,
          ref.read(bookshelfFilterProvider).sort,
        ),
      ),
    );
  }
}

/// `.cont`：繼續閱讀（本機）。內容含書名、封面、章節名、章內進度%、最近閱讀時間與
/// 錨點附近繁體文字片段（§5.5 要求的顯示欄位）。點按進入詳情（閱讀器為後續階段）。
class _ContinueCard extends StatelessWidget {
  const _ContinueCard({required this.progress});

  final ReadingProgress progress;

  @override
  Widget build(BuildContext context) {
    final int pct = (progress.anchor.progressInChapter * 100)
        .clamp(0, 100)
        .round();
    final String chapter = progress.anchor.chapterName.isEmpty
        ? '未命名章節'
        : progress.anchor.chapterName;
    final String quote = progress.anchor.textQuote.trim();
    final String meta =
        '$chapter · $pct% · ${_relativeTime(progress.updatedAt)}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        14,
      ),
      child: Material(
        color: AppColors.surf,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          // 卡片本體 → 書籍詳情頁；只有右側 ▶ 播放鈕才直接回閱讀器上次位置（見下方 _PlayButton）。
          onTap: () => context.pushNamed(
            AppRoutes.novelDetailName,
            pathParameters: <String, String>{
              'articleId': '${progress.anchor.articleId}',
            },
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: <Widget>[
                BookCover(url: progress.poster, width: 46, height: 64),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '繼續閱讀 · 本機',
                        style: AppTypography.eyebrow.copyWith(
                          color: AppColors.acc,
                          fontSize: 9,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        progress.articleName.isEmpty
                            ? '未命名作品'
                            : progress.articleName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.titleMedium.copyWith(
                          fontFamily: AppTypography.fontSerif,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        meta,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall.copyWith(fontSize: 10),
                      ),
                      if (quote.isNotEmpty) ...<Widget>[
                        const SizedBox(height: 2),
                        Text(
                          quote,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 10,
                            color: AppColors.mut,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // ▶ 播放鈕：直接回閱讀器上次章節（章內位置由閱讀器依 ReaderAnchor 還原，§5.5）。
                // 巢狀手勢：點 ▶ 由此 GestureDetector 消化，不觸發外層卡片的詳情導覽。
                GestureDetector(
                  onTap: () => context.pushNamed(
                    AppRoutes.readerName,
                    pathParameters: <String, String>{
                      'articleId': '${progress.anchor.articleId}',
                    },
                    queryParameters: <String, String>{
                      'chapterId': '${progress.anchor.chapterId}',
                      // 帶回既有封面 → 續讀存檔保留（不被空封面覆蓋）。
                      if (progress.poster.isNotEmpty) 'poster': progress.poster,
                    },
                  ),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.acc,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.btxt,
                      size: 20,
                    ),
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

/// `.chips`：分類篩選（全部 + 六個真實分類），水平捲動。
class _ClassChips extends ConsumerWidget {
  const _ClassChips({required this.selected});

  final BookcaseClass selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(
          left: AppSpacing.screen,
          right: AppSpacing.screen,
        ),
        itemCount: BookcaseClass.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (BuildContext context, int i) {
          final BookcaseClass cls = BookcaseClass.values[i];
          return _Chip(
            label: cls.label,
            selected: cls == selected,
            onTap: () =>
                ref.read(bookshelfFilterProvider.notifier).setClass(cls),
          );
        },
      ),
    );
  }
}

/// 書架用膠囊（`.chip`）。與 AppChip 同視覺，但置於水平列不撐滿。
class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.acc : AppColors.surf,
      borderRadius: AppRadius.pillAll,
      child: InkWell(
        borderRadius: AppRadius.pillAll,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            widthFactor: 1,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: selected ? AppColors.btxt : AppColors.mut,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// `.clsbar`：左「N 本」，右排序按鈕（`.sortb`）。
class _ClassBar extends ConsumerWidget {
  const _ClassBar({required this.sort, required this.count});

  final BookshelfSort sort;
  final int? count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        12,
        AppSpacing.screen,
        12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            count == null ? '' : '$count 本',
            style: AppTypography.bodySmall.copyWith(fontSize: 11),
          ),
          InkWell(
            onTap: () => _showSortSheet(context, ref, sort),
            borderRadius: BorderRadius.circular(AppRadius.xs),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.swap_vert, size: 15, color: AppColors.acc),
                  const SizedBox(width: 5),
                  Text(
                    sort.label,
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 11,
                      color: AppColors.acc,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// `.grid3`：三欄書封 grid（`.gcard`）。點按進詳情、長按開啟管理抽屜。
class _BookGrid extends StatelessWidget {
  const _BookGrid({required this.books, required this.byArticle});

  final List<BookshelfEntry> books;
  final Map<int, ReadingProgress> byArticle;

  @override
  Widget build(BuildContext context) {
    const double gap = 12;
    final double cellWidth =
        (MediaQuery.sizeOf(context).width - AppSpacing.screen * 2 - gap * 2) /
        3;
    final double coverHeight = cellWidth * 1.5; // aspect-ratio 2/3
    // 封面 + gap(7) + 標題(11px×1.5≈17) + gap(6) + 進度列(≈14)，另留少量緩衝。
    final double extent = coverHeight + 7 + 18 + 6 + 15;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: gap,
          mainAxisSpacing: 16,
          mainAxisExtent: extent,
        ),
        delegate: SliverChildBuilderDelegate((BuildContext context, int i) {
          final BookshelfEntry book = books[i];
          // 進度優先本機 reading progress，其次伺服器 bookcase.progress（§5.5）。
          final ReadingProgress? local = byArticle[book.articleId];
          final double ratio = local != null
              ? local.anchor.progressInChapter.clamp(0, 1)
              : book.progressRatio;
          return _GridCard(book: book, ratio: ratio, coverHeight: coverHeight);
        }, childCount: books.length),
      ),
    );
  }
}

/// F-29：書架載入骨架。與 [_BookGrid] 共用 3 欄幾何（封面比例、間距、mainAxisExtent），
/// 灰塊排出封面 + 標題 + 進度列形狀，取代置中轉圈。靜態、無 shimmer（golden 可測）。
class _BookGridSkeleton extends StatelessWidget {
  const _BookGridSkeleton();

  @override
  Widget build(BuildContext context) {
    const double gap = 12;
    final double cellWidth =
        (MediaQuery.sizeOf(context).width - AppSpacing.screen * 2 - gap * 2) /
        3;
    final double coverHeight = cellWidth * 1.5;
    final double extent = coverHeight + 7 + 18 + 6 + 15;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: gap,
          mainAxisSpacing: 16,
          mainAxisExtent: extent,
        ),
        delegate: SliverChildBuilderDelegate(
          // 首格帶「載入書架」語意（取代原 BiliLoadingView 的訊息播報）；其餘格無語意。
          (BuildContext context, int i) => Semantics(
            label: i == 0 ? '載入書架' : null,
            container: i == 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BiliSkeletonBox(height: coverHeight, radius: AppRadius.sm),
                const SizedBox(height: 7),
                BiliSkeletonBox(width: cellWidth * 0.85, height: 11),
                const SizedBox(height: 6),
                const BiliSkeletonBox(height: 6, radius: AppRadius.badgeSm),
              ],
            ),
          ),
          childCount: 6,
        ),
      ),
    );
  }
}

class _GridCard extends ConsumerWidget {
  const _GridCard({
    required this.book,
    required this.ratio,
    required this.coverHeight,
  });

  final BookshelfEntry book;
  final double ratio;
  final double coverHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int pct = (ratio * 100).clamp(0, 100).round();
    final bool finished = pct >= 100;
    return GestureDetector(
      onTap: () => context.pushNamed(
        AppRoutes.novelDetailName,
        pathParameters: <String, String>{'articleId': '${book.articleId}'},
      ),
      onLongPress: () => _showManageSheet(context, ref, book),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BookCover(
            url: book.coverUrl,
            height: coverHeight,
            aspectRatio: 2 / 3,
            radius: AppRadius.md,
          ),
          const SizedBox(height: 7),
          Text(
            book.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            // 書名為內容標題 → serif（與繼續閱讀卡/榜單/清單書名一致）。
            style: AppTypography.bodySmall.copyWith(
              fontFamily: AppTypography.fontSerif,
              fontSize: 11,
              color: AppColors.txt,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: <Widget>[
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(1),
                  child: LinearProgressIndicator(
                    value: ratio.clamp(0, 1).toDouble(),
                    minHeight: 2,
                    backgroundColor: AppColors.cov,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.acc,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                finished ? '讀畢' : '$pct%',
                style: AppTypography.mono.copyWith(fontSize: 9),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyShelf extends StatelessWidget {
  const _EmptyShelf();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        48,
        AppSpacing.screen,
        24,
      ),
      child: Column(
        children: <Widget>[
          Icon(Icons.menu_book_outlined, color: AppColors.mut, size: 44),
          SizedBox(height: AppSpacing.md),
          Text('這個分類還沒有書', style: AppTypography.titleMedium),
          SizedBox(height: AppSpacing.sm),
          Text(
            '在書城收藏喜歡的作品，就會出現在這裡。',
            style: AppTypography.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ---- 底部抽屜 ------------------------------------------------------------

/// 排序抽屜（`.sheet`）：最後更新 / 最近收藏 / 最近閱讀。
Future<void> _showSortSheet(
  BuildContext context,
  WidgetRef ref,
  BookshelfSort current,
) async {
  final BookshelfSort? picked = await showAppBottomSheet<BookshelfSort>(
    context: context,
    title: '排序方式',
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (final BookshelfSort s in BookshelfSort.values)
          _SheetOption(
            label: s.label,
            selected: s == current,
            onTap: () => Navigator.of(context).pop(s),
          ),
      ],
    ),
  );
  if (picked != null) {
    ref.read(bookshelfFilterProvider.notifier).setSort(picked);
  }
}

/// 管理抽屜（`.sheet`）：移至分類 / 移除書架。均為狀態變更端點（§7.0），僅供
/// 實際使用者操作，不做破壞性自動測試。
Future<void> _showManageSheet(
  BuildContext context,
  WidgetRef ref,
  BookshelfEntry book,
) async {
  final _ManageAction? action = await showAppBottomSheet<_ManageAction>(
    context: context,
    title: book.title,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _SheetOption(
          label: '移至分類…',
          onTap: () => Navigator.of(context).pop(_ManageAction.move),
        ),
        _SheetOption(
          label: '移除書架',
          destructive: true,
          onTap: () => Navigator.of(context).pop(_ManageAction.remove),
        ),
      ],
    ),
  );
  if (!context.mounted || action == null) {
    return;
  }
  switch (action) {
    case _ManageAction.move:
      await _showMoveClassSheet(context, ref, book);
    case _ManageAction.remove:
      await _confirmRemove(context, ref, book);
  }
}

Future<void> _showMoveClassSheet(
  BuildContext context,
  WidgetRef ref,
  BookshelfEntry book,
) async {
  final BookcaseClass? cls = await showAppBottomSheet<BookcaseClass>(
    context: context,
    title: '移至分類',
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (final BookcaseClass c in BookcaseClass.values)
          if (c != BookcaseClass.all)
            _SheetOption(
              label: c.label,
              selected: c.value == book.classId,
              onTap: () => Navigator.of(context).pop(c),
            ),
      ],
    ),
  );
  if (cls == null || cls.value == book.classId || !context.mounted) {
    return;
  }
  final ApiResult<String> result = await ref
      .read(bookshelfMutationsProvider.notifier)
      .moveClass(caseId: book.caseId, cls: cls);
  if (!context.mounted) {
    return;
  }
  _toast(context, ref, result, ok: '已移至「${cls.label}」');
}

Future<void> _confirmRemove(
  BuildContext context,
  WidgetRef ref,
  BookshelfEntry book,
) async {
  final bool confirmed =
      await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: AppColors.surf,
          title: const Text('移除書架', style: AppTypography.titleMedium),
          content: Text(
            '確定要將「${book.title}」從書架移除嗎？',
            style: AppTypography.bodySmall,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消', style: TextStyle(color: AppColors.mut)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('移除', style: TextStyle(color: AppColors.acc)),
            ),
          ],
        ),
      ) ??
      false;
  if (!confirmed || !context.mounted) {
    return;
  }
  final ApiResult<String> result = await ref
      .read(bookshelfMutationsProvider.notifier)
      .remove(book.caseId);
  if (!context.mounted) {
    return;
  }
  _toast(context, ref, result, ok: '已移除');
}

void _toast(
  BuildContext context,
  WidgetRef ref,
  ApiResult<String> result, {
  required String ok,
}) {
  final String message = switch (result) {
    ApiSuccess<String>() => ok,
    ApiFailure<String>(:final AppError error) => twErrorMessage(
      ref.read(chineseConverterProvider),
      error,
    ),
  };
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

enum _ManageAction { move, remove }

/// 抽屜內單一可選列。選中顯示 acc 勾選；destructive 以警示色呈現。
class _SheetOption extends StatelessWidget {
  const _SheetOption({
    required this.label,
    required this.onTap,
    this.selected = false,
    this.destructive = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool selected;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final Color color = destructive
        ? AppColors.logoutRed
        : (selected ? AppColors.acc : AppColors.txt);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 4),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyLarge.copyWith(
                  color: color,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            if (selected)
              const Icon(Icons.check, size: 18, color: AppColors.acc),
          ],
        ),
      ),
    );
  }
}

/// 最近閱讀時間的相對格式（本地顯示用）。
String _relativeTime(int epochMs) {
  if (epochMs <= 0) {
    return '尚未閱讀';
  }
  final DateTime then = DateTime.fromMillisecondsSinceEpoch(epochMs);
  final Duration diff = DateTime.now().difference(then);
  if (diff.inMinutes < 1) {
    return '剛剛';
  }
  if (diff.inMinutes < 60) {
    return '${diff.inMinutes} 分鐘前';
  }
  if (diff.inHours < 24) {
    return '${diff.inHours} 小時前';
  }
  if (diff.inDays < 30) {
    return '${diff.inDays} 天前';
  }
  return '${then.year}/${then.month.toString().padLeft(2, '0')}/'
      '${then.day.toString().padLeft(2, '0')}';
}
