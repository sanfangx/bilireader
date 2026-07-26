import 'dart:convert';
import 'dart:ui';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../core/app_config.dart';
import 'content_block.dart';
import 'data/chapter_text_assembler.dart' show looksTruncated;

/// 段落順序尚未還原就被擷取（站方 chapterlog.js 未跑完 / 未執行）。
///
/// 這是**靜默壞掉**的防線：伺服器送出的 `#acontent` 段落是打亂的，站方 JS 於執行期
/// 還原；若在還原完成前擷取，拿到的是亂序但**不會有任何錯誤徵兆**，還會被寫進
/// drift 快取與離線檔而永久固化。故寧可拋例外（呼叫端不快取、可重試），
/// 也不要把亂掉的內容存起來。
class ChapterOrderNotRestoredException implements Exception {
  const ChapterOrderNotRestoredException(this.url);
  final String url;
  @override
  String toString() => 'ChapterOrderNotRestoredException($url)';
}

/// 段落順序還原狀態的判定結果。
enum OrderCheck {
  /// 已還原（DOM 順序 ≠ 伺服器送出的打亂順序）。
  restored,

  /// 尚未還原（DOM 順序 == 伺服器打亂順序）→ 需等待重試。
  unrestored,

  /// 無法判別（拿不到對照、或段落數過少使打亂不生效）→ 視為通過。
  indeterminate,
}

/// 章節「渲染擷取」器。
///
/// 用無頭 WebView 載入章節頁，讓站方 chapterlog.js 自動還原被打亂的段落，
/// 再擷取「真正可見」的 #acontent 段落（過濾 position:absolute / height:0 的誘餌）。
/// 自動串接同章分頁（ReadParams.url_next，cid 相同者）。
///
/// **順序完整性**（2026-07-11 以 Chrome 實測確認）：伺服器對每個請求（navigation 與
/// XHR 皆同）送出的是**固定打亂**的段落——前 ~20 段固定、其餘為以章節為種子的排列；
/// 站方 JS 在執行期還原。擷取前必須確認還原已完成，否則得到亂序內容且無任何錯誤。
class ChapterExtractor {
  /// 擷取配方：依文件順序走 #acontent 的 p / img，丟掉誘餌段落，
  /// 圖片取 lazy-load 的 data-src（真實 URL；src 多為 /images/sloading.svg 佔位），
  /// 並正規化（𝘣→b、// 補 https:、相對路徑補 origin、修雙重前綴）。順序已由瀏覽器還原。
  static const String _js = r'''
(function(){
  function vis(p){
    var r = p.getBoundingClientRect();
    var s = getComputedStyle(p);
    return r.height > 0 && s.position !== 'absolute' && s.display !== 'none' && s.visibility !== 'hidden';
  }
  function fix(s){
    if(!s) return '';
    s = s.replace(/𝘣/g, 'b'); // 𝘣 (math italic small b) → b
    if(s.indexOf('//') === 0) s = 'https:' + s;
    else if(s.indexOf('/') === 0) s = 'https://tw.linovelib.com' + s;
    s = s.replace('https://https://', 'https://');
    return s;
  }
  // 序列化「可見」innerHTML：保留富文本標籤（ruby/rt/span/font/sup/small/br…），
  // 剔除隱藏誘餌（display:none / position:absolute / 0 尺寸），供 Dart 端行內解析器渲染。
  function esc(t){ return t.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }
  var KEEP = {RUBY:1,RT:1,RP:1,SPAN:1,FONT:1,SUP:1,SMALL:1,B:1,I:1,EM:1,U:1};
  function hidden(el){
    var s = getComputedStyle(el);
    if(s.display==='none' || s.visibility==='hidden' || s.position==='absolute') return true;
    var r = el.getBoundingClientRect();
    return (r.height===0 && r.width===0);
  }
  function ser(node){
    var out='', kids=node.childNodes;
    for(var i=0;i<kids.length;i++){
      var n=kids[i];
      if(n.nodeType===3){ out += esc(n.nodeValue || ''); continue; }
      if(n.nodeType!==1) continue;
      var tag=n.tagName;
      if(tag==='BR'){ out+='<br>'; continue; }
      if(tag==='IMG') continue;            // 圖片獨立成 block
      if(hidden(n)) continue;              // 誘餌
      if(KEEP[tag]){
        var t=tag.toLowerCase(), attr='';
        if(t==='span'||t==='font'){
          var cls=n.getAttribute('class'), st=n.getAttribute('style'), col=n.getAttribute('color');
          if(cls) attr+=' class="'+cls+'"';
          if(st) attr+=' style="'+st.replace(/"/g,'')+'"';
          if(col) attr+=' color="'+col+'"';
        }
        out+='<'+t+attr+'>'+ser(n)+'</'+t+'>';
      } else {
        out += ser(n);                     // 未知包裝：保留內容
      }
    }
    return out;
  }
  var root = document.querySelector('#acontent');
  var blocks = [];
  if(root){
    var els = root.querySelectorAll('p, img');
    for(var k=0; k<els.length; k++){
      var el = els[k];
      if(el.tagName === 'IMG'){
        var s = fix(el.getAttribute('data-src') || el.getAttribute('src') || '');
        if(s && s.indexOf('<') === -1 && s.indexOf('sloading') === -1 &&
           s.indexOf('/images/loading') === -1 && s.indexOf('data:') !== 0){
          blocks.push({t:'i', v:s});
        }
      } else {
        if(vis(el)){
          var tx = ser(el).trim(); // 保留富文本標籤的可見 innerHTML（取代 textContent）
          if(tx) blocks.push({t:'p', v:tx});
        }
      }
    }
  }
  var title = (document.querySelector('#atitle') || {}).textContent || '';
  var next = (window.ReadParams && window.ReadParams.url_next) || '';
  return JSON.stringify({ title: title.trim(), blocks: blocks, next: next });
})();
''';

  /// 順序還原探針（async）：把「目前 DOM 的可見段落順序」與「伺服器原始 HTML 的
  /// 段落順序」比對。原始 HTML 走 `cache:'force-cache'`，通常直接命中剛才導覽的
  /// HTTP 快取 → 不額外打伺服器（不佔 CF 額度）。
  ///
  /// 兩者**相同** ⇒ 站方 JS 尚未把打亂的段落還原 ⇒ 現在擷取會拿到亂序。
  static const String _probeJs = r'''
var root = document.querySelector('#acontent');
if(!root) return JSON.stringify({n:0, servedN:-1, identical:false});
function vis(p){
  var r = p.getBoundingClientRect(), s = getComputedStyle(p);
  return r.height > 0 && s.position !== 'absolute' && s.display !== 'none' && s.visibility !== 'hidden';
}
function norm(t){ return (t||'').replace(/\s+/g,''); }
var live = [];
var ps = root.querySelectorAll('p');
for(var i=0;i<ps.length;i++){ if(vis(ps[i])){ var t=norm(ps[i].textContent); if(t) live.push(t); } }
var served = null;
try{
  var html = await fetch(location.href, {credentials:'include', cache:'force-cache'}).then(function(r){return r.text();});
  var d = new DOMParser().parseFromString(html, 'text/html');
  var r2 = d.querySelector('#acontent');
  if(r2){
    served = [];
    var qs = r2.querySelectorAll('p');
    for(var j=0;j<qs.length;j++){ var s2=norm(qs[j].textContent); if(s2) served.push(s2); }
  }
}catch(e){ served = null; }
var identical = false;
if(served && served.length === live.length && live.length > 0){
  identical = true;
  for(var k=0;k<live.length;k++){ if(served[k] !== live[k]){ identical = false; break; } }
}
return JSON.stringify({n: live.length, servedN: served ? served.length : -1, identical: identical});
''';

  /// 段落數少於此值時，站方打亂（保留前 ~20 段固定）幾乎不生效，
  /// 「DOM 順序 == 伺服器順序」屬正常，無法用來判定是否已還原。
  static const int kMinParasToJudge = 25;

  /// 純函式判定（可單元測試，不需 WebView / 網路）。
  static OrderCheck classifyOrder({
    required int liveCount,
    required int servedCount,
    required bool identical,
  }) {
    if (servedCount < 0) return OrderCheck.indeterminate; // 拿不到對照
    if (liveCount < kMinParasToJudge) return OrderCheck.indeterminate;
    return identical ? OrderCheck.unrestored : OrderCheck.restored;
  }

  /// 「內容就緒」探針：`#acontent` 已有段落、且文件已解析完（`readyState != 'loading'`）。
  ///
  /// 一併回傳 `location.href` 供**導覽守衛**：`evaluateJavascript` 在新頁面尚未接手時
  /// 會跑在**上一頁**的 DOM 上，若不比對 URL 就可能把上一章的內容當成這一章擷取。
  static const String _readyJs = r'''
(function(){
  var r = document.querySelector('#acontent');
  var n = r ? r.querySelectorAll('p').length : 0;
  return JSON.stringify({
    href: location.href,
    ready: (document.readyState !== 'loading') && n > 0
  });
})();
''';

  static const Duration _readyPollInterval = Duration(milliseconds: 150);

  /// 就緒輪詢上限 ≈25s —— 與先前等 `onLoadStop` 的 timeout 一致，行為上限不變。
  static const int _readyMaxPolls = 170;

  HeadlessInAppWebView? _hw;

  static String? _cid(String url) =>
      RegExp(r'/(\d+)(?:_\d+)?\.html').firstMatch(url)?.group(1);

  static String _pathOf(String url) => Uri.tryParse(url)?.path ?? url;

  /// 等「內容就緒」，**不等 `load` 事件**。
  ///
  /// 實測（2026-07-25，Chrome 對 novel 2013 章節頁）：`#acontent` 在
  /// `domContentLoadedEventEnd ≈ 720ms` 就已有全部 130 段、站方資源 662ms 全部完成，
  /// 但 `loadEventEnd` **遲遲不觸發**（廣告 iframe 掛著）。先前等 `onLoadStop`
  /// （對應 `load` 事件）等於每個分頁都空等到 25s timeout —— 這是「開章／下一章
  /// 轉很久」的主因，且與伺服器速度無關。
  ///
  /// 正確性不受影響：真正的把關仍是其後的 [_awaitRestored]（段落順序）與倉儲層的
  /// 截斷偵測。這裡只是把「開始檢查」的時機從 load 提前到 DOM 就緒。
  Future<void> _awaitContentReady(
    InAppWebViewController ctrl,
    String target,
  ) async {
    final String wantPath = _pathOf(target);
    for (int i = 0; i < _readyMaxPolls; i++) {
      try {
        final Map<String, dynamic>? m = _decode(
          await ctrl.evaluateJavascript(source: _readyJs),
        );
        if (m != null &&
            m['ready'] == true &&
            _pathOf(m['href']?.toString() ?? '') == wantPath) {
          return;
        }
      } catch (_) {
        // 導覽交接期間 evaluateJavascript 可能短暫失敗 → 續輪詢
      }
      await Future<void>.delayed(_readyPollInterval);
    }
    // 逾時不拋：維持既有行為（擷取到空內容 → 由倉儲判為 VIP/空章）。
  }

  /// 輪詢探針直到確認段落已還原（或判定無法判別）。逾時回 false。
  Future<bool> _awaitRestored(InAppWebViewController ctrl) async {
    for (int i = 0; i < 16; i++) {
      Object? raw;
      try {
        raw = await ctrl.callAsyncJavaScript(functionBody: _probeJs);
      } catch (_) {
        return true; // 探針本身不可用（舊 WebView）→ 不阻擋，退回既有行為
      }
      // callAsyncJavaScript 回 {value: ..., error: ...}
      Object? value = raw;
      if (raw is CallAsyncJavaScriptResult) {
        if (raw.error != null) return true; // 探針出錯 → 不阻擋
        value = raw.value;
      }
      final Map<String, dynamic>? m = _decode(value);
      if (m == null) return true;
      final OrderCheck check = classifyOrder(
        liveCount: (m['n'] as num?)?.toInt() ?? 0,
        servedCount: (m['servedN'] as num?)?.toInt() ?? -1,
        identical: m['identical'] == true,
      );
      if (check != OrderCheck.unrestored) return true;
      await Future<void>.delayed(const Duration(milliseconds: 350));
    }
    return false;
  }

  Future<ChapterContent> load(String startUrl) async {
    final blocks = <ContentBlock>[];
    String? title;
    final baseCid = _cid(startUrl);

    _hw = HeadlessInAppWebView(
      initialSize: const Size(420, 920),
      initialSettings: InAppWebViewSettings(
        userAgent: AppConfig.userAgent,
        javaScriptEnabled: true,
        thirdPartyCookiesEnabled: true,
        clearCache: false,
      ),
      // 刻意不掛 onLoadStop：它對應 `load` 事件，會被廣告 iframe 拖住而遲遲不觸發。
      // 就緒判定改由 _awaitContentReady 主動輪詢 DOM（見其註解的實測數據）。
    );
    await _hw!.run();
    final ctrl = _hw!.webViewController!;

    try {
      String? url = startUrl;
      bool warmedUp = false;
      for (int page = 0; page < 15 && url != null; page++) {
        List<ContentBlock> pageBlocks = await _loadPage(ctrl, url);
        String? pageTitle = _lastTitle;
        String next = _lastNext;

        // 站方對「不受信任的用戶端」只回約 1/3 正文（見 looksTruncated）。實測差異在
        // **用戶端指紋**而非 cookie，真 WebView 通常拿得到完整版；但冷啟的無頭 WebView
        // 直接跳進深層章節 URL、沒有任何前導導覽，本身就是 bot 特徵。故先走一次正常
        // 導覽暖機（載入站台首頁、讓站方/CF 的 JS 跑過）再重試本頁，只試一次。
        if (_pageTruncated(pageBlocks) && !warmedUp) {
          warmedUp = true;
          await _warmUp(ctrl);
          pageBlocks = await _loadPage(ctrl, url);
          pageTitle = _lastTitle;
          next = _lastNext;
        }

        title ??= pageTitle;
        blocks.addAll(pageBlocks);

        // 本頁截斷 → **停止翻頁**。兩個理由：
        // (1) 後續分頁同樣不受信任，白抓；
        // (2) 更關鍵——`looksTruncated` 只認**終端**截斷（中段標記視為反爬誘餌而放行）。
        //     若繼續串接後面的分頁，截斷標記就會落到整章的中段而**驗不出來**，殘缺內容
        //     反而會通過倉儲的閘門並寫進永久快取。停在這裡才能讓標記留在尾端被攔下。
        if (_pageTruncated(pageBlocks)) break;

        final nextCid = _cid(next);
        // 只在「同一章的下一分頁」才續抓
        if (next.isNotEmpty &&
            nextCid != null &&
            nextCid == baseCid &&
            !next.contains('catalog')) {
          url = next.startsWith('http') ? next : '${AppConfig.origin}$next';
        } else {
          url = null;
        }
      }
    } finally {
      await _hw?.dispose();
      _hw = null;
    }

    return ChapterContent(title: title, blocks: blocks);
  }

  /// 最近一次 [_loadPage] 讀到的章名與下一分頁 URL（隨該次擷取更新）。
  String? _lastTitle;
  String _lastNext = '';

  /// 載入單一分頁並擷取其 blocks（順序閘門在此把關）。
  Future<List<ContentBlock>> _loadPage(
    InAppWebViewController ctrl,
    String url,
  ) async {
    _lastTitle = null;
    _lastNext = '';
    await ctrl.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
    await _awaitContentReady(ctrl, url);
    // 順序還原不可用固定延遲當同步點（慢裝置 / 冷快取 / 背景節流都會輸掉這場競態），
    // 且亂序不會有任何錯誤徵兆 → 主動驗證還原是否完成，未完成寧可失敗不快取。
    if (!await _awaitRestored(ctrl)) {
      throw ChapterOrderNotRestoredException(url);
    }

    final raw = await ctrl.evaluateJavascript(source: _js);
    final data = _decode(raw);
    if (data == null) return const <ContentBlock>[];

    _lastTitle = (data['title'] as String?)?.trim();
    _lastNext = (data['next'] as String? ?? '').trim();
    final out = <ContentBlock>[];
    for (final b in (data['blocks'] as List? ?? const [])) {
      if (b is! Map) continue;
      final v = b['v']?.toString() ?? '';
      if (v.isEmpty) continue;
      out.add(b['t'] == 'i' ? ContentBlock.image(v) : ContentBlock.text(v));
    }
    return out;
  }

  /// 本頁是否為站方的截斷版（以該頁**自己的尾端**判定）。
  ///
  /// 必須逐頁判定而非只看串接後的整章：截斷發生在第 1 頁時，若照常把第 2、3 頁接在
  /// 後面，標記就不在整章尾端了，終端判定會失效。
  static bool _pageTruncated(List<ContentBlock> pageBlocks) =>
      looksTruncated(ChapterContent(title: null, blocks: pageBlocks));

  /// 暖機：先走一次站台首頁的正常導覽，再回頭抓章節。
  ///
  /// 失敗不拋——暖機只是提高拿到完整內容的機會，不該自己變成新的失敗來源。
  Future<void> _warmUp(InAppWebViewController ctrl) async {
    try {
      await ctrl.loadUrl(
        urlRequest: URLRequest(url: WebUri(AppConfig.origin)),
      );
      // 首頁沒有 #acontent，只等文件解析完即可（同樣不等 load 事件）。
      for (int i = 0; i < 20; i++) {
        final Object? rs = await ctrl.evaluateJavascript(
          source: 'document.readyState',
        );
        if (rs != null && rs.toString() != 'loading') break;
        await Future<void>.delayed(_readyPollInterval);
      }
    } catch (_) {
      // 暖機失敗 → 直接進入重試，維持既有行為
    }
  }

  Map<String, dynamic>? _decode(Object? raw) {
    if (raw == null) return null;
    try {
      if (raw is String) return jsonDecode(raw) as Map<String, dynamic>;
      if (raw is Map) return raw.cast<String, dynamic>();
    } catch (_) {}
    return null;
  }
}
