# bilireader-web-ver

BiliReader 的 **`tw.linovelib.com` 網頁爬取版** —— 較精簡的實作，聚焦閱讀核心體驗。

以 WebView 擷取 innerHTML 搭配 `html` 解析取得內容（非官方 API），插圖與封面帶入 `tw.linovelib` 所需的 Referer / UA / Cookie。主幹採 singleton + IndexedStack + Navigator；閱讀器子系統則忠實移植自 api-ver（Riverpod + drift + freezed，故仍需 codegen）。基準／參考實作見 [`../bilireader-api-ver`](../bilireader-api-ver)。

完整專案介紹、截圖與版本比較請看 [../README.md](../README.md)。

## 開發

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## 檢查

```bash
flutter analyze
flutter test
```

## 授權

本 App 原始碼採用 [BiliReader Non-Commercial Source Available License v1.0](../LICENSE)。僅允許個人、教育與研究用途；禁止商業使用與任何平台上架發布。
