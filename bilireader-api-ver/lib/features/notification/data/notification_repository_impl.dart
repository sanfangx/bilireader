import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/app_error.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/text/chinese_converter.dart';
import '../domain/notification_entities.dart';
import '../domain/notification_repository.dart';
import 'dto/notification_dtos.dart';
import 'notification_remote_data_source.dart';

/// [NotificationRepository] 實作。DTO→domain：解析 `ncontent` JSON、推斷種類、轉繁（§5.0）。
class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({
    required NotificationRemoteDataSource remote,
    required ChineseConverter converter,
  }) : _remote = remote,
       _converter = converter;

  final NotificationRemoteDataSource _remote;
  final ChineseConverter _converter;

  @override
  Future<ApiResult<NotificationPage>> list({
    required NotificationTab tab,
    int page = 1,
  }) => _guard(() async {
    final NotificationListDataDto d = await _remote.list(tab: tab, page: page);
    return NotificationPage(
      items: d.list.map(_notification).toList(),
      pageNum: d.pageNum,
      unread: d.unread,
      hasMore: d.list.length >= ApiConstants.defaultPageSize,
    );
  });

  @override
  Future<ApiResult<int>> unreadCount({NotificationTab? tab}) =>
      _guard(() => _remote.unreadCount(tab: tab));

  @override
  Future<ApiResult<void>> readAll({NotificationTab? tab}) =>
      _guard(() => _remote.readAll(tab: tab));

  @override
  Future<ApiResult<void>> read(int notifyId) =>
      _guard(() => _remote.read(notifyId));

  AppNotification _notification(AppNotificationDto e) {
    final AppNotificationContentDto? content = _parseContent(e.ncontent);
    final String name = _tw(content?.fromUserName ?? e.funame);
    final String title = _tw(content?.title);
    final String headline = title.isNotEmpty
        ? title
        : (name.isNotEmpty ? name : '新通知');
    final String body = _tw(content?.body).isNotEmpty
        ? _tw(content?.body)
        : _tw(e.ename);
    return AppNotification(
      notifyId: e.notifyid,
      kind: _kind(e.ntype, e.nstype),
      headline: headline,
      body: body,
      fromUserName: name.isEmpty ? null : name,
      addTime: e.addtime,
      isRead: e.isread == 1,
      topicId: content?.topicId ?? (e.eid == 0 ? null : e.eid),
      articleId: content?.articleId,
    );
  }

  AppNotificationContentDto? _parseContent(String? ncontent) {
    if (ncontent == null || ncontent.isEmpty) {
      return null;
    }
    try {
      final Object? decoded = jsonDecode(ncontent);
      return decoded is Map<String, dynamic>
          ? AppNotificationContentDto.fromJson(decoded)
          : null;
    } on Object {
      return null;
    }
  }

  /// 由 ntype/nstype 關鍵字最佳推斷種類（wire 值未完整列舉；未知歸 other）。
  NotificationKind _kind(String? ntype, String? nstype) {
    final String t = '${ntype ?? ''} ${nstype ?? ''}'.toLowerCase();
    if (t.contains('like') || t.contains('digg') || t.contains('讚')) {
      return NotificationKind.like;
    }
    if (t.contains('reply') || t.contains('comment') || t.contains('post')) {
      return NotificationKind.reply;
    }
    if (t.contains('flower') || t.contains('gift') || t.contains('花')) {
      return NotificationKind.flower;
    }
    if (t.contains('system') || t.contains('sys') || t.contains('announce')) {
      return NotificationKind.system;
    }
    return NotificationKind.other;
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
