import 'dart:io';

import 'package:bilireader/core/constants/api_constants.dart';
import 'package:bilireader/core/network/api_result.dart';
import 'package:bilireader/core/text/chinese_converter.dart';
import 'package:bilireader/features/discover/data/dto/novel_response_entity.dart';
import 'package:bilireader/features/discover/data/search_remote_data_source.dart';
import 'package:bilireader/features/discover/data/search_repository_impl.dart';
import 'package:bilireader/features/discover/domain/novel_summary.dart';
import 'package:bilireader/features/discover/domain/search_result.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// 依 searchKey 回傳預設結果，並記錄收到的 key / page（驗證 fallback 與分頁行為）。
class _FakeSearchRemote implements SearchRemoteDataSource {
  _FakeSearchRemote(this.byKey);

  final Map<String, List<NovelResponseEntity>> byKey;
  final List<String> receivedKeys = <String>[];
  final List<int> receivedPages = <int>[];

  @override
  Future<List<NovelResponseEntity>> searchNovel({
    required String searchKey,
    required int pageNum,
    int pageSize = ApiConstants.searchPageSize,
    CancelToken? cancelToken,
  }) async {
    receivedKeys.add(searchKey);
    receivedPages.add(pageNum);
    return byKey[searchKey] ?? const <NovelResponseEntity>[];
  }

  @override
  Future<List<NovelResponseEntity>> searchByTag({
    required String tagName,
    String? sortBy,
    required int pageNum,
    int pageSize = ApiConstants.searchPageSize,
    CancelToken? cancelToken,
  }) async {
    receivedKeys.add(tagName);
    receivedPages.add(pageNum);
    return byKey[tagName] ?? const <NovelResponseEntity>[];
  }

  @override
  Future<List<NovelResponseEntity>> filterNovel({
    required List<String> tagNames,
    int? filterFullFlag,
    int? minWords,
    String? sortBy,
    required int pageNum,
    int pageSize = ApiConstants.searchPageSize,
    CancelToken? cancelToken,
  }) async {
    final String key = tagNames.join(',');
    receivedKeys.add(key);
    receivedPages.add(pageNum);
    return byKey[key] ?? const <NovelResponseEntity>[];
  }
}

void main() {
  late ChineseConverter converter;

  setUpAll(() async {
    converter = ChineseConverter(loader: (String k) => File(k).readAsString());
    await converter.ensureLoaded();
  });

  test('繁體有結果 → 不做 fallback，只打一次', () async {
    final _FakeSearchRemote remote = _FakeSearchRemote(
      <String, List<NovelResponseEntity>>{
        '測試': <NovelResponseEntity>[
          const NovelResponseEntity(articleId: 1, articleName: '测试小说'),
        ],
      },
    );
    final SearchRepositoryImpl repo = SearchRepositoryImpl(
      remote: remote,
      converter: converter,
    );

    final ApiResult<SearchResult> result = await repo.search(query: '測試');
    final SearchResult r = (result as ApiSuccess<SearchResult>).data;

    expect(remote.receivedKeys, <String>['測試']);
    expect(r.usedSimplifiedFallback, isFalse);
    expect(r.items.single.title, '測試小說'); // 顯示轉繁
  });

  test('繁體空結果 → OpenCC 轉簡 fallback 一次，結果轉回繁', () async {
    final _FakeSearchRemote remote = _FakeSearchRemote(
      <String, List<NovelResponseEntity>>{
        '國家': const <NovelResponseEntity>[],
        '国家': <NovelResponseEntity>[
          const NovelResponseEntity(
            articleId: 9,
            articleName: '国家兴亡',
            author: '张三',
          ),
        ],
      },
    );
    final SearchRepositoryImpl repo = SearchRepositoryImpl(
      remote: remote,
      converter: converter,
    );

    final ApiResult<SearchResult> result = await repo.search(query: '國家');
    final SearchResult r = (result as ApiSuccess<SearchResult>).data;

    // 先繁體、再簡體，最多兩次。
    expect(remote.receivedKeys, <String>['國家', '国家']);
    expect(r.usedSimplifiedFallback, isTrue);
    expect(r.backendQuery, '国家');
    expect(r.items.single.title, '國家興亡'); // 顯示轉回繁
    expect(r.items.single.author, '張三');
  });

  test('標籤篩選：繁體空 → 簡體 fallback，結果轉回繁（tagName 路徑）', () async {
    final _FakeSearchRemote remote = _FakeSearchRemote(
      <String, List<NovelResponseEntity>>{
        '戀愛': const <NovelResponseEntity>[],
        '恋爱': <NovelResponseEntity>[
          const NovelResponseEntity(articleId: 3, articleName: '恋爱物语'),
        ],
      },
    );
    final SearchRepositoryImpl repo = SearchRepositoryImpl(
      remote: remote,
      converter: converter,
    );

    final ApiResult<SearchResult> result = await repo.searchByTag(
      tag: '戀愛',
      sortBy: 'postdate',
    );
    final SearchResult r = (result as ApiSuccess<SearchResult>).data;

    expect(remote.receivedKeys, <String>['戀愛', '恋爱']);
    expect(r.usedSimplifiedFallback, isTrue);
    expect(r.items.single.title, '戀愛物語'); // 顯示轉回繁
  });

  test('文庫篩選：多選題材繁體空 → 簡體 fallback（filter/tagNames）', () async {
    final _FakeSearchRemote remote = _FakeSearchRemote(
      <String, List<NovelResponseEntity>>{
        '戀愛': const <NovelResponseEntity>[],
        '恋爱': <NovelResponseEntity>[
          const NovelResponseEntity(articleId: 8, articleName: '恋爱喜剧'),
        ],
      },
    );
    final SearchRepositoryImpl repo = SearchRepositoryImpl(
      remote: remote,
      converter: converter,
    );

    final ApiResult<SearchResult> result = await repo.filter(
      tags: <String>['戀愛'],
      fullFlagOnly: true,
      minWords: 200000,
    );
    final SearchResult r = (result as ApiSuccess<SearchResult>).data;

    expect(remote.receivedKeys, <String>['戀愛', '恋爱']);
    expect(r.usedSimplifiedFallback, isTrue);
    expect(r.items.single.title, '戀愛喜劇'); // 顯示轉回繁
  });

  test('分頁沿用先前成功的 backend variant，不重做 fallback', () async {
    final _FakeSearchRemote remote = _FakeSearchRemote(
      <String, List<NovelResponseEntity>>{
        '国家': <NovelResponseEntity>[
          const NovelResponseEntity(articleId: 9, articleName: '国家'),
        ],
      },
    );
    final SearchRepositoryImpl repo = SearchRepositoryImpl(
      remote: remote,
      converter: converter,
    );
    const SearchResult previous = SearchResult(
      items: <NovelSummary>[],
      backendQuery: '国家',
      usedSimplifiedFallback: true,
      page: 1,
    );

    await repo.search(query: '國家', page: 2, previous: previous);

    // 只用簡體 variant 打第 2 頁，不先試繁體。
    expect(remote.receivedKeys, <String>['国家']);
    expect(remote.receivedPages, <int>[2]);
  });
}
