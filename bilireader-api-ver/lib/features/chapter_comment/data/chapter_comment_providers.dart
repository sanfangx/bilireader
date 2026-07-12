import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../../../core/text/text_providers.dart';
import '../domain/chapter_comment_repository.dart';
import 'chapter_comment_remote_data_source.dart';
import 'chapter_comment_repository_impl.dart';

part 'chapter_comment_providers.g.dart';

@Riverpod(keepAlive: true)
ChapterCommentRemoteDataSource chapterCommentRemoteDataSource(Ref ref) =>
    ChapterCommentRemoteDataSource(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
ChapterCommentRepository chapterCommentRepository(Ref ref) =>
    ChapterCommentRepositoryImpl(
      remote: ref.watch(chapterCommentRemoteDataSourceProvider),
      converter: ref.watch(chineseConverterProvider),
    );
