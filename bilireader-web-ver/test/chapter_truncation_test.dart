import 'package:bilireader_app/core/storage/database/app_database.dart';
import 'package:bilireader_app/features/reader/content_block.dart';
import 'package:bilireader_app/features/reader/data/chapter_content_source.dart';
import 'package:bilireader_app/features/reader/data/chapter_text_assembler.dart';
import 'package:bilireader_app/features/reader/data/chapter_text_repository.dart';
import 'package:bilireader_app/features/reader/domain/chapter_text.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// 站方「信任分級截斷」防線（靜默壞掉防線之二）。
///
/// 背景（2026-07-25 curl 矩陣 + Claude for Chrome 實測）：tw.linovelib / m.bilinovel /
/// www.bilinovel 對**不受信任的請求**只送出約 1/3 段落，在正文中途硬切後接上
/// 「（內容加載失敗！請重載或更換瀏覽器）」「【…暫不支持電腦端閱讀…】」。
/// 觸發條件與 UA / Referer / Accept / Sec-Fetch / HTTP 版本皆無關，**與 cookie 也無關**
/// （同一 Chrome 用 `credentials:'omit'` 不送任何 cookie 仍拿到完整內容）——剩下的分野是
/// 用戶端指紋（TLS/JA3、HTTP2 設定、header 順序）。
///
/// 危險之處：截斷版是**合法 HTML、帶著數十段真實內文**，會直接通過 `hasRenderableContent`
/// 這種「非空即有效」的檢查，被當成正常章節寫進 drift 永久快取 → 使用者之後每次開都是
/// 殘缺的，且沒有任何錯誤徵兆。
class _FakeSource implements ChapterContentSource {
  _FakeSource(this._content);

  final ChapterContent Function(String url) _content;
  int loadCount = 0;

  @override
  Future<ChapterContent> load(String url) async {
    loadCount++;
    return _content(url);
  }
}

/// 實測抓到的截斷尾段（正文在「要……」處硬切）。
const String _truncatedTail =
    '要……（內容加載失敗！請重載或更換瀏覽器）'
    '【手機版頁面由於相容性問題暫不支持電腦端閱讀，請使用手機閱讀。】';

ChapterContent _truncatedBody() => ChapterContent(
  title: '序章',
  blocks: <ContentBlock>[
    ContentBlock.text('本人現年三十四歲，居所不定也沒有職業。'),
    ContentBlock.text(_truncatedTail),
  ],
);

ChapterContent _goodBody() => ChapterContent(
  title: '序章',
  blocks: <ContentBlock>[
    ContentBlock.text('本人現年三十四歲，居所不定也沒有職業。'),
    ContentBlock.text('是個體型略胖，其貌不揚，正在對人生感到後悔的好人。'),
  ],
);

void main() {
  group('containsTruncationMarker（純函式）', () {
    test('繁體標記（tw.linovelib）', () {
      expect(containsTruncationMarker(_truncatedTail), isTrue);
    });

    test('簡體標記（m./www.bilinovel）', () {
      expect(
        containsTruncationMarker('要……（内容加载失败！请重载或更换浏览器）'),
        isTrue,
      );
      expect(containsTruncationMarker('【…暂不支持电脑端阅读…】'), isTrue);
    });

    test('正常內文不誤判', () {
      expect(
        containsTruncationMarker('他打開電腦，畫面卻遲遲沒有反應，像是壞掉了。'),
        isFalse,
      );
      expect(containsTruncationMarker(''), isFalse);
    });
  });

  group('looksTruncated vs hasRenderableContent', () {
    test('截斷版會通過 hasRenderableContent —— 這正是它危險的原因', () {
      final ChapterContent c = _truncatedBody();
      expect(hasRenderableContent(c), isTrue); // 舊防線攔不住
      expect(looksTruncated(c), isTrue); // 新防線攔得住
    });

    test('完整內容不被誤判為截斷', () {
      expect(looksTruncated(_goodBody()), isFalse);
    });

    test('標記與內文因 <center> 拆成相鄰 block 仍算終端截斷', () {
      expect(
        looksTruncated(ChapterContent(title: '序章', blocks: <ContentBlock>[
          ContentBlock.text('本人現年三十四歲。'),
          ContentBlock.text('要……（內容加載失敗！請重載或更換瀏覽器）'),
          ContentBlock.text('【手機版頁面由於相容性問題暫不支持電腦端閱讀，請使用手機閱讀。】'),
        ])),
        isTrue,
      );
    });
  });

  // 鐵律：Never pre-block chapters based on HTML markers —— 站方慣於用誤導性標記勸退
  // 爬蟲（目錄假 VIP 鎖、壞掉的 javascript:cid 連結皆是前例）。標記是證據不是判決。
  group('鐵律：標記不得成為封鎖章節的判決', () {
    test('標記出現在中段（誘餌特徵）→ 不視為截斷，照常放行', () {
      final ChapterContent c = ChapterContent(
        title: '序章',
        blocks: <ContentBlock>[
          ContentBlock.text('第一段。'),
          ContentBlock.text('（內容加載失敗！請重載或更換瀏覽器）'), // 誘餌塞在中間
          ContentBlock.text('第三段。'),
          ContentBlock.text('第四段，正文正常結束。'),
          ContentBlock.text('第五段，正文正常結束。'),
        ],
      );
      expect(
        looksTruncated(c),
        isFalse,
        reason: '若見字即擋，站方只要把這串字塞進完整內容就能封鎖整章',
      );
    });

    test('判定為截斷時，例外仍帶出已擷取的正文供使用者選擇閱讀', () async {
      final AppDatabase db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final ChapterTextRepository repo = ChapterTextRepository(
        source: _FakeSource((_) => _truncatedBody()),
        cacheDao: db.chapterCacheDao,
      );

      Object? caught;
      try {
        await repo.getChapterText(
          articleId: 2013,
          chapterId: 72034,
          url: 'https://tw.linovelib.com/novel/2013/72034.html',
        );
      } catch (e) {
        caught = e;
      }
      final ChapterContentTruncatedException e =
          caught! as ChapterContentTruncatedException;
      expect(e.partial.text, contains('本人現年三十四歲'),
          reason: '截斷的那部分是真實正文，讀一部分好過完全讀不到');
      expect(e.partial.chapterName, '序章');
      expect(await repo.isCached(articleId: 2013, chapterId: 72034), isFalse,
          reason: '可以讀，但不可以快取');
    });
  });

  // 「只認終端截斷」是為了遵守鐵律（中段標記＝誘餌，不得封鎖章節），但它讓分頁串接
  // 產生一個新風險：截斷若發生在第 1 分頁，照常把第 2、3 頁接上去，標記就落到整章中段
  // 而驗不出來。故 ChapterExtractor 必須**逐頁**判定並在截斷的那一頁停止翻頁。
  group('分頁串接的終端不變式', () {
    test('截斷頁後面若還接了其他分頁 → 終端判定會失效（故擷取端必須提早停止）', () {
      final ChapterContent keptConcatenating = ChapterContent(
        title: '序章',
        blocks: <ContentBlock>[
          ContentBlock.text('第一頁第一段。'),
          ContentBlock.text(_truncatedTail), // 第 1 頁在此被截斷
          ContentBlock.text('第二頁第一段。'), // …卻還是把第 2 頁接了上來
          ContentBlock.text('第二頁第二段。'),
          ContentBlock.text('第二頁第三段。'),
        ],
      );
      expect(
        looksTruncated(keptConcatenating),
        isFalse,
        reason: '標記被推到中段 → 驗不出來 → 殘缺內容會被寫進永久快取',
      );
    });

    test('在截斷頁停止 → 標記留在尾端，攔得下來', () {
      final ChapterContent stoppedEarly = ChapterContent(
        title: '序章',
        blocks: <ContentBlock>[
          ContentBlock.text('第一頁第一段。'),
          ContentBlock.text(_truncatedTail),
        ],
      );
      expect(looksTruncated(stoppedEarly), isTrue);
    });
  });

  group('倉儲層：截斷內容不得寫入快取', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase(NativeDatabase.memory()));
    tearDown(() => db.close());

    test('擷取到截斷內容 → 拋例外且不寫快取', () async {
      final _FakeSource src = _FakeSource((_) => _truncatedBody());
      final ChapterTextRepository repo = ChapterTextRepository(
        source: src,
        cacheDao: db.chapterCacheDao,
      );

      await expectLater(
        repo.getChapterText(
          articleId: 2013,
          chapterId: 72034,
          url: 'https://tw.linovelib.com/novel/2013/72034.html',
        ),
        throwsA(isA<ChapterContentTruncatedException>()),
      );
      expect(
        await repo.isCached(articleId: 2013, chapterId: 72034),
        isFalse,
        reason: '截斷內容一旦入快取就會永久固化',
      );
    });

    test('已固化的截斷快取 → 命中時就地刪除並重抓（自癒）', () async {
      // 模擬「偵測上線前」已寫進快取的壞內容。
      await db.chapterCacheDao.saveChapterContent(
        articleId: 2013,
        chapterId: 72034,
        payload: '{"name":"序章","text":"$_truncatedTail","images":[],'
            '"isImage":false,"isbody":0}',
        updatedAt: 1,
      );
      final _FakeSource src = _FakeSource((_) => _goodBody());
      final ChapterTextRepository repo = ChapterTextRepository(
        source: src,
        cacheDao: db.chapterCacheDao,
        clockMs: () => 2,
      );

      final ChapterText t = await repo.getChapterText(
        articleId: 2013,
        chapterId: 72034,
        url: 'https://tw.linovelib.com/novel/2013/72034.html',
      );
      expect(src.loadCount, 1, reason: '壞快取應被丟棄並重新擷取，而非直接回傳');
      expect(containsTruncationMarker(t.text), isFalse);
      expect(await repo.isCached(articleId: 2013, chapterId: 72034), isTrue);
    });

    // 讀取端若比寫入端嚴格，中段帶標記的章節就會「寫得進去、讀不出來」→ 每次開啟都
    // 刪快取重抓（約 15 秒 WebView 擷取），永遠命不中且毫無徵兆。
    test('中段帶標記的章節：寫得進去，也必須讀得出來（不得每次重抓）', () async {
      final ChapterContent decoyInMiddle = ChapterContent(
        title: '序章',
        blocks: <ContentBlock>[
          ContentBlock.text('第一段。'),
          ContentBlock.text('（內容加載失敗！請重載或更換瀏覽器）'), // 誘餌
          ContentBlock.text('第三段。'),
          ContentBlock.text('第四段。'),
          ContentBlock.text('第五段，正文正常結束。'),
        ],
      );
      final _FakeSource src = _FakeSource((_) => decoyInMiddle);
      final ChapterTextRepository repo = ChapterTextRepository(
        source: src,
        cacheDao: db.chapterCacheDao,
        clockMs: () => 1,
      );
      const String url = 'https://tw.linovelib.com/novel/2013/72034.html';

      await repo.getChapterText(articleId: 2013, chapterId: 72034, url: url);
      await repo.getChapterText(articleId: 2013, chapterId: 72034, url: url);
      await repo.getChapterText(articleId: 2013, chapterId: 72034, url: url);
      expect(src.loadCount, 1, reason: '寫入放行卻讀取判壞 → 會變成永久重抓迴圈');
      expect(await repo.isCached(articleId: 2013, chapterId: 72034), isTrue);
    });

    test('標記只出現在章名 → 不觸發自癒刪除', () async {
      await db.chapterCacheDao.saveChapterContent(
        articleId: 2013,
        chapterId: 72034,
        payload: '{"name":"內容加載失敗之章","text":"正文完好，正常結束。",'
            '"images":[],"isImage":false,"isbody":0}',
        updatedAt: 1,
      );
      final _FakeSource src = _FakeSource((_) => _goodBody());
      final ChapterTextRepository repo = ChapterTextRepository(
        source: src,
        cacheDao: db.chapterCacheDao,
        clockMs: () => 2,
      );

      final ChapterText t = await repo.getChapterText(
        articleId: 2013,
        chapterId: 72034,
        url: 'https://tw.linovelib.com/novel/2013/72034.html',
      );
      expect(src.loadCount, 0, reason: '章名命中不該讓正文完好的快取被丟棄');
      expect(t.chapterName, '內容加載失敗之章');
    });

    test('乾淨的快取照常命中，不受影響', () async {
      final _FakeSource src = _FakeSource((_) => _goodBody());
      final ChapterTextRepository repo = ChapterTextRepository(
        source: src,
        cacheDao: db.chapterCacheDao,
        clockMs: () => 1,
      );
      const String url = 'https://tw.linovelib.com/novel/2013/72034.html';

      await repo.getChapterText(articleId: 2013, chapterId: 72034, url: url);
      await repo.getChapterText(articleId: 2013, chapterId: 72034, url: url);
      expect(src.loadCount, 1);
    });

    test('截斷的離線檔不被採用，改走線上重抓', () async {
      final _FakeSource src = _FakeSource((_) => _goodBody());
      final ChapterTextRepository repo = ChapterTextRepository(
        source: src,
        cacheDao: db.chapterCacheDao,
        offlineLookup: (int a, int c) async => _truncatedBody(),
        clockMs: () => 1,
      );

      final ChapterText t = await repo.getChapterText(
        articleId: 2013,
        chapterId: 72034,
        url: 'https://tw.linovelib.com/novel/2013/72034.html',
      );
      expect(src.loadCount, 1);
      expect(containsTruncationMarker(t.text), isFalse);
    });
  });

  // 讀取端（已合成整章文字）與寫入端（逐 block）必須是同一套「只認終端」語意。
  group('assembledTailLooksTruncated 與 looksTruncated 語意一致', () {
    test('終端截斷：兩者都判為 true', () {
      final ChapterContent c = _truncatedBody();
      expect(looksTruncated(c), isTrue);
      expect(
        assembledTailLooksTruncated('本人現年三十四歲，居所不定也沒有職業。\n'
            '$_truncatedTail'),
        isTrue,
      );
    });

    test('中段誘餌：兩者都判為 false', () {
      final String longTail = List<String>.filled(30, '正常段落。').join('\n');
      expect(
        assembledTailLooksTruncated('（內容加載失敗！請重載或更換瀏覽器）\n$longTail'),
        isFalse,
        reason: '標記距結尾夠遠 → 不是終端截斷',
      );
    });

    test('空字串 / 短內容不誤判', () {
      expect(assembledTailLooksTruncated(''), isFalse);
      expect(assembledTailLooksTruncated('短短一段正常內容。'), isFalse);
    });
  });

  group('clearChapterContents（使用者自救入口）', () {
    test('清空所有章節正文並回傳筆數', () async {
      final AppDatabase db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      for (int i = 1; i <= 3; i++) {
        await db.chapterCacheDao.saveChapterContent(
          articleId: 2013,
          chapterId: i,
          payload: '{"name":"x","text":"y","images":[],'
              '"isImage":false,"isbody":0}',
          updatedAt: 1,
        );
      }
      expect(await db.chapterCacheDao.clearChapterContents(), 3);
      expect(await db.chapterCacheDao.getChapterContent(2013, 1), isNull);
    });
  });
}
