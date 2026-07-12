import 'dart:io';

import 'package:bilireader/core/network/api_result.dart';
import 'package:bilireader/core/text/chinese_converter.dart';
import 'package:bilireader/features/notification/data/dto/notification_dtos.dart';
import 'package:bilireader/features/notification/data/notification_remote_data_source.dart';
import 'package:bilireader/features/notification/data/notification_repository_impl.dart';
import 'package:bilireader/features/notification/domain/notification_entities.dart';
import 'package:flutter_test/flutter_test.dart';

/// 以固定 DTO 回應驗證通知 repository：ncontent JSON 解析、種類推斷、OpenCC 轉繁。
class _FakeNotifRemote implements NotificationRemoteDataSource {
  NotificationListDataDto listData = const NotificationListDataDto();
  int unread = 0;

  @override
  Future<NotificationListDataDto> list({
    required NotificationTab tab,
    required int page,
    int pageSize = 20,
  }) async => listData;

  @override
  Future<int> unreadCount({NotificationTab? tab}) async => unread;

  @override
  Future<void> readAll({NotificationTab? tab}) async {}

  @override
  Future<void> read(int notifyId) async {}
}

void main() {
  late ChineseConverter converter;

  setUpAll(() async {
    converter = ChineseConverter(loader: (String k) => File(k).readAsString());
    await converter.ensureLoaded();
  });

  NotificationRepositoryImpl build(_FakeNotifRemote remote) =>
      NotificationRepositoryImpl(remote: remote, converter: converter);

  test('list：解析 ncontent JSON → headline/body，推斷種類，轉繁', () async {
    final _FakeNotifRemote remote = _FakeNotifRemote()
      ..listData = const NotificationListDataDto(
        list: <AppNotificationDto>[
          AppNotificationDto(
            notifyid: 5,
            ntype: 'digg_review', // 讚
            funame: '张三',
            addtime: 1700000000,
            ncontent: '{"title":"张三 赞了你的书评","body":"节奏明快"}',
          ),
        ],
        unread: 3,
      );
    final NotificationPage p =
        ((await build(remote).list(tab: NotificationTab.interaction))
                as ApiSuccess<NotificationPage>)
            .data;
    final AppNotification n = p.items.single;
    expect(n.notifyId, 5);
    expect(n.kind, NotificationKind.like);
    expect(n.headline, '張三 讚了你的書評'); // ncontent title 轉繁
    expect(n.body, '節奏明快');
    expect(n.isRead, isFalse);
    expect(p.unread, 3);
  });

  test('ncontent 缺 title 時以發文者名為 headline；種類未知 → other', () async {
    final _FakeNotifRemote remote = _FakeNotifRemote()
      ..listData = const NotificationListDataDto(
        list: <AppNotificationDto>[
          AppNotificationDto(notifyid: 8, funame: '李四', ntype: 'weird'),
        ],
      );
    final AppNotification n =
        ((await build(remote).list(tab: NotificationTab.post))
                as ApiSuccess<NotificationPage>)
            .data
            .items
            .single;
    expect(n.headline, '李四');
    expect(n.kind, NotificationKind.other);
  });
}
