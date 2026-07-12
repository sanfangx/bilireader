import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common_widgets/bili_error_view.dart';
import '../../../core/common_widgets/bili_loading_view.dart';
import '../../../core/common_widgets/book_cover.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/router/auth_controller.dart';
import '../../../core/text/text_providers.dart';
import '../../../core/text/tw_error.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../domain/author_entities.dart';
import 'author_controllers.dart';

/// 作者專區頁（設計稿「作者專區 Author」）。入口閘門：登入 + groupid ∈ {1,5,6}
/// （於 [myNovelsProvider] 內短路）。清單為 `author/novel/list`；建立作品 App 無 API。
class AuthorZonePage extends ConsumerWidget {
  const AuthorZonePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<AuthorNovel>> novels = ref.watch(myNovelsProvider);
    final int? groupId = ref.watch(authControllerProvider).groupId;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('作者專區')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _NewWorkFab(onTap: () => _explainNoCreate(context)),
      body: RefreshIndicator(
        color: AppColors.acc,
        backgroundColor: AppColors.surf,
        onRefresh: () async {
          ref.invalidate(myNovelsProvider);
          await ref.read(myNovelsProvider.future);
        },
        child: novels.when(
          loading: () => const BiliLoadingView(message: '載入作品'),
          error: (Object e, StackTrace _) => BiliErrorView(
            message: twErrorMessage(ref.read(chineseConverterProvider), e),
            onRetry: () => ref.invalidate(myNovelsProvider),
          ),
          data: (List<AuthorNovel> list) => ListView(
            padding: const EdgeInsets.only(bottom: 96),
            children: <Widget>[
              _GateBanner(groupId: groupId),
              if (list.isEmpty)
                const _Empty()
              else
                for (final AuthorNovel n in list) _WorkRow(novel: n),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _explainNoCreate(BuildContext context) async {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('建立新作品需於官方網站操作（App 未提供建立作品 API）')),
      );
  }
}

/// `.az-gate`：創作者身分橫幅（surf 底 + acc 細框）。
class _GateBanner extends StatelessWidget {
  const _GateBanner({required this.groupId});

  final int? groupId;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        8,
        AppSpacing.screen,
        16,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surf,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accBorderSoft),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.edit_outlined, color: AppColors.acc, size: 18),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '創作者身分 · ${_roleName(groupId)}',
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 12,
                    color: AppColors.acc,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'groupid = ${groupId ?? '-'} · 可管理作品與章節',
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 10,
                    color: AppColors.mut,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// groupid 語意（apk/docs）：1=管理員、5=作者、6=用愛發電。
  static String _roleName(int? groupId) {
    switch (groupId) {
      case 1:
        return '管理員';
      case 5:
        return '作者';
      case 6:
        return '用愛發電';
      default:
        return '創作者';
    }
  }
}

/// `.az-work`：作品列（封面 + 標題/狀態/統計 + 管理鈕）。
class _WorkRow extends StatelessWidget {
  const _WorkRow({required this.novel});

  final AuthorNovel novel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screen,
        vertical: 13,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BookCover(url: novel.coverUrl, width: 46, height: 64, radius: 8),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  novel.title.isEmpty ? '未命名作品' : novel.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleMedium.copyWith(
                    fontFamily: AppTypography.fontSerif,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${novel.statusLabel} · ${_compact(novel.words)}字',
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 10.5,
                    color: AppColors.mut,
                  ),
                ),
                const SizedBox(height: 6),
                // .bd：僅呈現清單端點實際提供的統計（推薦票 / 鮮花），不虛構收藏/章數。
                Row(
                  children: <Widget>[
                    _Stat(label: '推薦', value: novel.voteCount),
                    const SizedBox(width: 10),
                    _Stat(label: '鮮花', value: novel.flowerCount),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _ManageButton(novel: novel),
        ],
      ),
    );
  }

  /// 大數字：>=萬用「萬」、>=千用「千」（1 位小數）；否則原值（設計 `.bd`）。
  static String _compact(int n) {
    if (n >= 10000) {
      final double w = n / 10000;
      return '${w == w.roundToDouble() ? w.toStringAsFixed(0) : w.toStringAsFixed(1)}萬';
    }
    if (n >= 1000) {
      final double k = n / 1000;
      return '${k == k.roundToDouble() ? k.toStringAsFixed(0) : k.toStringAsFixed(1)}千';
    }
    return '$n';
  }
}

/// `.bd em`：單一統計（標籤 + acc 數值）。
class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          '$label ',
          style: AppTypography.mono.copyWith(
            fontSize: 9.5,
            color: AppColors.mut,
          ),
        ),
        Text(
          _WorkRow._compact(value),
          style: AppTypography.mono.copyWith(
            fontSize: 9.5,
            color: AppColors.acc,
          ),
        ),
      ],
    );
  }
}

/// `.az-edit`：管理鈕（acc 外框膠囊）→ 章節樹。
class _ManageButton extends StatelessWidget {
  const _ManageButton({required this.novel});

  final AuthorNovel novel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => context.pushNamed(
          AppRoutes.authorChaptersName,
          pathParameters: <String, String>{'articleId': '${novel.articleId}'},
          queryParameters: <String, String>{'name': novel.title},
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: AppColors.accBorder),
          ),
          child: Text(
            '管理',
            style: AppTypography.bodySmall.copyWith(
              fontSize: 11,
              color: AppColors.acc,
            ),
          ),
        ),
      ),
    );
  }
}

/// `.az-fab`：新建作品膠囊（acc 底）。
class _NewWorkFab extends StatelessWidget {
  const _NewWorkFab({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.acc,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          alignment: Alignment.center,
          child: Text(
            '＋ 新建作品',
            style: AppTypography.bodySmall.copyWith(
              fontSize: 13,
              color: AppColors.btxt,
              fontWeight: FontWeight.w700,
            ),
          ),
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
          Icon(Icons.menu_book_outlined, color: AppColors.mut, size: 44),
          SizedBox(height: AppSpacing.md),
          Center(child: Text('還沒有作品', style: AppTypography.titleMedium)),
        ],
      ),
    );
  }
}
