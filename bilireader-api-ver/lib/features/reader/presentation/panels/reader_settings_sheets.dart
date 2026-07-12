import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/reader_settings.dart';
import '../../domain/reader_theme.dart';
import '../reader_settings_providers.dart';

/// 閱讀器底部彈窗（設計 `.sheet`）：字體·排版 與 主題·顯示。
///
/// 依 `bilireader_ui_design.html` 的 `.sheet/.srow/.slab/.sld/.opts/.sws/.thm/.tgrow/.tgl`。
/// 簡繁轉換依 §5.0（line 265）**不提供簡體**，只列 繁體 / 台灣正體（設計第三欄「簡體」移除）。

Future<void> showReaderFontSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surf,
      barrierColor: AppColors.scrim,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (BuildContext _) => const _FontTypographySheet(),
    );

Future<void> showReaderThemeSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surf,
      barrierColor: AppColors.scrim,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (BuildContext _) => const _ThemeDisplaySheet(),
    );

// ---------------------------------------------------------------------------
// 字體 · 排版
// ---------------------------------------------------------------------------

class _FontTypographySheet extends ConsumerWidget {
  const _FontTypographySheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ReaderSettings s = ref.watch(readerSettingsControllerProvider);
    final ReaderSettingsController c = ref.read(
      readerSettingsControllerProvider.notifier,
    );

    return _SheetShell(
      title: '字體 · 排版',
      children: <Widget>[
        // 字體家族（assets 內 CJK 字型：明體 NotoSerifTC / 黑體 NotoSansTC / 圓體 RoundedTC）。
        _OptsRow<ReaderFontFamily>(
          label: '字體',
          options: const <_Opt<ReaderFontFamily>>[
            _Opt<ReaderFontFamily>('明體', ReaderFontFamily.serif),
            _Opt<ReaderFontFamily>('黑體', ReaderFontFamily.sans),
            _Opt<ReaderFontFamily>('圓體', ReaderFontFamily.rounded),
          ],
          selected: s.fontFamily,
          onSelect: c.setFontFamily,
        ),
        _SliderRow(
          label: '字號',
          value: '${s.fontSize.round()} sp',
          min: ReaderSettings.kMinFontSize,
          max: ReaderSettings.kMaxFontSize,
          current: s.fontSize,
          leadGlyph: 'A',
          leadSize: 12,
          trailGlyph: 'A',
          trailSize: 19,
          onChanged: c.setFontSize,
        ),
        _SliderRow(
          label: '行距',
          value: '${s.lineSpacingDp} dp',
          min: ReaderSettings.kMinSpacingDp.toDouble(),
          max: ReaderSettings.kMaxSpacingDp.toDouble(),
          current: s.lineSpacingDp.toDouble(),
          leadGlyph: '≡',
          trailGlyph: '≣',
          onChanged: (double v) => c.setLineSpacingDp(v.round()),
        ),
        _SliderRow(
          label: '段距',
          value: '${s.paragraphSpacingDp} dp',
          min: ReaderSettings.kMinSpacingDp.toDouble(),
          max: ReaderSettings.kMaxSpacingDp.toDouble(),
          current: s.paragraphSpacingDp.toDouble(),
          leadGlyph: '⊟',
          trailGlyph: '☰',
          onChanged: (double v) => c.setParagraphSpacingDp(v.round()),
        ),
        // 簡繁轉換：§5.0 不得提供簡體，只列 繁體 / 台灣正體（設計「簡體」欄移除）。
        _OptsRow<ReaderConvertMode>(
          label: '簡繁轉換',
          options: const <_Opt<ReaderConvertMode>>[
            _Opt<ReaderConvertMode>('繁體', ReaderConvertMode.traditional),
            _Opt<ReaderConvertMode>('台灣正體', ReaderConvertMode.traditionalTw),
          ],
          selected: s.convertMode,
          onSelect: c.setConvertMode,
          lastRow: true,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 主題 · 顯示
// ---------------------------------------------------------------------------

/// F-33：dimLevel（0~kMaxDim 遮罩不透明度）↔ 亮度百分比（100＝不降亮）。
int _brightnessPercent(double dim) =>
    (100 * (1 - dim / ReaderSettings.kMaxDim)).round().clamp(0, 100);

class _ThemeDisplaySheet extends ConsumerWidget {
  const _ThemeDisplaySheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ReaderThemeState themeState = ref.watch(
      readerThemeControllerProvider,
    );
    final ReaderThemeController themeC = ref.read(
      readerThemeControllerProvider.notifier,
    );
    final ReaderSettings s = ref.watch(readerSettingsControllerProvider);
    final ReaderSettingsController c = ref.read(
      readerSettingsControllerProvider.notifier,
    );

    return _SheetShell(
      title: '主題 · 顯示',
      children: <Widget>[
        _Srow(
          label: '背景主題',
          child: _SwatchRow(
            themes: kBuiltInReaderThemes,
            activeId: themeState.active.id,
            onTap: themeC.applyTheme,
          ),
        ),
        _Srow(
          label: '自訂主題',
          trailing: '${themeState.custom.length} / $kMaxCustomReaderThemes',
          child: _SwatchRow(
            themes: themeState.custom,
            activeId: themeState.active.id,
            onTap: themeC.applyTheme,
            onLongPress: (ReaderTheme t) =>
                _confirmDeleteTheme(context, themeC, t),
            trailingAdd: themeState.canAddCustom
                ? () => _showCustomThemeDialog(context, themeC)
                : null,
          ),
        ),
        // F-33：螢幕遮罩亮度（App 內降亮，不動系統背光）。滑桿為亮度 %（右＝最亮＝不降亮）。
        _SliderRow(
          label: '亮度',
          value: '${_brightnessPercent(s.dimLevel)}%',
          min: 0,
          max: 100,
          current: _brightnessPercent(s.dimLevel).toDouble(),
          leadGlyph: '暗',
          trailGlyph: '亮',
          onChanged: (double b) =>
              c.setDimLevel((100 - b) / 100 * ReaderSettings.kMaxDim),
        ),
        _OptsRow<ReaderScrollMode>(
          label: '翻頁方式',
          options: const <_Opt<ReaderScrollMode>>[
            _Opt<ReaderScrollMode>('捲動', ReaderScrollMode.vertical),
            _Opt<ReaderScrollMode>('翻頁', ReaderScrollMode.horizontal),
            _Opt<ReaderScrollMode>('仿真捲頁', ReaderScrollMode.pageCurl),
          ],
          selected: s.scrollMode,
          onSelect: c.setScrollMode,
        ),
        _TgRow(
          label: '防劇透插圖',
          hint: '正文僅顯示前 N 張插圖',
          value: s.illustrationSpoiler,
          onChanged: c.setIllustrationSpoiler,
        ),
        _TgRow(
          label: '章末章評入口',
          hint: '章節結尾顯示評論區',
          value: s.chapterCommentEnabled,
          onChanged: c.setChapterCommentEnabled,
        ),
        _TgRow(
          // hint 只述行為，不寫「預設關閉」——開關本身已表達開/關狀態，寫死預設值於開啟後會誤導。
          label: '點擊隱藏工具列',
          hint: '輕觸畫面中央收起上下工具列',
          value: s.tapCenterTogglesBars,
          onChanged: c.setTapCenterTogglesBars,
          lastRow: true,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 共用外殼與元件
// ---------------------------------------------------------------------------

/// `.sheet` 外殼：handle + 置中標題 + 內容（底部 SafeArea）。
class _SheetShell extends StatelessWidget {
  const _SheetShell({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          14,
          AppSpacing.xl,
          AppSpacing.screen,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 38,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.mut.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: AppTypography.fontSerif,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.txt,
                  letterSpacing: 0.6,
                ),
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// `.srow`：標題（可含右側值）+ 內容。
class _Srow extends StatelessWidget {
  const _Srow({
    required this.label,
    required this.child,
    this.trailing,
    this.lastRow = false,
  });

  final String label;
  final Widget child;
  final String? trailing;
  final bool lastRow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: lastRow ? 0 : 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: <Widget>[
                Text(
                  label,
                  style: const TextStyle(fontSize: 11.5, color: AppColors.mut),
                ),
                const Spacer(),
                if (trailing != null)
                  Text(
                    trailing!,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.txt,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}

/// `.srow` + `.sld`：值標在右、滑軌兩側 glyph（`.gi`）。
class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.current,
    required this.leadGlyph,
    required this.trailGlyph,
    required this.onChanged,
    this.leadSize = 15,
    this.trailSize = 15,
  });

  final String label;
  final String value;
  final double min;
  final double max;
  final double current;
  final String leadGlyph;
  final String trailGlyph;
  final double leadSize;
  final double trailSize;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return _Srow(
      label: label,
      trailing: value,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        child: Row(
          children: <Widget>[
            Text(
              leadGlyph,
              style: TextStyle(color: AppColors.mut, fontSize: leadSize),
            ),
            Expanded(
              child: SliderTheme(
                data: const SliderThemeData(
                  trackHeight: 3,
                  activeTrackColor: AppColors.acc,
                  inactiveTrackColor: AppColors.cov,
                  thumbColor: AppColors.acc,
                  overlayColor: AppColors.accFill,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7.5),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 15),
                ),
                child: Slider(
                  min: min,
                  max: max,
                  divisions: (max - min).round(),
                  value: current.clamp(min, max),
                  onChanged: onChanged,
                ),
              ),
            ),
            Text(
              trailGlyph,
              style: TextStyle(color: AppColors.mut, fontSize: trailSize),
            ),
          ],
        ),
      ),
    );
  }
}

class _Opt<T> {
  const _Opt(this.label, this.value);
  final String label;
  final T value;
}

/// `.opts`：等寬膠囊分段（選中 = acc 描邊 + cov 底 + acc 字）。
class _OptsRow<T> extends StatelessWidget {
  const _OptsRow({
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelect,
    this.lastRow = false,
  });

  final String label;
  final List<_Opt<T>> options;
  final T selected;
  final ValueChanged<T> onSelect;
  final bool lastRow;

  @override
  Widget build(BuildContext context) {
    return _Srow(
      label: label,
      lastRow: lastRow,
      child: Row(
        children: <Widget>[
          for (int i = 0; i < options.length; i++) ...<Widget>[
            if (i > 0) const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _OptPill(
                label: options[i].label,
                selected: options[i].value == selected,
                onTap: () => onSelect(options[i].value),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OptPill extends StatelessWidget {
  const _OptPill({
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
      color: selected ? AppColors.cov : AppColors.bg,
      shape: StadiumBorder(
        side: BorderSide(
          color: selected ? AppColors.acc : Colors.transparent,
          width: 1.4,
        ),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: SizedBox(
          height: 38,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: selected ? AppColors.acc : AppColors.mut,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// `.sws`：主題色票列（+ 選配「＋新增」）。
class _SwatchRow extends StatelessWidget {
  const _SwatchRow({
    required this.themes,
    required this.activeId,
    required this.onTap,
    this.onLongPress,
    this.trailingAdd,
  });

  final List<ReaderTheme> themes;
  final String activeId;
  final ValueChanged<ReaderTheme> onTap;
  final ValueChanged<ReaderTheme>? onLongPress;
  final VoidCallback? trailingAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        for (int i = 0; i < themes.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(width: 10),
          Expanded(
            child: _Swatch(
              theme: themes[i],
              active: themes[i].id == activeId,
              onTap: () => onTap(themes[i]),
              onLongPress: onLongPress == null
                  ? null
                  : () => onLongPress!(themes[i]),
            ),
          ),
        ],
        if (trailingAdd != null) ...<Widget>[
          if (themes.isNotEmpty) const SizedBox(width: 10),
          Expanded(child: _AddSwatch(onTap: trailingAdd!)),
        ],
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.theme,
    required this.active,
    required this.onTap,
    this.onLongPress,
  });

  final ReaderTheme theme;
  final bool active;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(theme.bgColor),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: active ? AppColors.acc : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          theme.name,
          style: TextStyle(
            color: Color(theme.textColor),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _AddSwatch extends StatelessWidget {
  const _AddSwatch({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: AppColors.mut.withValues(alpha: 0.3),
            width: 1.4,
          ),
        ),
        child: const Text(
          '＋',
          style: TextStyle(color: AppColors.mut, fontSize: 18),
        ),
      ),
    );
  }
}

/// `.tgrow` + `.tgl`：說明行 + 開關。
class _TgRow extends StatelessWidget {
  const _TgRow({
    required this.label,
    required this.hint,
    required this.value,
    required this.onChanged,
    this.lastRow = false,
  });

  final String label;
  final String hint;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool lastRow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 9, bottom: lastRow ? 0 : 9),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: AppColors.txt),
                ),
                const SizedBox(height: 2),
                Text(
                  hint,
                  style: const TextStyle(fontSize: 10, color: AppColors.mut),
                ),
              ],
            ),
          ),
          _Toggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  const _Toggle({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        // F-22：reduce-motion 時開關瞬時切換（與 carousel dots 一致）。
        duration: AppMotion.durationOf(context, AppMotion.fast),
        width: 40,
        height: 22,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value ? AppColors.acc : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(11),
        ),
        child: AnimatedAlign(
          duration: AppMotion.durationOf(context, AppMotion.fast),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: value ? AppColors.btxt : AppColors.mut,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 自訂主題：刪除確認 + 新增對話框
// ---------------------------------------------------------------------------

Future<void> _confirmDeleteTheme(
  BuildContext context,
  ReaderThemeController c,
  ReaderTheme t,
) async {
  final bool? ok = await showDialog<bool>(
    context: context,
    builder: (BuildContext ctx) => AlertDialog(
      backgroundColor: AppColors.surf,
      title: const Text('刪除自訂主題', style: TextStyle(color: AppColors.txt)),
      content: Text(
        '確定刪除「${t.name}」？',
        style: const TextStyle(color: AppColors.mut),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('取消', style: TextStyle(color: AppColors.mut)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('刪除', style: TextStyle(color: AppColors.acc)),
        ),
      ],
    ),
  );
  if (ok ?? false) c.deleteCustomTheme(t.id);
}

/// 自訂主題新增（設計僅示「＋」，未展開建立 UI）：名稱 + 背景色 + 文字色。
Future<void> _showCustomThemeDialog(
  BuildContext context,
  ReaderThemeController c,
) => showDialog<void>(
  context: context,
  builder: (BuildContext ctx) => _CustomThemeDialog(controller: c),
);

class _CustomThemeDialog extends StatefulWidget {
  const _CustomThemeDialog({required this.controller});

  final ReaderThemeController controller;

  @override
  State<_CustomThemeDialog> createState() => _CustomThemeDialogState();
}

class _CustomThemeDialogState extends State<_CustomThemeDialog> {
  static const List<int> _bgPalette = <int>[
    0xFF15110D,
    0xFF1B1E2E,
    0xFF10221A,
    0xFF2A1A1A,
    0xFFF5F5DC,
    0xFFF4ECD8,
    0xFFEAF4F8,
    0xFFE8DDC6,
  ];
  static const List<int> _textPalette = <int>[
    0xFFECE3D4,
    0xFFCCC6BC,
    0xFFC6C9E0,
    0xFF2F2A22,
    0xFF4B3826,
    0xFF263238,
  ];

  final TextEditingController _name = TextEditingController(text: '自訂主題');
  int _bg = _bgPalette.first;
  int _text = _textPalette.first;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surf,
      title: const Text(
        '自訂主題',
        style: TextStyle(color: AppColors.txt, fontSize: 16),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 預覽
            Container(
              width: double.infinity,
              height: 54,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(_bg),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.line),
              ),
              child: Text(
                _name.text.isEmpty ? '預覽' : _name.text,
                style: TextStyle(
                  color: Color(_text),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _name,
              maxLength: 8,
              style: const TextStyle(color: AppColors.txt),
              cursorColor: AppColors.acc,
              decoration: const InputDecoration(
                labelText: '名稱',
                labelStyle: TextStyle(color: AppColors.mut),
                counterStyle: TextStyle(color: AppColors.mut),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 10),
            const Text(
              '背景色',
              style: TextStyle(color: AppColors.mut, fontSize: 11.5),
            ),
            const SizedBox(height: AppSpacing.xs),
            _PaletteRow(
              colors: _bgPalette,
              selected: _bg,
              onTap: (int v) => setState(() => _bg = v),
            ),
            const SizedBox(height: 10),
            const Text(
              '文字色',
              style: TextStyle(color: AppColors.mut, fontSize: 11.5),
            ),
            const SizedBox(height: AppSpacing.xs),
            _PaletteRow(
              colors: _textPalette,
              selected: _text,
              onTap: (int v) => setState(() => _text = v),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消', style: TextStyle(color: AppColors.mut)),
        ),
        TextButton(
          onPressed: () {
            final String name = _name.text.trim().isEmpty
                ? '自訂主題'
                : _name.text.trim();
            widget.controller.addCustomTheme(
              ReaderTheme(
                id: 'custom_${DateTime.now().microsecondsSinceEpoch}',
                name: name,
                builtIn: false,
                textColor: _text,
                bgColor: _bg,
              ),
            );
            Navigator.pop(context);
          },
          child: const Text('新增', style: TextStyle(color: AppColors.acc)),
        ),
      ],
    );
  }
}

class _PaletteRow extends StatelessWidget {
  const _PaletteRow({
    required this.colors,
    required this.selected,
    required this.onTap,
  });

  final List<int> colors;
  final int selected;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: <Widget>[
        for (final int v in colors)
          GestureDetector(
            onTap: () => onTap(v),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Color(v),
                shape: BoxShape.circle,
                border: Border.all(
                  color: v == selected ? AppColors.acc : AppColors.line,
                  width: v == selected ? 2 : 1,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
