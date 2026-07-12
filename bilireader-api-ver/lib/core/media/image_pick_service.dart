import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

/// 圖片挑選 + 轉 Multipart 的共用服務（feature ⑦ 作者插圖/封面、圈子貼文圖片）。
///
/// Android 使用系統相片選擇器（image_picker 預設），不需額外儲存權限（§7 隱私最小化）。
/// [picker] 可注入以利測試；[toMultipart]/[toMultipartList] 為純轉換，讀 bytes 產生
/// [MultipartFile]（含檔名與依副檔名推得的 `Content-Type`），供 FormData Multipart🔒 上傳。
class ImagePickService {
  ImagePickService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  /// 從相簿選單張圖片；使用者取消回 `null`。
  Future<XFile?> pickSingle() =>
      _picker.pickImage(source: ImageSource.gallery, imageQuality: 90);

  /// 從相簿選多張圖片（可選上限）；使用者取消回空清單。
  Future<List<XFile>> pickMultiple({int? limit}) =>
      _picker.pickMultiImage(imageQuality: 90, limit: limit);

  /// 將單一 [XFile] 讀成 [MultipartFile]（供 `FormData` 上傳）。
  static Future<MultipartFile> toMultipart(
    XFile file, {
    required String field,
  }) async {
    final List<int> bytes = await file.readAsBytes();
    final String name = file.name.isEmpty ? '$field.jpg' : file.name;
    return MultipartFile.fromBytes(
      bytes,
      filename: name,
      contentType: _mediaTypeFor(name),
    );
  }

  /// 將多個 [XFile] 依序轉為 [MultipartFile] 清單（例如 `images`）。
  static Future<List<MultipartFile>> toMultipartList(
    List<XFile> files, {
    required String field,
  }) async {
    final List<MultipartFile> out = <MultipartFile>[];
    for (final XFile f in files) {
      out.add(await toMultipart(f, field: field));
    }
    return out;
  }

  /// 依副檔名推得圖片 `Content-Type`；未知則回 `application/octet-stream`。
  static MediaType _mediaTypeFor(String filename) {
    final int dot = filename.lastIndexOf('.');
    final String ext = dot == -1
        ? ''
        : filename.substring(dot + 1).toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'webp':
        return MediaType('image', 'webp');
      case 'gif':
        return MediaType('image', 'gif');
      case 'heic':
        return MediaType('image', 'heic');
      default:
        return MediaType('application', 'octet-stream');
    }
  }
}
