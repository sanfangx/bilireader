import 'dart:async';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../di/infra_providers.dart';
import '../router/auth_controller.dart';
import 'dio_client.dart';

part 'dio_provider.g.dart';

/// 全域 Dio（規範 §7.1）。掛上 session、強制更新與 401/666 集中處理的回呼。
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  return buildDioClient(
    session: ref.watch(authSessionManagerProvider),
    onForceUpdate: () =>
        ref.read(forceUpdateControllerProvider.notifier).require(),
    onAuthFailure: (int code) => unawaited(
      ref.read(authControllerProvider.notifier).onAuthFailure(code),
    ),
  );
}
