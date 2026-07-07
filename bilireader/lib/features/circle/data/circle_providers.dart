import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../../../core/text/text_providers.dart';
import '../domain/circle_repository.dart';
import 'circle_remote_data_source.dart';
import 'circle_repository_impl.dart';

part 'circle_providers.g.dart';

@Riverpod(keepAlive: true)
CircleRemoteDataSource circleRemoteDataSource(Ref ref) =>
    CircleRemoteDataSource(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
CircleRepository circleRepository(Ref ref) => CircleRepositoryImpl(
  remote: ref.watch(circleRemoteDataSourceProvider),
  converter: ref.watch(chineseConverterProvider),
);
