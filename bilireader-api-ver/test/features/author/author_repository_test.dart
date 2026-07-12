import 'package:bilireader/core/network/api_result.dart';
import 'package:bilireader/features/author/data/author_remote_data_source.dart';
import 'package:bilireader/features/author/data/author_repository_impl.dart';
import 'package:bilireader/features/author/data/dto/author_dtos.dart';
import 'package:bilireader/features/author/domain/author_entities.dart';
import 'package:bilireader/features/discover/data/dto/novel_response_entity.dart';
import 'package:flutter_test/flutter_test.dart';

/// 以固定 DTO 驗證作者 repository 映射與「作者稿件保留原文（不轉繁）」；不觸網、不觸發
/// 任何狀態變更端點（§7.0）。未實作的 remote 方法交由 noSuchMethod（測試不會呼叫）。
class _FakeAuthorRemote implements AuthorRemoteDataSource {
  _FakeAuthorRemote({
    this.novels = const AuthorNovelListDataDto(),
    this.tree = const AuthorChapterTreeDataDto(),
    this.draftList = const <AuthorDraftItemDto>[],
  });

  final AuthorNovelListDataDto novels;
  final AuthorChapterTreeDataDto tree;
  final List<AuthorDraftItemDto> draftList;

  @override
  Future<AuthorNovelListDataDto> listMyNovels({
    required int page,
    int pageSize = 20,
  }) async => novels;

  @override
  Future<AuthorChapterTreeDataDto> chapterTree(int articleId) async => tree;

  @override
  Future<List<AuthorDraftItemDto>> listDrafts(int articleId) async => draftList;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'myNovels：NovelResponseEntity → AuthorNovel（推薦=allvote、鮮花=allflower）',
    () async {
      final AuthorRepositoryImpl repo = AuthorRepositoryImpl(
        _FakeAuthorRemote(
          novels: const AuthorNovelListDataDto(
            total: 1,
            list: <NovelResponseEntity>[
              NovelResponseEntity(
                articleId: 7,
                articleName: '星辰之上的约定', // 簡體
                fullFlag: 1,
                words: 640000,
                allVote: 18000,
                allFlower: 420,
              ),
            ],
          ),
        ),
      );
      final List<AuthorNovel> list =
          ((await repo.myNovels()) as ApiSuccess<List<AuthorNovel>>).data;
      expect(list.single.articleId, 7);
      // 作者稿件保留原文（不轉繁）：簡體標題原樣。
      expect(list.single.title, '星辰之上的约定');
      expect(list.single.isFinished, isTrue);
      expect(list.single.words, 640000);
      expect(list.single.voteCount, 18000);
      expect(list.single.flowerCount, 420);
    },
  );

  test('chapterTree：volumes 提供卷名，flat 依 volumeid 分組', () async {
    final AuthorRepositoryImpl repo = AuthorRepositoryImpl(
      _FakeAuthorRemote(
        tree: const AuthorChapterTreeDataDto(
          articleid: 7,
          articlename: '星辰之上的约定',
          volumes: <AuthorVolumeDto>[
            AuthorVolumeDto(chapterid: 100, chaptername: '第一卷'),
            AuthorVolumeDto(chapterid: 200, chaptername: '第二卷'),
          ],
          flat: <AuthorChapterRowDto>[
            AuthorChapterRowDto(chapterid: 1, volumeid: 100, chaptername: '序章'),
            AuthorChapterRowDto(
              chapterid: 2,
              volumeid: 100,
              chaptername: '第一章',
            ),
            AuthorChapterRowDto(
              chapterid: 3,
              volumeid: 200,
              chaptername: '第二章',
            ),
          ],
        ),
      ),
    );
    final AuthorChapterTree t =
        ((await repo.chapterTree(7)) as ApiSuccess<AuthorChapterTree>).data;
    final List<AuthorVolumeChapters> groups = t.grouped;
    expect(groups.length, 2);
    expect(groups.first.volumeName, '第一卷');
    expect(groups.first.chapters.length, 2);
    expect(groups.last.volumeName, '第二卷');
    expect(groups.last.chapters.single.chapterName, '第二章');
  });

  test('drafts：AuthorDraftItem → AuthorDraft（ispub 轉 bool，內容保留原文）', () async {
    final AuthorRepositoryImpl repo = AuthorRepositoryImpl(
      _FakeAuthorRemote(
        draftList: const <AuthorDraftItemDto>[
          AuthorDraftItemDto(
            draftid: 9,
            articleid: 7,
            volumeid: 100,
            chaptername: '草稿章',
            chaptercontent: '这是简体草稿',
          ),
        ],
      ),
    );
    final List<AuthorDraft> drafts =
        ((await repo.drafts(7)) as ApiSuccess<List<AuthorDraft>>).data;
    expect(drafts.single.draftId, 9);
    expect(drafts.single.isPub, isFalse);
    expect(drafts.single.chapterContent, '这是简体草稿'); // 保留原文
  });
}
