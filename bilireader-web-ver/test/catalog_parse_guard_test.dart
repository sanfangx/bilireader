import 'package:bilireader_app/core/models/catalog.dart';
import 'package:bilireader_app/core/network/linovelib_api.dart';
import 'package:flutter_test/flutter_test.dart';

/// 迴歸測試：目錄解析必須把「抓失敗」與「這本沒有章節」分開（P1-6）。
///
/// 坑：dio 設了 `validateStatus:(_)=>true`，所以站方的 429／Cloudflare 挑戰頁是一個
/// **正常 Response**、也是合法 HTML。解析器找不到 `.volume-chapters` 就回「空目錄」，
/// 等於把錯誤偽裝成沒有資料，而下游全都把空目錄當合法值處理：
///   • 書架續讀 `p.chapterIndex.clamp(0, flat.length - 1)` → `clamp(0, -1)` 拋
///     ArgumentError → 落入 catch 再 pop 一次 → 把唯一的 AppShell 路由彈掉（黑畫面）；
///   • 整本下載產生一本 0 章的空書。
/// 兩者都毫無徵兆。
void main() {
  const String kChapterHtml = '''
<html><body>
  <ul class="volume-chapters">
    <li class="chapter-bar">第一卷 幼年期</li>
    <li class="volume-cover"><img src="/files/cover.jpg"></li>
    <li class="jsChapter"><a href="/novel/2013/1.html">序章</a></li>
    <li class="jsChapter"><a href="javascript:cid(9)">假連結章</a></li>
    <li class="jsChapter vip"><a href="/novel/2013/9.html">VIP 章</a></li>
  </ul>
</body></html>
''';

  test('正常目錄：卷名 / 封面 / 章節 / vip / 假連結 都照舊解析', () {
    final Catalog cat = LinovelibApi.parseCatalog(kChapterHtml);

    expect(cat.volumes.length, 1);
    expect(cat.volumes.single.name, '第一卷 幼年期');
    expect(cat.volumes.single.coverPath, '/files/cover.jpg');

    final List<Chapter> ch = cat.volumes.single.chapters;
    expect(ch.length, 3);
    expect(ch[0].title, '序章');
    expect(ch[0].url, endsWith('/novel/2013/1.html'));
    // 站方 `javascript:cid()` 假連結 → url 為 null（由閱讀鏈解析，不在此判死）。
    expect(ch[1].url, isNull);
    expect(ch[2].vip, isTrue);
  });

  test('限流／CF 挑戰頁（無目錄容器）→ 拋例外，不得回空目錄', () {
    const String challenge = '''
<html><head><title>Just a moment...</title></head>
<body><div id="challenge-platform">請稍候…</div></body></html>
''';

    expect(
      () => LinovelibApi.parseCatalog(challenge),
      throwsA(isA<CatalogUnavailableException>()),
      reason: '回空目錄會讓下游把失敗當合法值 → 書架續讀黑畫面／下載 0 章空書',
    );
  });

  test('完全空白的回應 → 同樣拋例外', () {
    expect(
      () => LinovelibApi.parseCatalog(''),
      throwsA(isA<CatalogUnavailableException>()),
    );
  });

  test('容器存在但沒有章節 → 回空目錄（那才是「這本真的還沒有章節」）', () {
    const String emptyButValid =
        '<html><body><ul class="volume-chapters"></ul></body></html>';

    final Catalog cat = LinovelibApi.parseCatalog(emptyButValid);
    expect(cat.volumes, isEmpty);
    expect(cat.chapterCount, 0);
  });

  test('沒有卷標題也能解析（章節掛在預設卷下，不得整份丟失）', () {
    const String noVolumeBar = '''
<html><body>
  <ul class="volume-chapters">
    <li class="jsChapter"><a href="/novel/7/100.html">第一話</a></li>
  </ul>
</body></html>
''';

    final Catalog cat = LinovelibApi.parseCatalog(noVolumeBar);
    expect(cat.chapterCount, 1);
    expect(cat.volumes.single.chapters.single.title, '第一話');
  });
}
