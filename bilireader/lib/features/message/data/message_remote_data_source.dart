import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/base_response.dart';
import '../../../core/network/error_mapper.dart';
import 'dto/message_dtos.dart';

/// 私訊 REST 端點（API.md §8.6 message/*）。送訊走 WebSocket（見 repo）。皆需登入。
class MessageRemoteDataSource {
  const MessageRemoteDataSource(this._dio);

  final Dio _dio;

  Future<PrivateConversationListDataDto> conversations({
    required int page,
    int pageSize = ApiConstants.defaultPageSize,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.messageConversations,
      queryParameters: <String, dynamic>{'pageNum': page, 'pageSize': pageSize},
    );
    final BaseResponse<PrivateConversationListDataDto> base = _base(
      resp,
      (Object? d) => PrivateConversationListDataDto.fromJson(_map(d)),
    );
    _ensure(base);
    return base.data ?? const PrivateConversationListDataDto();
  }

  Future<PrivateMessageHistoryDataDto> history({
    required int peerId,
    required int page,
    int pageSize = 30,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.messageHistory,
      queryParameters: <String, dynamic>{
        'peerId': peerId,
        'pageNum': page,
        'pageSize': pageSize,
      },
    );
    final BaseResponse<PrivateMessageHistoryDataDto> base = _base(
      resp,
      (Object? d) => PrivateMessageHistoryDataDto.fromJson(_map(d)),
    );
    _ensure(base);
    return base.data ?? const PrivateMessageHistoryDataDto();
  }

  Future<int> unreadCount() async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.messageUnreadCount,
    );
    final BaseResponse<int> base = _base(resp, (Object? d) {
      if (d is num) {
        return d.toInt();
      }
      final Object? v = d is Map<String, dynamic> ? d['unread'] : null;
      return v is num ? v.toInt() : 0;
    });
    _ensure(base);
    return base.data ?? 0;
  }

  Future<void> markRead(int peerId) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.messageRead,
      queryParameters: <String, dynamic>{'peerId': peerId},
    );
    _ensure(_base(resp, (Object? d) => d));
  }

  Future<void> block(int peerId) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.messageBlock,
      queryParameters: <String, dynamic>{'peerId': peerId},
    );
    _ensure(_base(resp, (Object? d) => d));
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
