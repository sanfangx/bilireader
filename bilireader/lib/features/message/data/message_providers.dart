import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../../../core/storage/database/database_providers.dart';
import '../../../core/text/text_providers.dart';
import '../../../core/ws/ws_providers.dart';
import '../domain/message_repository.dart';
import 'message_remote_data_source.dart';
import 'message_repository_impl.dart';

part 'message_providers.g.dart';

@Riverpod(keepAlive: true)
MessageRemoteDataSource messageRemoteDataSource(Ref ref) =>
    MessageRemoteDataSource(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
MessageRepository messageRepository(Ref ref) => MessageRepositoryImpl(
  remote: ref.watch(messageRemoteDataSourceProvider),
  dao: ref.watch(privateMessageDaoProvider),
  chatSocket: ref.watch(chatSocketProvider),
  converter: ref.watch(chineseConverterProvider),
);
