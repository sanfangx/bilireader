# bilireader-api-ver

BiliReader 的 **`readpai.com` 官方 API 重製版** —— 本專案的基準／參考實作，功能最完整。

以逆向整理出的 JSON API 為資料來源（Dio + BNUP2 簽章），採 Riverpod + go_router + drift + freezed，並以 OpenCC 離線簡轉繁。另一個以網頁爬取為資料來源的精簡版本見 [`../bilireader-web-ver`](../bilireader-web-ver)。

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
