import 'dart:convert';

import 'package:bilireader/core/media/image_pick_service.dart';
import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// 驗證 XFile → MultipartFile 轉換：檔名保留、Content-Type 依副檔名推得。
void main() {
  // `.name` 取自 path 的 basename（fromData 不採用 name 參數）；設 path 以驅動副檔名推斷。
  XFile fileNamed(String name) => XFile.fromData(utf8.encode('x'), path: name);

  test('toMultipart：png → image/png，保留檔名', () async {
    final MultipartFile part = await ImagePickService.toMultipart(
      fileNamed('cover.png'),
      field: 'coverSmall',
    );
    expect(part.filename, 'cover.png');
    expect(part.contentType?.mimeType, 'image/png');
  });

  test('toMultipart：jpg → image/jpeg', () async {
    final MultipartFile part = await ImagePickService.toMultipart(
      fileNamed('a.jpg'),
      field: 'file',
    );
    expect(part.contentType?.mimeType, 'image/jpeg');
  });

  test('toMultipart：空檔名 → 以 field 命名（回退 .jpg）', () async {
    final MultipartFile part = await ImagePickService.toMultipart(
      fileNamed(''),
      field: 'images',
    );
    expect(part.filename, 'images.jpg');
    expect(part.contentType?.mimeType, 'image/jpeg');
  });

  test('toMultipart：未知副檔名 → application/octet-stream', () async {
    final MultipartFile part = await ImagePickService.toMultipart(
      fileNamed('data.bin'),
      field: 'file',
    );
    expect(part.contentType?.mimeType, 'application/octet-stream');
  });

  test('toMultipartList：多檔依序轉換', () async {
    final List<MultipartFile> parts = await ImagePickService.toMultipartList(
      <XFile>[fileNamed('1.jpg'), fileNamed('2.webp')],
      field: 'images',
    );
    expect(parts.length, 2);
    expect(parts[1].contentType?.mimeType, 'image/webp');
  });
}
