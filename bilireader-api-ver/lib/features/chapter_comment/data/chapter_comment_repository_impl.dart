import 'package:dio/dio.dart';

import '../../../core/network/api_result.dart';
import '../../../core/network/app_error.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/social/reaction.dart';
import '../../../core/text/chinese_converter.dart';
import '../../../core/text/relative_time.dart';
import '../domain/chapter_comment_entities.dart';
import '../domain/chapter_comment_repository.dart';
import 'chapter_comment_remote_data_source.dart';
import 'dto/chapter_comment_dtos.dart';

/// [ChapterCommentRepository] 實作。DTO→domain；顯示文字轉繁（§5.0）。
class ChapterCommentRepositoryImpl implements ChapterCommentRepository {
  ChapterCommentRepositoryImpl({
    required ChapterCommentRemoteDataSource remote,
    required ChineseConverter converter,
  }) : _remote = remote,
       _converter = converter;

  final ChapterCommentRemoteDataSource _remote;
  final ChineseConverter _converter;

  @override
  Future<ApiResult<ChapterCommentPage>> list({
    required int articleId,
    required int chapterId,
    int page = 1,
  }) => _guard(
    () async => _page(
      await _remote.list(
        articleId: articleId,
        chapterId: chapterId,
        page: page,
      ),
    ),
  );

  @override
  Future<ApiResult<ChapterCommentPage>> mine({
    required int articleId,
    required int chapterId,
    int page = 1,
  }) => _guard(
    () async => _page(
      await _remote.mine(
        articleId: articleId,
        chapterId: chapterId,
        page: page,
      ),
    ),
  );

  @override
  Future<ApiResult<int>> add({
    required int articleId,
    required int chapterId,
    required String content,
    bool isSpoiler = false,
  }) => _guard(
    () => _remote.add(
      articleId: articleId,
      chapterId: chapterId,
      content: content,
      isSpoiler: isSpoiler,
    ),
  );

  @override
  Future<ApiResult<void>> delete(int commentId) =>
      _guard(() => _remote.delete(commentId));

  @override
  Future<ApiResult<ReactionCounts>> like({
    required int commentId,
    required int type,
  }) => _guard(() async {
    final ChapterCommentReactionDto d = await _remote.like(
      commentId: commentId,
      type: type,
    );
    return ReactionCounts(
      likeNum: d.likeNum,
      badNum: d.badNum,
      myReaction: Reaction.fromValue(d.myReaction),
    );
  });

  ChapterCommentPage _page(ChapterCommentListDataDto d) => ChapterCommentPage(
    comments: d.list.map(_comment).toList(),
    pageNum: d.pageNum,
    pages: d.pages,
    total: d.total,
  );

  ChapterComment _comment(ChapterCommentItemDto e) => ChapterComment(
    // like/delete 之 commentId＝主鍵 id（對齊原 App `getId()`），非 cmtid。
    commentId: e.id,
    content: _tw(e.cmtcontent),
    commenterName: _tw(e.cmtname),
    commenterLevel: e.cmtLevel,
    avatarUrl: e.avatarUrl,
    likeNum: e.likeNum,
    badNum: e.badNum,
    myReaction: Reaction.fromValue(e.myReaction),
    addtime: _formatAddtime(e.addtime),
    isSpoiler: e.ispoiler == 1,
    isHot: e.ishot == 1,
    parentId: e.parentid,
  );

  /// 忠實移植原 App `ChapterCommentAdapter.formatAddTime`：`addtime` 為字串，
  /// 可為 epoch（秒 <1e12→×1000 為毫秒；否則已是毫秒）或日期字串。數值→相對時間；
  /// 可解析日期→相對時間；否則原樣顯示；空→null。相對時間沿用本 App 繁體慣例
  /// （[relativeTimeFromMillis]，與書評/圈子等一致；原 App 為簡體「刚刚/分钟前」，§5.0 轉繁）。
  String? _formatAddtime(String? raw) {
    final String s = (raw ?? '').trim();
    if (s.isEmpty) return null;
    final int? epoch = int.tryParse(s);
    if (epoch != null) {
      final int ms = epoch < 1000000000000 ? epoch * 1000 : epoch;
      return relativeTimeFromMillis(ms);
    }
    final DateTime? dt = DateTime.tryParse(s);
    if (dt != null) return relativeTimeFromMillis(dt.millisecondsSinceEpoch);
    return s; // 非數值且無法解析日期 → 原樣顯示
  }

  String _tw(String? text) =>
      (text == null || text.isEmpty) ? '' : _converter.toTraditionalTw(text);

  Future<ApiResult<T>> _guard<T>(Future<T> Function() body) async {
    try {
      await _converter.ensureLoaded();
      return ApiSuccess<T>(await body());
    } on DioException catch (e) {
      return ApiFailure<T>(ErrorMapper.fromDio(e));
    } on AppError catch (e) {
      return ApiFailure<T>(e);
    } on Object catch (e) {
      return ApiFailure<T>(ErrorMapper.parse(e));
    }
  }
}
