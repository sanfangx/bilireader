import 'package:bilireader/core/network/base_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BaseResponse', () {
    test('解析成功（code 200 + data）', () {
      final BaseResponse<Map<String, dynamic>> r =
          BaseResponse<Map<String, dynamic>>.fromJson(<String, dynamic>{
            'code': 200,
            'message': 'ok',
            'data': <String, dynamic>{'x': 1},
          }, (Object? d) => d! as Map<String, dynamic>);
      expect(r.code, 200);
      expect(r.message, 'ok');
      expect(r.isSuccess, isTrue);
      expect(r.data, <String, dynamic>{'x': 1});
    });

    test('相容 msg 別名', () {
      final BaseResponse<Object> r = BaseResponse<Object>.fromJson(
        <String, dynamic>{'code': 500, 'msg': '失敗', 'data': null},
        (Object? d) => d!,
      );
      expect(r.message, '失敗');
      expect(r.isSuccess, isFalse);
    });

    test('data 為 null 時 isSuccess 為 false', () {
      final BaseResponse<Object> r = BaseResponse<Object>.fromJson(
        <String, dynamic>{'code': 200, 'message': 'ok'},
        (Object? d) => d!,
      );
      expect(r.data, isNull);
      expect(r.isSuccess, isFalse);
    });

    test('code 缺失時為 -1', () {
      final BaseResponse<Object> r = BaseResponse<Object>.fromJson(
        <String, dynamic>{'message': 'x'},
        (Object? d) => d!,
      );
      expect(r.code, -1);
    });
  });

  group('BaseResponse2', () {
    test('僅 code + message，code 200 為成功', () {
      final BaseResponse2 r = BaseResponse2.fromJson(<String, dynamic>{
        'code': 200,
        'message': 'done',
      });
      expect(r.isSuccess, isTrue);
      expect(r.message, 'done');
    });

    test('相容 msg 且 code 非 200 為失敗', () {
      final BaseResponse2 r = BaseResponse2.fromJson(<String, dynamic>{
        'code': 401,
        'msg': '失效',
      });
      expect(r.isSuccess, isFalse);
      expect(r.message, '失效');
    });
  });
}
