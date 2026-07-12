import 'package:flutter/material.dart';

import '../../core/app_config.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_background.dart';
import '../../widgets/simple_web_view_page.dart';

/// VIP 鎖定頁 — 第三方無法解鎖/代購 VIP 章節。
class VipLockPage extends StatelessWidget {
  const VipLockPage({
    super.key,
    required this.novelTitle,
    required this.chapterTitle,
  });

  final String novelTitle;
  final String chapterTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 4, 22, 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: Text('‹',
                          style: AppText.sans(size: 26, color: AppColors.mut)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(novelTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.serif(size: 14, color: AppColors.txt)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(chapterTitle,
                            textAlign: TextAlign.center,
                            style: AppText.mono(
                                size: 10,
                                color: AppColors.acc,
                                letterSpacing: 1.6)),
                        const SizedBox(height: 18),
                        Container(
                          width: 74,
                          height: 74,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.acc.withValues(alpha: 0.12),
                            border: Border.all(
                                color: AppColors.acc.withValues(alpha: 0.32)),
                          ),
                          alignment: Alignment.center,
                          child: Text('VIP',
                              style: AppText.sans(
                                  size: 16,
                                  weight: FontWeight.w700,
                                  color: AppColors.acc)),
                        ),
                        const SizedBox(height: 22),
                        Text('此章為 VIP 章節',
                            style: AppText.serif(size: 21, color: AppColors.txt)),
                        const SizedBox(height: 12),
                        Text(
                          '第三方 App 無法解鎖或代購 VIP 章節。\n請至官方網站登入並購買後，\n於官網閱讀本章。',
                          textAlign: TextAlign.center,
                          style: AppText.sans(
                              size: 12, color: AppColors.mut, height: 1.85),
                        ),
                        const SizedBox(height: 26),
                        SizedBox(
                          width: double.infinity,
                          child: GestureDetector(
                            // 真的開官網（app 內 WebView，共用登入 cookie）→ 使用者可登入購買/閱讀，
                            // 不再是只彈 SnackBar 的死按鈕。
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const SimpleWebViewPage(
                                    url: AppConfig.origin, title: '官方網站'),
                              ),
                            ),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: AppColors.acc,
                                  borderRadius: BorderRadius.circular(14)),
                              alignment: Alignment.center,
                              child: Text('前往官網購買  →',
                                  style: AppText.sans(
                                      size: 14,
                                      weight: FontWeight.w700,
                                      color: AppColors.btxt)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 11),
                        SizedBox(
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).maybePop(),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.line),
                                  borderRadius: BorderRadius.circular(14)),
                              alignment: Alignment.center,
                              child: Text('返回目錄',
                                  style: AppText.sans(
                                      size: 13, color: AppColors.txt)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
