import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../../../core/text/text_providers.dart';
import '../domain/notification_repository.dart';
import 'notification_remote_data_source.dart';
import 'notification_repository_impl.dart';

part 'notification_providers.g.dart';

@Riverpod(keepAlive: true)
NotificationRemoteDataSource notificationRemoteDataSource(Ref ref) =>
    NotificationRemoteDataSource(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
NotificationRepository notificationRepository(Ref ref) =>
    NotificationRepositoryImpl(
      remote: ref.watch(notificationRemoteDataSourceProvider),
      converter: ref.watch(chineseConverterProvider),
    );
