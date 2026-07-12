import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/base_response.dart';
import '../../../core/network/error_mapper.dart';
import '../domain/notification_entities.dart';
import 'dto/notification_dtos.dart';

/// 通知端點（API.md §8.6 notification/*）。皆 Query；需登入。
class NotificationRemoteDataSource {
  const NotificationRemoteDataSource(this._dio);

  final Dio _dio;

  Future<NotificationListDataDto> list({
    required NotificationTab tab,
    required int page,
    int pageSize = ApiConstants.defaultPageSize,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.notificationList,
      queryParameters: <String, dynamic>{
        'pageNum': page,
        'pageSize': pageSize,
        'type': tab.type,
      },
    );
    final BaseResponse<NotificationListDataDto> base = _base(
      resp,
      (Object? d) => NotificationListDataDto.fromJson(_map(d)),
    );
    _ensure(base);
    return base.data ?? const NotificationListDataDto();
  }

  Future<int> unreadCount({NotificationTab? tab}) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.notificationUnreadCount,
      queryParameters: <String, dynamic>{'type': ?tab?.type},
    );
    final BaseResponse<int> base = _base(resp, _asInt);
    _ensure(base);
    return base.data ?? 0;
  }

  Future<void> readAll({NotificationTab? tab}) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.notificationReadAll,
      queryParameters: <String, dynamic>{'type': ?tab?.type},
    );
    _ensure(_base(resp, (Object? d) => d));
  }

  Future<void> read(int notifyId) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.notificationRead,
      queryParameters: <String, dynamic>{'notifyId': notifyId},
    );
    _ensure(_base(resp, (Object? d) => d));
  }

  // ---- helpers ----

  int _asInt(Object? d) {
    if (d is num) {
      return d.toInt();
    }
    if (d is Map<String, dynamic>) {
      final Object? v = d['unread'] ?? d['count'];
      return v is num ? v.toInt() : 0;
    }
    return int.tryParse('${d ?? ''}') ?? 0;
  }

  Map<String, dynamic> _map(Object? d) =>
      d is Map<String, dynamic> ? d : const <String, dynamic>{};

  BaseResponse<T> _base<T>(
    Response<dynamic> resp,
    T Function(Object? data) fromData,
  ) {
    final Object? body = resp.data;
    final Map<String, dynamic> map = body is Map<String, dynamic>
        ? body
        : const <String, dynamic>{};
    return BaseResponse<T>.fromJson(map, fromData);
  }

  void _ensure<T>(BaseResponse<T> base) {
    if (base.code != ApiConstants.codeSuccess) {
      throw ErrorMapper.fromBusinessCode(
        code: base.code,
        serverMessage: base.message,
      );
    }
  }
}
