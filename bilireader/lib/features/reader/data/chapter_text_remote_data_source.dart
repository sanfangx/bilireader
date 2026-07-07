import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/base_response.dart';
import '../../../core/network/error_mapper.dart';
import 'dto/text_request_entity.dart';

/// 章節正文端點（`novel/getNovelText`，API.md「章節內容」）。Query articleid/chapterid；
/// 需登入。回 `TextRequestEntity`（未加密 HTML）。
class ChapterTextRemoteDataSource {
  const ChapterTextRemoteDataSource(this._dio);

  final Dio _dio;

  Future<TextRequestEntity> getNovelText({
    required int articleId,
    required int chapterId,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.novelText,
      queryParameters: <String, dynamic>{
        'articleid': articleId,
        'chapterid': chapterId,
      },
    );
    final Object? body = resp.data;
    final Map<String, dynamic> map = body is Map<String, dynamic>
        ? body
        : const <String, dynamic>{};
    final BaseResponse<TextRequestEntity> base =
        BaseResponse<TextRequestEntity>.fromJson(
          map,
          (Object? d) => TextRequestEntity.fromJson(
            d is Map<String, dynamic> ? d : const <String, dynamic>{},
          ),
        );
    if (base.code != ApiConstants.codeSuccess) {
      throw ErrorMapper.fromBusinessCode(
        code: base.code,
        serverMessage: base.message,
      );
    }
    return base.data ?? const TextRequestEntity();
  }
}
