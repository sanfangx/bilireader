import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/base_response.dart';
import '../../../core/network/error_mapper.dart';
import 'dto/chapter_data.dart';

/// 章節目錄端點（`novel/getchapter`，Body `articleid`，回 `ChapterData`）。
class CatalogRemoteDataSource {
  const CatalogRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ChapterData> getChapterCatalog(int articleId) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.chapterCatalog,
      data: <String, dynamic>{'articleid': articleId},
    );
    final Object? body = resp.data;
    final Map<String, dynamic> map = body is Map<String, dynamic>
        ? body
        : const <String, dynamic>{};
    final BaseResponse<ChapterData> base = BaseResponse<ChapterData>.fromJson(
      map,
      (Object? d) => ChapterData.fromJson(d! as Map<String, dynamic>),
    );
    if (!base.isSuccess) {
      throw ErrorMapper.fromBusinessCode(
        code: base.code,
        serverMessage: base.message,
      );
    }
    return base.data!;
  }
}
