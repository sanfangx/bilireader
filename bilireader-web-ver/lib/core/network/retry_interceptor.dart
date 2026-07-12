import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';

import 'cf_signals.dart';

/// 對「暫時性失敗」做**指數退避重試**：純限流 429 / 閘道抖動 502·504 / 非挑戰 503 /
/// 連線逾時 / 連線中斷。真正的 CF 挑戰 **不**重試（交由 [AuthInterceptor] markExpired）；
/// 4xx 客戶端錯誤（404 等）**不**重試。
///
/// 關鍵：dio `validateStatus: (_) => true` → 429/503 是「成功」Response 走 [onResponse]，
/// 只有連線層錯誤走 [onError]，兩條路都要判。此攔截器補上先前 [AuthInterceptor] 註解
/// 承諾卻缺席的「呼叫端退避重試」——先前 429 會被 `_parseBookList` 靜默吞成空清單。
class RetryInterceptor extends Interceptor {
  RetryInterceptor(
    this._dio, {
    this.maxRetries = 3,
    this.baseDelay = const Duration(milliseconds: 500),
    this.maxDelay = const Duration(seconds: 8),
    Future<void> Function(Duration)? sleep,
    Random? random,
  })  : _sleep = sleep ?? _defaultSleep,
        _rng = random ?? Random();

  final Dio _dio;
  final int maxRetries;
  final Duration baseDelay;
  final Duration maxDelay;
  final Future<void> Function(Duration) _sleep;
  final Random _rng;

  static const String _attemptKey = '__retry_attempt';

  static Future<void> _defaultSleep(Duration d) => Future<void>.delayed(d);

  int _attempt(RequestOptions o) => (o.extra[_attemptKey] as int?) ?? 0;

  /// 純函式退避時間（毫秒）：Retry-After 優先；否則 base·2^attempt + jitter，夾到 maxMs。
  /// jitter 傳 0 得下界、傳 baseMs-1 得上界——供測試斷言區間。
  static int computeBackoffMs(
    int attempt, {
    int? retryAfterSecs,
    int baseMs = 500,
    int maxMs = 8000,
    int jitterMs = 0,
  }) {
    if (retryAfterSecs != null) {
      return (retryAfterSecs.clamp(0, 30)) * 1000;
    }
    final int expo = baseMs * (1 << attempt); // 500, 1000, 2000, ...
    return min(expo + jitterMs, maxMs);
  }

  int? _retryAfterSecs(Response r) {
    final String? v = r.headers.value('retry-after');
    if (v == null) return null;
    return int.tryParse(v.trim());
  }

  Duration _delayFor(int attempt, {int? retryAfterSecs}) {
    final int jitter = _rng.nextInt(baseDelay.inMilliseconds);
    return Duration(
      milliseconds: computeBackoffMs(
        attempt,
        retryAfterSecs: retryAfterSecs,
        baseMs: baseDelay.inMilliseconds,
        maxMs: maxDelay.inMilliseconds,
        jitterMs: jitter,
      ),
    );
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    final int attempt = _attempt(response.requestOptions);
    if (!CfSignals.isRetriableResponse(response) || attempt >= maxRetries) {
      handler.next(response);
      return;
    }
    await _sleep(_delayFor(attempt, retryAfterSecs: _retryAfterSecs(response)));
    try {
      final Response retried =
          await _refetch(response.requestOptions, attempt + 1);
      handler.resolve(retried);
    } catch (_) {
      handler.next(response); // 重試自身炸掉 → 回原 response，不吞掉結果。
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final bool transient = err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionError;
    final int attempt = _attempt(err.requestOptions);
    if (!transient || attempt >= maxRetries) {
      handler.next(err);
      return;
    }
    await _sleep(_delayFor(attempt));
    try {
      final Response retried = await _refetch(err.requestOptions, attempt + 1);
      handler.resolve(retried);
    } catch (_) {
      handler.next(err); // 仍失敗 → 回原錯誤。
    }
  }

  /// 帶著遞增的 attempt 計數重送整條攔截鏈（含限流器再取時槽、Auth 再判挑戰）。
  Future<Response> _refetch(RequestOptions options, int nextAttempt) {
    final RequestOptions opts = options.copyWith(
      extra: <String, dynamic>{...options.extra, _attemptKey: nextAttempt},
    );
    return _dio.fetch(opts);
  }
}
