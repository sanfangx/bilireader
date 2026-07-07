import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

/// 底部抽屜容器（設計稿 `.sheet`）。規範 §5.1.1：底部抽屜是高頻設計語言，
/// 抽為共用元件並使用 token（surf 底、26 圓角、頂部 1px line、拖曳 handle、
/// 置中標題）。內容由呼叫端提供；本元件只負責外框與 handle/標題。
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({required this.child, this.title, super.key});

  /// 置中標題（設計稿 `.sheet h4`）；null 則不顯示。
  final String? title;

  /// 抽屜主體內容（已在水平 padding 內）。
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surf,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        border: Border(top: BorderSide(color: AppColors.line)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0x80000000),
            blurRadius: 50,
            offset: Offset(0, -22),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // `.handle` 38×4 圓角 mut opacity .5
            Opacity(
              opacity: 0.5,
              child: Container(
                width: 38,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.mut,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            if (title != null) ...<Widget>[
              Text(
                title!,
                textAlign: TextAlign.center,
                style: AppTypography.titleMedium.copyWith(
                  fontFamily: AppTypography.fontSerif,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 15),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

/// 以設計稿 `.sheet` 樣式開啟底部抽屜。回傳使用者於抽屜內選擇的結果（或 null）。
Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  String? title,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x99000000),
    isScrollControlled: true,
    builder: (BuildContext context) =>
        AppBottomSheet(title: title, child: child),
  );
}
