import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../../../core/text/text_providers.dart';
import '../domain/system_repository.dart';
import 'system_remote_data_source.dart';
import 'system_repository_impl.dart';

part 'system_providers.g.dart';

@Riverpod(keepAlive: true)
SystemRemoteDataSource systemRemoteDataSource(Ref ref) =>
    SystemRemoteDataSource(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
SystemRepository systemRepository(Ref ref) => SystemRepositoryImpl(
  remote: ref.watch(systemRemoteDataSourceProvider),
  converter: ref.watch(chineseConverterProvider),
);
