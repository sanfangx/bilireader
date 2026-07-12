import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../../../core/storage/database/database_providers.dart';
import '../../../core/text/text_providers.dart';
import '../domain/book_repository.dart';
import '../domain/catalog_repository.dart';
import 'book_remote_data_source.dart';
import 'book_repository_impl.dart';
import 'catalog_remote_data_source.dart';
import 'catalog_repository_impl.dart';

part 'discover_providers.g.dart';

@Riverpod(keepAlive: true)
BookRemoteDataSource bookRemoteDataSource(Ref ref) =>
    BookRemoteDataSource(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
BookRepository bookRepository(Ref ref) => BookRepositoryImpl(
  remote: ref.watch(bookRemoteDataSourceProvider),
  converter: ref.watch(chineseConverterProvider),
);

@Riverpod(keepAlive: true)
CatalogRemoteDataSource catalogRemoteDataSource(Ref ref) =>
    CatalogRemoteDataSource(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
CatalogRepository catalogRepository(Ref ref) => CatalogRepositoryImpl(
  remote: ref.watch(catalogRemoteDataSourceProvider),
  cacheDao: ref.watch(chapterCacheDaoProvider),
  converter: ref.watch(chineseConverterProvider),
);
