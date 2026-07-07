import 'package:bilireader/core/network/app_error.dart';
import 'package:bilireader/core/network/error_mapper.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final RequestOptions req = RequestOptions(path: '/x');

  group('ErrorMapper.fromDio', () {
    test('cancel → cancelled（靜默）', () {
      final AppError e = ErrorMapper.fromDio(
        DioException(requestOptions: req, type: DioExceptionType.cancel),
      );
      expect(e.kind, AppErrorKind.cancelled);
      expect(e.isCancelled, isTrue);
    });

    test('timeout → timeout + 繁中訊息', () {
      final AppError e = ErrorMapper.fromDio(
        DioException(
          requestOptions: req,
          type: DioExceptionType.connectionTimeout,
        ),
      );
      expect(e.kind, AppErrorKind.timeout);
      expect(e.message, '網路連線逾時，請稍後再試');
    });

    test('connectionError → network', () {
      final AppError e = ErrorMapper.fromDio(
        DioException(
          requestOptions: req,
          type: DioExceptionType.connectionError,
        ),
      );
      expect(e.kind, AppErrorKind.network);
      expect(e.message, '網路連線失敗');
    });

    test('badResponse 帶業務碼 401 → unauthorized', () {
      final AppError e = ErrorMapper.fromDio(
        DioException(
          requestOptions: req,
          type: DioExceptionType.badResponse,
          response: Response<dynamic>(
            requestOptions: req,
            statusCode: 200,
            data: <String, dynamic>{'code': 401, 'message': ''},
          ),
        ),
      );
      expect(e.kind, AppErrorKind.unauthorized);
      expect(e.code, 401);
      expect(e.message, '登入狀態已失效，請重新登入');
    });
  });

  group('ErrorMapper.fromBusinessCode', () {
    test('666 → unauthorized + 封禁訊息', () {
      final AppError e = ErrorMapper.fromBusinessCode(code: 666);
      expect(e.isUnauthorized, isTrue);
      expect(e.message, '帳號已被封禁，請聯絡管理員');
    });

    test('501 → forceUpdate', () {
      final AppError e = ErrorMapper.fromBusinessCode(code: 501);
      expect(e.kind, AppErrorKind.forceUpdate);
      expect(e.requiresUpdate, isTrue);
    });

    test('伺服器 message 非空時採用', () {
      final AppError e = ErrorMapper.fromBusinessCode(
        code: 400,
        serverMessage: '參數錯誤',
      );
      expect(e.kind, AppErrorKind.server);
      expect(e.message, '參數錯誤');
    });

    test('伺服器 message 空白時用繁中 fallback', () {
      final AppError e = ErrorMapper.fromBusinessCode(
        code: 400,
        serverMessage: '   ',
      );
      expect(e.message, '操作失敗');
    });
  });

  test('emptyData → 資料為空', () {
    expect(ErrorMapper.emptyData().message, '資料為空');
  });
}
