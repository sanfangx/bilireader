# bilireader-web-ver

BiliReader 的 **`tw.linovelib.com` 網頁爬取版** —— 較精簡的實作，聚焦閱讀核心體驗。

以 WebView 擷取 innerHTML 搭配 `html` 解析取得內容（非官方 API），插圖與封面帶入 `tw.linovelib` 所需的 Referer / UA / Cookie。主幹採 singleton + IndexedStack + Navigator；閱讀器子系統則忠實移植自 api-ver（Riverpod + drift + freezed，故仍需 codegen）。基準／參考實作見 [`../bilireader-api-ver`](../bilireader-api-ver)。

完整專案介紹、截圖與版本比較請看 [../README.md](../README.md)。

## 內容完整性

站方對章節正文有兩道會**靜默壞掉**的反爬機制，擷取端各有一道對應的閘門：

| 機制 | 現象 | 閘門 |
| --- | --- | --- |
| 段落順序打亂（前 ~20 段固定，其餘由站方 JS 於執行期還原） | 內容順序錯亂，**無任何錯誤徵兆** | `ChapterExtractor` 比對「DOM 順序 vs 伺服器原始順序」，未還原則不擷取 |
| 信任分級截斷（用戶端不被站方信任時只回約 1/3 正文 + 「內容加載失敗」字樣） | 內容殘缺，同樣無錯誤徵兆 | `ChapterExtractor` 逐分頁偵測**終端**截斷，暖機重試一次後仍截斷則停止翻頁；`looksTruncated()` 於倉儲層攔下 |

截斷的分野是**用戶端指紋**（TLS/JA3 等），與 cookie 無關——實測不送任何 cookie（含 `cf_clearance`）的瀏覽器請求照樣拿到完整內容，而各種 header 組合的 `curl` 一律被截斷。故內容路徑只能走真 WebView，純 HTTP 抓取不可行。

兩者都只**拒絕寫入快取**，不封鎖閱讀：截斷時閱讀器提供「仍要閱讀」渲染已取得的部分（僅此一次、不落快取）。標記出現在正文中段則視為反爬誘餌、照常放行——依專案鐵律，站方標記是證據而非判決，永遠先嘗試真正的動作。

章節正文是**永久**快取，故「我的 → 清除章節快取」與閱讀器的「重新擷取」是必要的自救入口；缺了它們，一次靜默腐化就會永久固化。顯示不完整內容時，閱讀器會常駐一條提示條並停止寫入進度／書籤。

## 擷取延遲

擷取端**不等 `load` 事件**。章節頁的 `#acontent` 在 `DOMContentLoaded`（實測 ~720 ms）就已備妥全部段落，但 `load` 會被廣告 iframe 拖到遲遲不觸發——等 `onLoadStop` 等同每個分頁都空等到 25 s 逾時。改為主動輪詢「文件已解析 + `#acontent` 有段落 + `location.href` 與目標相符」（URL 比對是必要的：導覽交接期間 JS 會跑在上一頁的 DOM 上）。兩道完整性閘門仍在其後把關，正確性不變。

閱讀器另會在使用者閱讀當前章時**預抓下一章**（僅一章，且未快取才抓），走同一條倉儲路徑，故「下一章」多半直接命中快取。

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
