import 'package:bilireader_app/core/discovery/offsite_search.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('coverPathForId（id//1000 分片，實測 2013→2、4325→4）', () {
    test('四位數 id', () {
      expect(
        OffsiteSearch.coverPathForId('2013'),
        '/files/article/image/2/2013/2013s.jpg',
      );
      expect(
        OffsiteSearch.coverPathForId('4325'),
        '/files/article/image/4/4325/4325s.jpg',
      );
    });
    test('小於 1000 → 群組 0', () {
      expect(
        OffsiteSearch.coverPathForId('246'),
        '/files/article/image/0/246/246s.jpg',
      );
    });
    test('五位數 id', () {
      expect(
        OffsiteSearch.coverPathForId('12345'),
        '/files/article/image/12/12345/12345s.jpg',
      );
    });
    test('非數字 → null', () {
      expect(OffsiteSearch.coverPathForId('abc'), isNull);
      expect(OffsiteSearch.coverPathForId(''), isNull);
    });
  });

  group('cleanTitle（切底線中繼資料 + 去「線上看」尾綴）', () {
    test('DDG 型含作者/文庫/站名', () {
      expect(
        OffsiteSearch.cleanTitle('無職轉生～蛇足篇～小說線上看_理不盡な孫の手作品_mf文庫j_嗶哩輕小說'),
        '無職轉生～蛇足篇～',
      );
    });
    test('Google 型只有「線上看」尾綴', () {
      expect(
        OffsiteSearch.cleanTitle('無職轉生～到了異世界就拿出真本事～線上看'),
        '無職轉生～到了異世界就拿出真本事～',
      );
    });
    test('乾淨標題原樣', () {
      expect(OffsiteSearch.cleanTitle('轉生史萊姆'), '轉生史萊姆');
    });
    test('去頭尾空白', () {
      expect(OffsiteSearch.cleanTitle('  書名  '), '書名');
    });
  });

  group('summaryFor', () {
    test('組出 id/清洗後標題/推導封面', () {
      final s = OffsiteSearch.summaryFor('2013', '無職轉生～線上看_嗶哩輕小說');
      expect(s.id, '2013');
      expect(s.title, '無職轉生～');
      expect(s.coverPath, '/files/article/image/2/2013/2013s.jpg');
      // coverUrl getter 應補上 origin。
      expect(
        s.coverUrl,
        'https://tw.linovelib.com/files/article/image/2/2013/2013s.jpg',
      );
    });
  });

  group('parseResults（DDG uddg 包裝 + 去重 + 跳 URL anchor/分類頁）', () {
    // 模擬 DDG HTML：每筆一個標題 anchor（result__a）+ 一個顯示 URL 的 anchor（result__url）。
    // 同一本書以多變體出現（.html / /catalog / 章節）→ 應依 id 去重。
    const ddg = '''
<div class="results">
  <div class="result results_links">
    <a class="result__a" href="//duckduckgo.com/l/?uddg=https%3A%2F%2Ftw.linovelib.com%2Fnovel%2F2013.html&rut=x">無職轉生～到了異世界就拿出真本事～線上看_嗶哩輕小說</a>
    <a class="result__url" href="//duckduckgo.com/l/?uddg=https%3A%2F%2Ftw.linovelib.com%2Fnovel%2F2013.html">tw.linovelib.com/novel/2013.html</a>
  </div>
  <div class="result results_links">
    <a class="result__a" href="//duckduckgo.com/l/?uddg=https%3A%2F%2Ftw.linovelib.com%2Fnovel%2F2013%2Fcatalog">無職轉生～到了異世界就拿出真本事～</a>
    <a class="result__url" href="//duckduckgo.com/l/?uddg=https%3A%2F%2Ftw.linovelib.com%2Fnovel%2F2013%2Fcatalog">tw.linovelib.com/novel/2013/catalog</a>
  </div>
  <div class="result results_links">
    <a class="result__a" href="//duckduckgo.com/l/?uddg=https%3A%2F%2Ftw.linovelib.com%2Fnovel%2F4325.html">無職轉生～蛇足篇～線上看_理不盡な孫の手作品_mf文庫j_嗶哩輕小說</a>
    <a class="result__url" href="//duckduckgo.com/l/?uddg=x">tw.linovelib.com/novel/4325.html</a>
  </div>
  <div class="result results_links">
    <a class="result__a" href="//duckduckgo.com/l/?uddg=https%3A%2F%2Ftw.linovelib.com%2Ftagarticle%2F26%2F1.html">轉生輕小說</a>
  </div>
</div>
''';

    test('去重後兩本書、順序正確、標題清洗、封面推導', () {
      final r = OffsiteSearch.parseResults(ddg);
      expect(r.length, 2);
      expect(r[0].id, '2013');
      expect(r[0].title, '無職轉生～到了異世界就拿出真本事～');
      expect(r[0].coverPath, '/files/article/image/2/2013/2013s.jpg');
      expect(r[1].id, '4325');
      expect(r[1].title, '無職轉生～蛇足篇～');
    });

    test('分類頁（/tagarticle）不被當書', () {
      final r = OffsiteSearch.parseResults(ddg);
      expect(r.any((b) => b.title.contains('轉生輕小說')), isFalse);
    });

    test('limit 生效', () {
      final r = OffsiteSearch.parseResults(ddg, limit: 1);
      expect(r.length, 1);
      expect(r.first.id, '2013');
    });

    test('直接連結（非 uddg 包裝）也可解析', () {
      const direct =
          '<a href="https://tw.linovelib.com/novel/999.html">某書線上看</a>';
      final r = OffsiteSearch.parseResults(direct);
      expect(r.length, 1);
      expect(r.first.id, '999');
      expect(r.first.title, '某書');
    });

    test('空 HTML → 空清單', () {
      expect(OffsiteSearch.parseResults(''), isEmpty);
    });
  });

  group('looksBlocked / hasResultsContainer', () {
    test('空 body → blocked', () {
      expect(OffsiteSearch.looksBlocked(''), isTrue);
      expect(OffsiteSearch.looksBlocked('   '), isTrue);
    });
    test('anomaly 頁 → blocked', () {
      expect(
        OffsiteSearch.looksBlocked('<div class="anomaly-modal">...</div>'),
        isTrue,
      );
    });
    test('正常結果頁 → 非 blocked', () {
      expect(OffsiteSearch.looksBlocked('<a class="result__a">x</a>'), isFalse);
    });
    test('hasResultsContainer 認得結果容器與無結果標記', () {
      expect(
        OffsiteSearch.hasResultsContainer('<a class="result__a">'),
        isTrue,
      );
      expect(OffsiteSearch.hasResultsContainer('No results.'), isTrue);
      expect(OffsiteSearch.hasResultsContainer('<html>random</html>'), isFalse);
    });
  });

  group('引擎 URL 構造', () {
    test('DDG HTML 端點 + site: 限定', () {
      final u = OffsiteSearch.ddgHtmlUrl('無職轉生');
      expect(u.host, 'html.duckduckgo.com');
      expect(u.path, '/html/');
      expect(u.queryParameters['q'], '無職轉生 site:tw.linovelib.com');
    });
    test('Google + site: 限定', () {
      final u = OffsiteSearch.googleUrl('轉生');
      expect(u.host, 'www.google.com');
      expect(u.queryParameters['q'], '轉生 site:tw.linovelib.com');
    });
  });
}
