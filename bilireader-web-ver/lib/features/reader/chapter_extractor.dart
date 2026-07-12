import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../core/app_config.dart';
import 'content_block.dart';

/// 章節「渲染擷取」器。
///
/// 用無頭 WebView 載入章節頁，讓站方 chapterlog.js 自動還原被打亂的段落，
/// 再擷取「真正可見」的 #acontent 段落（過濾 position:absolute / height:0 的誘餌）。
/// 自動串接同章分頁（ReadParams.url_next，cid 相同者）。
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

  HeadlessInAppWebView? _hw;
  Completer<void>? _loaded;

  static String? _cid(String url) =>
      RegExp(r'/(\d+)(?:_\d+)?\.html').firstMatch(url)?.group(1);

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
      onLoadStop: (controller, url) {
        if (!(_loaded?.isCompleted ?? true)) _loaded!.complete();
      },
    );
    await _hw!.run();
    final ctrl = _hw!.webViewController!;

    try {
      String? url = startUrl;
      for (int page = 0; page < 15 && url != null; page++) {
        _loaded = Completer<void>();
        await ctrl.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
        await _loaded!.future
            .timeout(const Duration(seconds: 25), onTimeout: () {});
        // 給 chapterlog.js 跑完還原段落
        await Future<void>.delayed(const Duration(milliseconds: 450));

        final raw = await ctrl.evaluateJavascript(source: _js);
        final data = _decode(raw);
        if (data == null) break;

        title ??= (data['title'] as String?)?.trim();
        for (final b in (data['blocks'] as List? ?? const [])) {
          if (b is! Map) continue;
          final v = b['v']?.toString() ?? '';
          if (v.isEmpty) continue;
          if (b['t'] == 'i') {
            blocks.add(ContentBlock.image(v));
          } else {
            blocks.add(ContentBlock.text(v));
          }
        }

        final next = (data['next'] as String? ?? '').trim();
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

  Map<String, dynamic>? _decode(Object? raw) {
    if (raw == null) return null;
    try {
      if (raw is String) return jsonDecode(raw) as Map<String, dynamic>;
      if (raw is Map) return raw.cast<String, dynamic>();
    } catch (_) {}
    return null;
  }
}
