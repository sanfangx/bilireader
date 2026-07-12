import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_background.dart';
import 'library_page.dart';
import 'taxonomy.dart';

/// 標籤 — 題材標籤雲;點選進入文庫對應 tagid 篩選。
class TagsPage extends StatelessWidget {
  const TagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 4, 22, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: Text('‹',
                          style: AppText.sans(size: 26, color: AppColors.mut)),
                    ),
                    Text('標籤',
                        style: AppText.serif(size: 14, color: AppColors.txt)),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 2, 22, 16),
                child: Text('點選題材標籤,進入文庫對應篩選。',
                    style: AppText.sans(
                        size: 11.5, color: AppColors.mut, height: 1.6)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 0, 22, 8),
                child: Text('熱門題材',
                    style: AppText.serif(size: 14, color: AppColors.txt)),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 4, 22, 20),
                  child: Wrap(
                    spacing: 9,
                    runSpacing: 9,
                    children: Taxonomy.allTags
                        .map((t) => _tag(context, t))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tag(BuildContext context, Taxon t) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => LibraryPage(
          initialTagid: t.value as int,
          title: t.label,
        ),
      )),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
            color: AppColors.surf,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.line)),
        child: Text(t.label,
            style: AppText.sans(size: 12, color: AppColors.txt)),
      ),
    );
  }
}
