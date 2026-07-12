import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../core/app_config.dart';
import '../../core/discovery/offsite_search.dart';
import '../../core/models/novel_summary.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';

/// Path A（fallback）：當 dio 直抓 DuckDuckGo 被擋時，改用**可見的** WebView 跑站外搜尋。
///
/// 機制同登入（等離開 login.php 即判定成功）：載入搜尋結果頁後，注入 JS 偵測 linovelib
/// `/novel/{id}` 連結出現 → 擷取（書名 + id）→ 自動帶回結果並關頁。
/// 可見 WebView 的好處：若 Google 跳同意頁 / captcha，使用者能自己解（如登入時解 CF），
/// 解完連結一出現就自動擷取。也提供「改用 Google」與手動「擷取結果」。
///
/// 回傳（Navigator.pop）：`List<NovelSummary>` = 擷取到的結果；`null` = 使用者放棄。
class WebSearchFallbackPage extends StatefulWidget {
  const WebSearchFallbackPage({super.key, required this.query});
  final String query;

  @override
  State<WebSearchFallbackPage> createState() => _WebSearchFallbackPageState();
}

class _WebSearchFallbackPageState extends State<WebSearchFallbackPage> {
  InAppWebViewController? _controller;
  double _progress = 0;
  bool _done = false; // 已擷取並準備關頁，避免重複 pop
  String _engine = 'DuckDuckGo';

  // 掃全部 <a>：解開 DDG uddg / Google url?q 包裝，抓 novelId + 書名，依 id 去重。
  // 兩段式：先依相關性順序收集 id，書名優先取 anchor 內的 <h3>（Google 標題），
  // 否則取 anchor 自身文字（DDG result__a）——但**跳過整段就是 URL 的 anchor**
  // （DDG 的 result__url / Google 顯示網址），以 `^` 判「開頭即網址」而非「含網址」，
  // 因為 Google 手機把整個結果塊包成一個大 <a>，其文字含顯示 URL＋標題＋摘要。
  // 回傳 JSON 字串 [{id,title}]（與 Dart 端 OffsiteSearch parseResults 對齊）。
  static const String _extractJs = r'''
(function(){
  try {
    function idOf(a){
      var href = a.getAttribute('href') || '';
      var probe = href;
      try {
        var u = new URL(href, location.href);
        if (u.searchParams.get('uddg')) probe = decodeURIComponent(u.searchParams.get('uddg'));
        else if (u.searchParams.get('q')) probe = decodeURIComponent(u.searchParams.get('q'));
      } catch(e){}
      var m = probe.match(/novel(?:\/|%2F)(\d+)/i) || href.match(/novel(?:\/|%2F)(\d+)/i);
      return m ? m[1] : null;
    }
    var order = []; var byId = {};
    var as = document.querySelectorAll('a[href]');
    for (var i=0; i<as.length; i++){
      var a = as[i];
      var id = idOf(a);
      if (!id) continue;
      if (order.indexOf(id) === -1) order.push(id);
      if (byId[id]) continue; // 已有好書名
      var h3 = a.querySelector('h3');
      var t = h3 ? (h3.textContent||'').trim() : '';
      if (!t) {
        var at = (a.textContent||'').trim();
        // 只採「開頭不是網址且夠短」的 anchor 文字（排除大 <a> 的整段串接文字）。
        if (at && at.length < 120 &&
            !/^https?:\/\//i.test(at) && !/^[\w.-]*linovelib\.com/i.test(at)) t = at;
      }
      if (t) byId[id] = t;
    }
    var out = [];
    for (var j=0; j<order.length; j++){
      var oid = order[j];
      if (byId[oid]) { out.push({id: oid, title: byId[oid]}); if (out.length >= 25) break; }
    }
    return JSON.stringify(out);
  } catch(e){ return '[]'; }
})();
''';

  int _pollTick = 0;

  /// 頁面載入完成 → 多次輪詢擷取。Google 結果為漸進渲染，單次 onLoadStop 常過早
  /// （實測 DxD：onLoadStop 當下結果尚未進 DOM）→ 每 0.8s 重試、最多 ~6 次補上。
  void _schedulePoll() {
    _pollTick = 0;
    _pollExtract();
  }

  Future<void> _pollExtract() async {
    if (_done || !mounted) return;
    await _tryExtract();
    if (_done || !mounted) return;
    if (_pollTick++ < 6) {
      Future.delayed(const Duration(milliseconds: 800), _pollExtract);
    }
  }

  Future<void> _tryExtract() async {
    if (_done || _controller == null) return;
    final uri = (await _controller!.getUrl())?.toString() ?? '';
    // 只在真的搜尋引擎頁上擷取（避免空白/過場頁誤觸）。
    if (!(uri.contains('duckduckgo.com') || uri.contains('google.'))) return;
    final raw = await _controller!.evaluateJavascript(source: _extractJs);
    final list = _parse(raw);
    if (list.isNotEmpty && mounted && !_done) {
      _done = true;
      Navigator.of(context).pop(list);
    }
  }

  List<NovelSummary> _parse(Object? raw) {
    if (raw == null) return const [];
    try {
      final decoded = raw is String ? jsonDecode(raw) : raw;
      if (decoded is! List) return const [];
      final out = <NovelSummary>[];
      for (final e in decoded) {
        if (e is Map) {
          final id = e['id']?.toString();
          final title = e['title']?.toString() ?? '';
          if (id != null && id.isNotEmpty && title.trim().isNotEmpty) {
            out.add(OffsiteSearch.summaryFor(id, title));
          }
        }
      }
      return out;
    } catch (_) {
      return const [];
    }
  }

  void _switchEngine() {
    final next = _engine == 'DuckDuckGo' ? 'Google' : 'DuckDuckGo';
    final url = next == 'Google'
        ? OffsiteSearch.googleUrl(widget.query)
        : OffsiteSearch.ddgHtmlUrl(widget.query);
    setState(() => _engine = next);
    _controller?.loadUrl(urlRequest: URLRequest(url: WebUri(url.toString())));
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return const _WebUnsupported();
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _toolbar(),
            SizedBox(
              height: 2,
              child: _progress >= 1.0
                  ? const SizedBox.shrink()
                  : LinearProgressIndicator(
                      value: _progress == 0 ? null : _progress,
                      minHeight: 2,
                      backgroundColor: AppColors.surf,
                      color: AppColors.acc,
                    ),
            ),
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri(
                    OffsiteSearch.ddgHtmlUrl(widget.query).toString(),
                  ),
                ),
                initialSettings: InAppWebViewSettings(
                  userAgent: AppConfig.userAgent,
                  javaScriptEnabled: true,
                  transparentBackground: true,
                ),
                onWebViewCreated: (c) => _controller = c,
                onProgressChanged: (c, p) {
                  if (mounted) setState(() => _progress = p / 100);
                },
                onLoadStop: (c, uri) => _schedulePoll(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toolbar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 8, 14, 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surf,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Text(
              '‹',
              style: AppText.sans(size: 22, color: AppColors.mut),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '站外搜尋 · $_engine · ${widget.query}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.sans(size: 12, color: AppColors.txt),
            ),
          ),
          const SizedBox(width: 8),
          // 手動再擷取一次（結果已出但未自動觸發時）。
          GestureDetector(
            onTap: _tryExtract,
            child: Text(
              '擷取',
              style: AppText.sans(size: 12, color: AppColors.acc),
            ),
          ),
          const SizedBox(width: 14),
          // 換引擎（DDG 空/被擋 → 改用 Google，可自行解 captcha）。
          GestureDetector(
            onTap: _switchEngine,
            child: Text(
              _engine == 'DuckDuckGo' ? '改用 Google' : '改用 DDG',
              style: AppText.sans(size: 12, color: AppColors.acc),
            ),
          ),
        ],
      ),
    );
  }
}

/// flutter_inappwebview 不支援 web；行動裝置才有 WebView 站外搜尋。
class _WebUnsupported extends StatelessWidget {
  const _WebUnsupported();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              '站外搜尋（WebView）僅支援行動裝置',
              textAlign: TextAlign.center,
              style: AppText.sans(size: 13, color: AppColors.mut),
            ),
          ),
        ),
      ),
    );
  }
}
