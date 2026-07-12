import 'package:bilireader/features/auth/data/device_id_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final DeviceIdResolver resolver = DeviceIdResolver();

  test('每次 resolve() 皆為全新隨機值（不綁硬體、不持久化）', () async {
    final String a = await resolver.resolve();
    final String b = await resolver.resolve();
    final String c = await resolver.resolve();
    expect(a, isNot(b));
    expect(b, isNot(c));
    expect(a, isNot(c));
  });

  test('格式：32 hex、去除 dash', () async {
    final String id = await resolver.resolve();
    expect(id.length, 32);
    expect(id.contains('-'), isFalse);
    expect(RegExp(r'^[0-9a-f]{32}$').hasMatch(id), isTrue);
  });
}
