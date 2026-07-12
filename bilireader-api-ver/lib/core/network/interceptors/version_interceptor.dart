import 'package:dio/dio.dart';

import '../../constants/api_constants.dart';

/// 版本 header 攔截器（規範 §7.0，對照 VersionInterceptor）。
/// 每個請求加上 App-Version-Code / App-Version-Name；`Accept-Language: zh-CN`
/// 僅在 [acceptLanguageResolver] 回傳非空時送出（本 App 預設繁中，預設不送）。
class VersionInterceptor extends Interceptor {
  VersionInterceptor({String? Function()? acceptLanguageResolver})
    : _acceptLanguageResolver = acceptLanguageResolver;

  final String? Function()? _acceptLanguageResolver;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[ApiConstants.headerVersionCode] =
        ApiConstants.appVersionCode;
    options.headers[ApiConstants.headerVersionName] =
        ApiConstants.appVersionName;

    final String? acceptLanguage = _acceptLanguageResolver?.call();
    if (acceptLanguage != null && acceptLanguage.isNotEmpty) {
      options.headers[ApiConstants.headerAcceptLanguage] = acceptLanguage;
    }
    handler.next(options);
  }
}
