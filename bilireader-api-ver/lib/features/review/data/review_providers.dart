import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../../../core/text/text_providers.dart';
import '../domain/review_repository.dart';
import 'review_remote_data_source.dart';
import 'review_repository_impl.dart';

part 'review_providers.g.dart';

@Riverpod(keepAlive: true)
ReviewRemoteDataSource reviewRemoteDataSource(Ref ref) =>
    ReviewRemoteDataSource(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
ReviewRepository reviewRepository(Ref ref) => ReviewRepositoryImpl(
  remote: ref.watch(reviewRemoteDataSourceProvider),
  converter: ref.watch(chineseConverterProvider),
);
