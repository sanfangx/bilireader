import 'dart:io';

import 'package:bilireader/core/network/api_result.dart';
import 'package:bilireader/core/text/chinese_converter.dart';
import 'package:bilireader/features/discover/data/book_remote_data_source.dart';
import 'package:bilireader/features/discover/data/book_repository_impl.dart';
import 'package:bilireader/features/discover/data/dto/carousel_item.dart';
import 'package:bilireader/features/discover/data/dto/novel_response_entity.dart';
import 'package:bilireader/features/discover/domain/carousel_slide.dart';
import 'package:bilireader/features/discover/domain/novel_summary.dart';
import 'package:bilireader/features/discover/domain/ranking_options.dart';
import 'package:flutter_test/flutter_test.dart';

/// 以固定 DTO 回應，驗證 repository 映射與 OpenCC 轉繁；並記錄 ranking 收到的參數。
class _FakeBookRemote implements BookRemoteDataSource {
  List<NovelResponseEntity> novels = const <NovelResponseEntity>[];
  List<CarouselItem> carousels = const <CarouselItem>[];
  List<String> tagList = const <String>[];
  RankingType? lastType;
  RankingPeriod? lastPeriod;
  NewBookSort? lastSort;

  @override
  Future<List<CarouselItem>> carousel() async => carousels;

  @override
  Future<List<NovelResponseEntity>> ranking({
    required RankingType type,
    RankingPeriod? period,
    NewBookSort? sort,
    int page = 1,
    int limit = 20,
  }) async {
    lastType = type;
    lastPeriod = period;
    lastSort = sort;
    return novels;
  }

  @override
  Future<List<NovelResponseEntity>> weekHot({
    int page = 1,
    int limit = 12,
  }) async => novels;

  @override
  Future<NovelResponseEntity> novelInfo(
    int articleId, {
    bool countVisit = true,
  }) async => novels.first;

  @override
  Future<List<NovelResponseEntity>> sameAuthor(int articleId) async => novels;

  @override
  Future<List<NovelResponseEntity>> sameTranslator(int articleId) async =>
      novels;

  @override
  Future<List<NovelResponseEntity>> alsoReading(int articleId) async => novels;

  @override
  Future<List<String>> hotSearch({int limit = 12}) async => tagList;

  @override
  Future<List<String>> tags() async => tagList;
}

void main() {
  late ChineseConverter converter;

  setUpAll(() async {
    converter = ChineseConverter(loader: (String k) => File(k).readAsString());
    await converter.ensureLoaded();
  });

  test('ranking：DTO → NovelSummary，顯示文字轉繁（s2twp）', () async {
    final _FakeBookRemote remote = _FakeBookRemote()
      ..novels = <NovelResponseEntity>[
        const NovelResponseEntity(
          articleId: 7,
          articleName: '软件之书',
          author: '张三',
          keywords: '异世界,战斗',
          fullFlag: 1,
          rateSum: 90,
          rateNum: 10,
          words: 640000,
        ),
      ];
    final BookRepositoryImpl repo = BookRepositoryImpl(
      remote: remote,
      converter: converter,
    );

    final ApiResult<List<NovelSummary>> result = await repo.ranking(
      type: RankingType.click,
      period: RankingPeriod.week,
    );
    final NovelSummary n =
        (result as ApiSuccess<List<NovelSummary>>).data.single;

    expect(n.title, '軟體之書'); // 软件→軟體
    expect(n.author, '張三');
    expect(n.tags, <String>['異世界', '戰鬥']);
    expect(n.isFinished, isTrue);
    expect(n.rating, 9.0); // 90 / 10
    expect(n.wordCount, 640000);
    // 只在對應型別送出 period（點擊榜 type=1 → 送 week）。
    expect(remote.lastType, RankingType.click);
    expect(remote.lastPeriod, RankingPeriod.week);
  });

  test('carousel：describe 轉繁', () async {
    final _FakeBookRemote remote = _FakeBookRemote()
      ..carousels = <CarouselItem>[
        const CarouselItem(articleId: 1, coverImg: 'u', describe: '编辑精选'),
      ];
    final BookRepositoryImpl repo = BookRepositoryImpl(
      remote: remote,
      converter: converter,
    );

    final ApiResult<List<CarouselSlide>> result = await repo.carousel();
    final CarouselSlide slide =
        (result as ApiSuccess<List<CarouselSlide>>).data.single;
    expect(slide.describe, '編輯精選'); // 编辑精选→編輯精選
    expect(slide.coverUrl, 'u'); // URL 不轉
  });

  test('tags：字串清單轉繁', () async {
    final _FakeBookRemote remote = _FakeBookRemote()
      ..tagList = <String>['异世界', '后宫'];
    final BookRepositoryImpl repo = BookRepositoryImpl(
      remote: remote,
      converter: converter,
    );

    final ApiResult<List<String>> result = await repo.tags();
    expect((result as ApiSuccess<List<String>>).data, <String>['異世界', '後宮']);
  });
}
