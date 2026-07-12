import 'package:bilireader_app/core/models/topic.dart';
import 'package:flutter_test/flutter_test.dart';

/// 圈子列表解析（選擇器對齊 tw.linovelib /alltopics 實測 DOM）。
const String _sampleHtml = '''
<ol class="book-ol book-ol-comment" id="list_content">
  <li class="book-li">
    <a href="https://tw.linovelib.com/showtopic/26475_1" class="book-layout">
      <div class="book-author-vv">
        <img class="book-author-avatar"
             src="https://tw.linovelib.com/files/system/avatar/891/891980.jpg" alt="zzkr頭像">
      </div>
      <div class="book-sell">
        <h4 class="book-title">大學延畢了怎麼辦？</h4>
        <div class="book-meta">
          <div class="book-meta-l">
            <span class="book-author">生活雜談 | 07-10 16:06</span>
          </div>
          <div class="book-meta-r">
            <span class="tag-small-group origin-right">
              <em class="tag-small blue">41/1 <svg class="icon icon-comment"></svg></em>
            </span>
          </div>
        </div>
        <div class="book-comment-p">延畢了，補考的數學沒過，和父母商量...</div>
      </div>
    </a>
  </li>
</ol>
''';

void main() {
  test('parseTopicList 擷取欄位（id/標題/頭像/分類時間/讚·回覆/預覽/詳情URL）', () {
    final List<Topic> topics = parseTopicList(_sampleHtml);
    expect(topics.length, 1);
    final Topic t = topics.first;
    expect(t.id, '26475');
    expect(t.title, '大學延畢了怎麼辦？');
    expect(t.avatarUrl,
        'https://tw.linovelib.com/files/system/avatar/891/891980.jpg');
    expect(t.meta, '生活雜談 | 07-10 16:06');
    expect(t.likes, 41);
    expect(t.replies, 1);
    expect(t.preview.startsWith('延畢了'), isTrue);
    expect(t.detailUrl, 'https://tw.linovelib.com/showtopic/26475_1');
  });

  test('空 → 空清單', () {
    expect(parseTopicList('<html></html>'), isEmpty);
  });
}
