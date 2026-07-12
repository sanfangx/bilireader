import 'package:flutter/material.dart';

import '../../core/offline/offline_store.dart';
import '../../core/reading/local_store.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_background.dart';
import '../../widgets/network_cover.dart';
import '../reader/presentation/reader_page.dart';

/// 下載管理 + 離線書庫。對齊設計稿下載相關畫面。
class DownloadManagerPage extends StatelessWidget {
  const DownloadManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              _topBar(context),
              Expanded(
                child: ListenableBuilder(
                  listenable: OfflineStore.instance,
                  builder: (context, _) {
                    final tasks = OfflineStore.instance.tasks;
                    final novels = OfflineStore.instance.novels;
                    if (tasks.isEmpty && novels.isEmpty) {
                      return Center(
                        child: Text('還沒有下載\n書籍詳情頁點「下載」即可離線閱讀',
                            textAlign: TextAlign.center,
                            style: AppText.sans(
                                size: 13, color: AppColors.mut, height: 1.7)),
                      );
                    }
                    return ListView(
                      padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
                      children: [
                        if (tasks.isNotEmpty) ...[
                          _sectionLabel('下載中'),
                          for (final t in tasks) _taskCard(t),
                          const SizedBox(height: 18),
                        ],
                        _sectionLabel('離線書庫 · ${novels.length} 本'),
                        if (novels.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: Text('尚無已完成的下載',
                                  style: AppText.sans(
                                      size: 12, color: AppColors.mut)),
                            ),
                          )
                        else
                          for (final m in novels) _novelRow(context, m),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 4, 22, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child:
                  Text('‹', style: AppText.sans(size: 26, color: AppColors.mut)),
            ),
            Text('下載管理',
                style: AppText.serif(size: 14, color: AppColors.txt)),
            const SizedBox(width: 20),
          ],
        ),
      );

  Widget _sectionLabel(String s) => Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 4),
        child: Text(s, style: AppText.serif(size: 15, color: AppColors.txt)),
      );

  Widget _taskCard(DownloadTask t) {
    final pct = (t.progress * 100).round();
    final running = t.status == DlStatus.running;
    final paused = t.status == DlStatus.paused;
    final failed = t.status == DlStatus.error;
    final store = OfflineStore.instance;
    final pending = store.pendingControl(t.novelId); // 'pause'/'stop'/null（僅 running）
    final String statusText;
    if (pending == 'pause') {
      statusText = '暫停中…（本章下載完成後停止）';
    } else if (pending == 'stop') {
      statusText = '停止中…';
    } else if (running) {
      statusText = '${t.done + t.failed}/${t.total} 章 · ${t.current}';
    } else if (failed) {
      statusText = '下載失敗 · ${t.done + t.failed}/${t.total} 章';
    } else if (paused) {
      // 與 running/進度條一致用 done+failed，暫停時數字不跳號。
      statusText = '已暫停 · ${t.done + t.failed}/${t.total} 章';
    } else if (t.status == DlStatus.queued) {
      statusText = '佇列中…';
    } else {
      statusText = '已完成';
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: AppColors.surf, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(t.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.sans(
                        size: 13,
                        weight: FontWeight.w600,
                        color: AppColors.txt)),
              ),
              Text('$pct%',
                  style: AppText.mono(
                      size: 12, color: paused ? AppColors.mut : AppColors.acc)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Container(
              height: 3,
              color: AppColors.cov,
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: t.progress.clamp(0.0, 1.0),
                child: Container(color: paused ? AppColors.mut : AppColors.acc),
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            statusText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.sans(size: 11, color: AppColors.mut),
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              // 停止指令待生效時停用按鈕（避免重複點 / 被暫停覆蓋）。
              if (failed)
                _ctrlBtn('重試', AppColors.acc,
                    () => store.resumeDownload(t.novelId))
              else if (paused)
                _ctrlBtn('繼續', AppColors.acc,
                    () => store.resumeDownload(t.novelId))
              else
                _ctrlBtn('暫停', AppColors.mut,
                    pending == null ? () => store.pauseDownload(t.novelId) : null),
              const SizedBox(width: 8),
              _ctrlBtn('停止', AppColors.danger,
                  pending == 'stop' ? null : () => store.stopDownload(t.novelId)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ctrlBtn(String label, Color color, VoidCallback? onTap) {
    final bool enabled = onTap != null;
    final Color c = enabled ? color : AppColors.mut.withValues(alpha: 0.4);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: c.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(label, style: AppText.sans(size: 11, color: c)),
      ),
    );
  }

  Widget _novelRow(BuildContext context, OfflineManifest m) {
    return Dismissible(
      key: ValueKey(m.novelId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 18),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
            color: const Color(0x33D9534F),
            borderRadius: BorderRadius.circular(16)),
        child: Text('刪除', style: AppText.sans(size: 13, color: AppColors.txt)),
      ),
      // 刪除不可逆（連章節/插圖檔一併刪）→ 誤滑要確認，不直接刪。
      confirmDismiss: (_) async {
        return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: AppColors.surf,
                title: Text('刪除離線書',
                    style: AppText.serif(size: 15, color: AppColors.txt)),
                content: Text('將刪除「${m.title}」的所有離線章節與插圖，此動作無法復原。',
                    style:
                        AppText.sans(size: 13, color: AppColors.mut, height: 1.6)),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text('取消',
                          style: AppText.sans(size: 13, color: AppColors.mut))),
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text('刪除',
                          style: AppText.sans(size: 13, color: AppColors.danger))),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (_) {
        OfflineStore.instance.deleteNovel(m.novelId);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('已刪除「${m.title}」')));
      },
      child: GestureDetector(
        onTap: () => _openOffline(context, m),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: AppColors.surf, borderRadius: BorderRadius.circular(16)),
          child: Row(
            children: [
              NetworkCover(url: m.coverUrl, width: 46, height: 64, radius: 10),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.serif(size: 14, color: AppColors.txt)),
                    const SizedBox(height: 5),
                    Text('${m.okCount} 章已離線 · 點擊閱讀',
                        style: AppText.sans(size: 11, color: AppColors.mut)),
                  ],
                ),
              ),
              Text('離線',
                  style: AppText.sans(size: 10, color: AppColors.acc)),
            ],
          ),
        ),
      ),
    );
  }

  void _openOffline(BuildContext context, OfflineManifest m) {
    final chapters = OfflineStore.instance.chaptersFor(m.novelId);
    if (chapters.isEmpty) return;
    final saved = LocalStore.instance.progressOf(m.novelId)?.chapterIndex ?? 0;
    final start = saved.clamp(0, chapters.length - 1);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ReaderPage(
        articleId: int.tryParse(m.novelId) ?? 0,
        chapters: chapters,
        startIndex: start,
        articleName: m.title,
        poster: m.coverUrl ?? '',
      ),
    ));
  }
}
