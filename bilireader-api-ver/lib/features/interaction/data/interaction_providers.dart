import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../../../core/text/text_providers.dart';
import '../domain/interaction_repository.dart';
import 'interaction_remote_data_source.dart';
import 'interaction_repository_impl.dart';

part 'interaction_providers.g.dart';

@Riverpod(keepAlive: true)
InteractionRemoteDataSource interactionRemoteDataSource(Ref ref) =>
    InteractionRemoteDataSource(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
InteractionRepository interactionRepository(Ref ref) =>
    InteractionRepositoryImpl(
      remote: ref.watch(interactionRemoteDataSourceProvider),
      converter: ref.watch(chineseConverterProvider),
    );
