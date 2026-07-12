import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/infra_providers.dart';
import '../data/reader_settings_store.dart';
import '../domain/reader_settings.dart';
import '../domain/reader_theme.dart';

part 'reader_settings_providers.g.dart';

@Riverpod(keepAlive: true)
ReaderSettingsStore readerSettingsStore(Ref ref) =>
    ReaderSettingsStore(ref.watch(sharedPreferencesProvider));

/// 閱讀器「字體·排版 + 行為」設定（即時更新 + 本機持久化）。變更後 ⑨e 觸發重排。
@Riverpod(keepAlive: true)
class ReaderSettingsController extends _$ReaderSettingsController {
  ReaderSettingsStore get _store => ref.read(readerSettingsStoreProvider);

  @override
  ReaderSettings build() => _store.loadSettings();

  void _update(ReaderSettings next) {
    state = next;
    unawaited(_store.saveSettings(next));
  }

  void setFontFamily(ReaderFontFamily f) =>
      _update(state.copyWith(fontFamily: f));
  void setFontSize(double v) => _update(state.copyWith(fontSize: v));
  void setLineSpacingDp(int v) => _update(state.copyWith(lineSpacingDp: v));
  void setParagraphSpacingDp(int v) =>
      _update(state.copyWith(paragraphSpacingDp: v));
  void setConvertMode(ReaderConvertMode m) =>
      _update(state.copyWith(convertMode: m));
  void setIllustrationSpoiler(bool v) =>
      _update(state.copyWith(illustrationSpoiler: v));
  void setChapterCommentEnabled(bool v) =>
      _update(state.copyWith(chapterCommentEnabled: v));
  void setScrollMode(ReaderScrollMode m) =>
      _update(state.copyWith(scrollMode: m));
  void setTapCenterTogglesBars(bool v) =>
      _update(state.copyWith(tapCenterTogglesBars: v));

  /// F-33：螢幕遮罩降亮強度（0 ~ [ReaderSettings.kMaxDim]）。
  void setDimLevel(double v) => _update(state.copyWith(dimLevel: v));
}

/// 閱讀主題（內建 4 + 自訂 ≤5；套用/新增/刪除 + 本機持久化）。
@Riverpod(keepAlive: true)
class ReaderThemeController extends _$ReaderThemeController {
  ReaderSettingsStore get _store => ref.read(readerSettingsStoreProvider);

  @override
  ReaderThemeState build() => _store.loadThemeState();

  void applyTheme(ReaderTheme t) {
    state = state.copyWith(active: t);
    unawaited(_store.saveActiveTheme(t));
  }

  /// 新增自訂主題（≤5，超過回 false）；新增後自動套用。
  bool addCustomTheme(ReaderTheme theme) {
    if (!state.canAddCustom) return false;
    final ReaderTheme t = theme.copyWith(builtIn: false);
    final List<ReaderTheme> custom = <ReaderTheme>[...state.custom, t];
    state = state.copyWith(custom: custom, active: t);
    unawaited(_store.saveCustomThemes(custom));
    unawaited(_store.saveActiveTheme(t));
    return true;
  }

  void deleteCustomTheme(String id) {
    final List<ReaderTheme> custom = state.custom
        .where((ReaderTheme t) => t.id != id)
        .toList();
    final bool wasActive = state.active.id == id;
    final ReaderTheme active = wasActive ? kDefaultReaderTheme : state.active;
    state = state.copyWith(custom: custom, active: active);
    unawaited(_store.saveCustomThemes(custom));
    if (wasActive) unawaited(_store.saveActiveTheme(active));
  }
}
