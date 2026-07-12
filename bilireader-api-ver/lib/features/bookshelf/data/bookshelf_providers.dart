import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../../../core/text/text_providers.dart';
import '../domain/bookcase_repository.dart';
import 'bookcase_remote_data_source.dart';
import 'bookcase_repository_impl.dart';

part 'bookshelf_providers.g.dart';

@Riverpod(keepAlive: true)
BookcaseRemoteDataSource bookcaseRemoteDataSource(Ref ref) =>
    BookcaseRemoteDataSource(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
BookcaseRepository bookcaseRepository(Ref ref) => BookcaseRepositoryImpl(
  remote: ref.watch(bookcaseRemoteDataSourceProvider),
  converter: ref.watch(chineseConverterProvider),
);
