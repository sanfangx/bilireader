import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

/// F-18 防回歸守衛（§5.1「色值/圓角必須集中於 token，不得在 Widget 內散落」）。
///
/// 這裡只封鎖「有一對一 token、且永遠不該再手寫」的重複值 —— 不是全面禁止所有
/// `Color(0x...)`（閱讀器內建主題調色盤 `_bgPalette`/`_textPalette` 是合法的原始色資料，
/// 非 magic number）。逐一對應：
///   * `circular(999)`      → `AppRadius.pill`
///   * `Color(0xFFCAA15C)`  → `AppColors.acc`
///   * `Color(0x80000000)`  → `AppColors.scrim`
///   * `Color(0xFFCF7A6A)`  → `AppColors.danger`
///
/// 新增使用這些值的畫面碼會讓本測試轉紅，逼開發改用 token。掃描範圍為 `lib/features/`
/// 的手寫 Dart（排除產生碼 `*.g.dart` / `*.freezed.dart`）。
void main() {
  test('feature 層不得手寫已具 token 的重複色值/圓角（F-18 防回歸）', () {
    final Directory featuresDir = Directory(
      p.join(Directory.current.path, 'lib', 'features'),
    );
    expect(
      featuresDir.existsSync(),
      isTrue,
      reason: '找不到 lib/features（工作目錄應為 bilireader 專案根）',
    );

    // (pattern, 建議 token)
    final List<(RegExp, String)> banned = <(RegExp, String)>[
      (RegExp(r'circular\(999\)'), 'AppRadius.pill'),
      (RegExp(r'Color\(0xFFCAA15C\)'), 'AppColors.acc'),
      (RegExp(r'Color\(0x80000000\)'), 'AppColors.scrim'),
      (RegExp(r'Color\(0xFFCF7A6A\)'), 'AppColors.danger'),
    ];

    final List<String> violations = <String>[];
    for (final FileSystemEntity entity in featuresDir.listSync(
      recursive: true,
    )) {
      if (entity is! File || !entity.path.endsWith('.dart')) {
        continue;
      }
      if (entity.path.endsWith('.g.dart') ||
          entity.path.endsWith('.freezed.dart')) {
        continue;
      }
      final List<String> lines = entity.readAsLinesSync();
      for (int i = 0; i < lines.length; i++) {
        for (final (RegExp pattern, String token) in banned) {
          if (pattern.hasMatch(lines[i])) {
            final String rel = p.relative(entity.path);
            violations.add('$rel:${i + 1} → 改用 $token（${lines[i].trim()}）');
          }
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason: '偵測到已具 token 的重複值仍被手寫，請改用對應 token：\n${violations.join('\n')}',
    );
  });
}
