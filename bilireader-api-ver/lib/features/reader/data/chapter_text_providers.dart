import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../../../core/storage/database/database_providers.dart';
import '../domain/chapter_text_repository.dart';
import 'chapter_text_remote_data_source.dart';
import 'chapter_text_repository_impl.dart';

part 'chapter_text_providers.g.dart';

@Riverpod(keepAlive: true)
ChapterTextRemoteDataSource chapterTextRemoteDataSource(Ref ref) =>
    ChapterTextRemoteDataSource(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
ChapterTextRepository chapterTextRepository(Ref ref) =>
    ChapterTextRepositoryImpl(
      remote: ref.watch(chapterTextRemoteDataSourceProvider),
      cacheDao: ref.watch(chapterCacheDaoProvider),
    );
