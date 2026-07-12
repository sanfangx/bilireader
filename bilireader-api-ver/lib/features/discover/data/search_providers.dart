import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../../../core/text/text_providers.dart';
import '../domain/search_repository.dart';
import 'search_remote_data_source.dart';
import 'search_repository_impl.dart';

part 'search_providers.g.dart';

@Riverpod(keepAlive: true)
SearchRemoteDataSource searchRemoteDataSource(Ref ref) =>
    SearchRemoteDataSource(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
SearchRepository searchRepository(Ref ref) => SearchRepositoryImpl(
  remote: ref.watch(searchRemoteDataSourceProvider),
  converter: ref.watch(chineseConverterProvider),
);
