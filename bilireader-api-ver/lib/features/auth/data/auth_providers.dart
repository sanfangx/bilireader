import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/infra_providers.dart';
import '../../../core/network/dio_provider.dart';
import '../domain/auth_repository.dart';
import 'auth_remote_data_source.dart';
import 'auth_repository_impl.dart';
import 'device_id_resolver.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
AuthRemoteDataSource authRemoteDataSource(Ref ref) =>
    AuthRemoteDataSource(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
DeviceIdResolver deviceIdResolver(Ref ref) => DeviceIdResolver();

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => AuthRepositoryImpl(
  remote: ref.watch(authRemoteDataSourceProvider),
  session: ref.watch(authSessionManagerProvider),
  deviceIdResolver: ref.watch(deviceIdResolverProvider),
);
