import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../../constants/api_constants.dart';
import '../../crypto/bnup2_signer.dart';

/// BNUP2 上傳簽章攔截器（規範 §7.4）。委派 [Bnup2Signer] 對 7 個受保護 POST 路徑
/// 且帶非空 Authorization 的請求加上三個 `X-App-Upload-*` header。必須排在
/// AuthorizationInterceptor 之後（需讀到 Authorization header）。
class UploadSignatureInterceptor extends Interceptor {
  UploadSignatureInterceptor({Uuid? uuid, int Function()? clockMs})
    : _uuid = uuid ?? const Uuid(),
      _clockMs = clockMs;

  final Uuid _uuid;
  final int Function()? _clockMs;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final String token =
        (options.headers[ApiConstants.headerAuthorization] ?? '').toString();
    final String timestamp =
        (_clockMs?.call() ?? DateTime.now().millisecondsSinceEpoch).toString();
    final String nonce = _uuid.v4().replaceAll('-', '');

    final Map<String, String> headers = Bnup2Signer.signatureHeaders(
      method: options.method,
      uri: options.uri,
      token: token,
      timestamp: timestamp,
      nonce: nonce,
    );
    options.headers.addAll(headers);
    handler.next(options);
  }
}
