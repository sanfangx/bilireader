import 'package:bilireader_app/core/models/book_review.dart';
import 'package:flutter_test/flutter_test.dart';

/// 書評列表解析（選擇器對齊 tw.linovelib 實測 DOM，樣本取自 /reviews_2013_1.html）。
const String _sampleHtml = '''
<ol class="book-ol book-ol-comment" id="list_content">
  <li class="book-li">
    <a href="/reviewshow_145966_1.html" class="book-layout">
      <div class="book-author-vv">
        <img class="book-author-avatar lazyload"
             data-src="https://tw.linovelib.com/files/system/avatar/590/590494.jpg"
             src="https://tw.linovelib.com/images/noavatar.png" alt="erenyegar頭像">
      </div>
      <div class="book-sell">
        <div class="book-meta-comment">
          <div class="book-meta-l">
            <em>erenyegar</em>
            <span class="tag-small-group origin-left">
              <em class="tag-small red"></em>
            </span>
          </div>
          <div class="book-meta-r">66/0<svg class="icon icon-comment"><use xlink:href="#icon-comment"></use></svg></div>
        </div>
        <time class="book-comment-time">06-09 01:55</time>
        <div class="book-comment-p">心目中異世界最高的山，最長的河！劇情與人物描寫十分頂級...</div>
      </div>
    </a>
  </li>
  <li class="book-li">
    <a href="/reviewshow_146233_1.html" class="book-layout">
      <div class="book-author-vv">
        <img class="book-author-avatar lazyload"
             src="https://tw.linovelib.com/images/noavatar.png" alt="happyfish頭像">
      </div>
      <div class="book-sell">
        <div class="book-meta-comment">
          <div class="book-meta-l"><em>happyfish</em></div>
          <div class="book-meta-r">31/2<svg class="icon"></svg></div>
        </div>
        <time class="book-comment-time">06-19 21:00</time>
        <div class="book-comment-p">異世界經典還是值得一看...</div>
      </div>
    </a>
  </li>
</ol>
''';

void main() {
  test('parseReviewList 擷取欄位（id/作者/頭像/時間/讚·回覆/預覽/詳情路徑）', () {
    final List<BookReview> reviews = parseReviewList(_sampleHtml);
    expect(reviews.length, 2);

    final BookReview a = reviews.first;
    expect(a.id, '145966');
    expect(a.author, 'erenyegar'); // .book-meta-l > em（非 tag-small em）
    expect(
      a.avatarUrl,
      'https://tw.linovelib.com/files/system/avatar/590/590494.jpg',
    ); // data-src 優先於 noavatar 佔位 src
    expect(a.timeText, '06-09 01:55');
    expect(a.likes, 66);
    expect(a.replies, 0);
    expect(a.preview.startsWith('心目中異世界最高的山'), isTrue);
    expect(a.detailPath, '/reviewshow_145966_1.html');
    expect(a.detailUrl, 'https://tw.linovelib.com/reviewshow_145966_1.html');

    final BookReview b = reviews[1];
    expect(b.id, '146233');
    expect(b.author, 'happyfish');
    expect(b.likes, 31);
    expect(b.replies, 2);
    // 無 data-src → 退回 src（noavatar 佔位）。
    expect(b.avatarUrl, 'https://tw.linovelib.com/images/noavatar.png');
  });

  test('空/無 li → 空清單', () {
    expect(parseReviewList('<html><body></body></html>'), isEmpty);
    expect(parseReviewList(''), isEmpty);
  });
}
