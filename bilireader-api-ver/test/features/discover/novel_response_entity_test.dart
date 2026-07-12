import 'package:bilireader/features/discover/data/dto/novel_response_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // 鎖定實測 API 的 wire 型別（規範 §3）：`lastupdate` 為秒級時間戳 int、
  // `lastupdates` 為日期字串——曾因誤判型別導致 getNovelInfo 解析失敗。
  test('fromJson：lastupdate=int 時間戳、lastupdates=日期字串，皆可解析', () {
    final NovelResponseEntity e =
        NovelResponseEntity.fromJson(<String, dynamic>{
          'articleid': 5131,
          'articlename': '挚友的女朋友喜欢我',
          'author': '老佛爷',
          'lastupdate': 1782045285,
          'lastupdates': '2026-06-21',
          'lastvolume': '第二卷',
          'words': 147308,
          'fullflag': 0,
          'ratenum': 42,
          'ratesum': 410,
          'cover': 'https://img2.readpai.com/image/5/5131/5131s.jpg',
        });

    expect(e.articleId, 5131);
    expect(e.lastUpdate, 1782045285);
    expect(e.lastUpdates, '2026-06-21');
    expect(e.lastVolume, '第二卷');
    expect(e.ratingAvg, closeTo(9.76, 0.01)); // 410 / 42
    expect(e.isFinished, isFalse);
  });

  test('fromJson：缺欄位 → 數值預設 0、字串為 null', () {
    final NovelResponseEntity e = NovelResponseEntity.fromJson(
      <String, dynamic>{'articleid': 1},
    );
    expect(e.articleId, 1);
    expect(e.lastUpdate, isNull);
    expect(e.words, 0);
    expect(e.author, isNull);
  });
}
