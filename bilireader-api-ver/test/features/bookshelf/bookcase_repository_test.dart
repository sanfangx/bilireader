import 'dart:io';

import 'package:bilireader/core/network/api_result.dart';
import 'package:bilireader/core/text/chinese_converter.dart';
import 'package:bilireader/features/bookshelf/data/bookcase_remote_data_source.dart';
import 'package:bilireader/features/bookshelf/data/bookcase_repository_impl.dart';
import 'package:bilireader/features/bookshelf/data/dto/bookshelf_item.dart';
import 'package:bilireader/features/bookshelf/domain/bookcase_options.dart';
import 'package:bilireader/features/bookshelf/domain/bookshelf_entry.dart';
import 'package:flutter_test/flutter_test.dart';

/// 以固定 DTO / Map 回應驗證 repository 映射與 OpenCC 轉繁；不觸網。
class _FakeBookcaseRemote implements BookcaseRemoteDataSource {
  List<BookshelfItem> items = const <BookshelfItem>[];
  Map<String, dynamic> checkResult = const <String, dynamic>{};

  @override
  Future<List<BookshelfItem>> list({
    required BookcaseClass classFilter,
    required BookshelfSort sort,
  }) async => items;

  @override
  Future<String> add({
    required int articleId,
    required String articleName,
    required int classId,
    int? chapterId,
    String? chapterName,
    int? chapterOrder,
    int? pageId,
  }) async => '已加入書架';

  @override
  Future<String> delete(int caseId) async => '已移除';

  @override
  Future<String> updateClass({
    required int caseId,
    required int classId,
  }) async => '已更新分類';

  @override
  Future<Map<String, dynamic>> check(int articleId) async => checkResult;
}

void main() {
  late ChineseConverter converter;

  setUpAll(() async {
    converter = ChineseConverter(loader: (String k) => File(k).readAsString());
    await converter.ensureLoaded();
  });

  test('list：BookshelfItem → BookshelfEntry，顯示文字轉繁', () async {
    final _FakeBookcaseRemote remote = _FakeBookcaseRemote()
      ..items = const <BookshelfItem>[
        BookshelfItem(
          caseid: 11,
          articleid: 7,
          articlename: '软件之书',
          author: '张三',
          poster: 'https://img/p.jpg',
          classid: 1,
          chapterid: 300,
          chaptername: '第一章 开始',
          chapterorder: 1,
          progress: 42,
          words: 640000,
        ),
      ];
    final BookcaseRepositoryImpl repo = BookcaseRepositoryImpl(
      remote: remote,
      converter: converter,
    );

    final ApiResult<List<BookshelfEntry>> result = await repo.list();
    final BookshelfEntry e =
        (result as ApiSuccess<List<BookshelfEntry>>).data.single;

    expect(e.caseId, 11);
    expect(e.articleId, 7);
    expect(e.title, '軟體之書'); // 软件→軟體
    expect(e.author, '張三');
    expect(e.coverUrl, 'https://img/p.jpg');
    expect(e.chapterName, '第一章 開始');
    expect(e.progress, 42);
    expect(e.progressRatio, closeTo(0.42, 1e-9));
  });

  test('check：有正 caseid → 已在書架；空 Map → 未收藏', () async {
    final _FakeBookcaseRemote remote = _FakeBookcaseRemote();
    final BookcaseRepositoryImpl repo = BookcaseRepositoryImpl(
      remote: remote,
      converter: converter,
    );

    remote.checkResult = <String, dynamic>{'caseid': 5};
    expect(((await repo.check(7)) as ApiSuccess<bool>).data, isTrue);

    remote.checkResult = <String, dynamic>{};
    expect(((await repo.check(7)) as ApiSuccess<bool>).data, isFalse);

    remote.checkResult = <String, dynamic>{'inBookcase': true};
    expect(((await repo.check(7)) as ApiSuccess<bool>).data, isTrue);
  });

  test('progressRatio：夾在 0–1', () {
    const BookshelfEntry over = BookshelfEntry(
      caseId: 1,
      articleId: 1,
      title: 't',
      coverUrl: '',
      progress: 150,
    );
    expect(over.progressRatio, 1.0);
  });
}
