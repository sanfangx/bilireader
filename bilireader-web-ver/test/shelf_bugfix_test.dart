import 'dart:convert';

import 'package:bilireader_app/core/network/linovelib_api.dart';
import 'package:bilireader_app/core/reading/local_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:html/parser.dart' as html_parser;

/// 書架 bug 修復契約：
/// 1. ReadProgress 封面持久化（續讀卡縮圖不依賴分組清單反查）。
/// 2. 詳情頁「已收藏」旗標解析（官網收藏鈕 #a_delbookcase / #a_addbookcase）。
void main() {
  test('ReadProgress cover round-trip；舊 JSON 無 cv → null', () {
    final p = ReadProgress(
      novelId: '71',
      title: '平凡職業造就世界最強',
      chapterIndex: 3,
      totalChapters: 580,
      chapterTitle: '第一章',
      updatedAt: 100,
      cover: 'https://tw.linovelib.com/files/article/image/0/71/71s.jpg',
    );
    final back = ReadProgress.fromJson(
        jsonDecode(jsonEncode(p.toJson())) as Map<String, dynamic>);
    expect(back.cover, p.cover);
    expect(back.chapterIndex, 3);

    // 舊格式（無 cv 欄位）向下相容。
    final legacy = ReadProgress.fromJson(
        {'id': '71', 't': 'x', 'ci': 0, 'tc': 1, 'ct': '', 'ts': 0});
    expect(legacy.cover, isNull);
  });

  test('actionOkBody：處理成功頁→true；失敗/登入/非200→false（實地擷取校準）', () {
    // 實地擷取（2026-07-12）：add/remove/move 成功皆回 jieqi_showmessage「處理成功」頁。
    const successPage =
        '<html><head><title>處理成功_嗶哩輕小說</title></head>'
        '<body><h2 class="aui-center-title">處理成功</h2></body></html>';
    expect(LinovelibApi.actionOkBody(200, successPage), isTrue);

    // 明確失敗頁 → false（先於成功標記檢查）。
    expect(
        LinovelibApi.actionOkBody(
            200, '<title>處理失敗</title><h2>處理失敗</h2>'),
        isFalse);
    // 未登入導向 → false。
    expect(
        LinovelibApi.actionOkBody(200, '請先登入 location=login.php'), isFalse);
    // 非 200 → false。
    expect(LinovelibApi.actionOkBody(302, successPage), isFalse);
    // 空 / 無成功標記 → 保守判失敗（避免偽陽）。
    expect(LinovelibApi.actionOkBody(200, ''), isFalse);
    expect(LinovelibApi.actionOkBody(200, '<html>某個未預期的頁面</html>'), isFalse);
  });

  test('parseShelvedFlag：#a_delbookcase 存在 → 已收藏；否則 false', () {
    final shelved = html_parser.parse(
        '<body><a id="a_delbookcase" href="javascript:">已收藏</a></body>');
    expect(LinovelibApi.parseShelvedFlag(shelved), isTrue);

    final notShelved = html_parser.parse(
        '<body><a id="a_addbookcase" href="javascript:">書架</a></body>');
    expect(LinovelibApi.parseShelvedFlag(notShelved), isFalse);

    // 未登入（無收藏鈕）→ false。
    final guest = html_parser.parse('<body><h1>書名</h1></body>');
    expect(LinovelibApi.parseShelvedFlag(guest), isFalse);
  });
}
