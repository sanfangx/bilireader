import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../domain/author_repository.dart';
import 'author_remote_data_source.dart';
import 'author_repository_impl.dart';

part 'author_providers.g.dart';

@Riverpod(keepAlive: true)
AuthorRemoteDataSource authorRemoteDataSource(Ref ref) =>
    AuthorRemoteDataSource(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
AuthorRepository authorRepository(Ref ref) =>
    AuthorRepositoryImpl(ref.watch(authorRemoteDataSourceProvider));
