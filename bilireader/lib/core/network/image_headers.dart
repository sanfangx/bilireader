/// 圖片載入的 CDN 改寫與反盜鏈 header（規範 §7.6，對照 apk/docs/flutter/07）。
///
/// 原生 `ImageLoaderKt` / `AvatarLoader` 對所有封面、正文插圖與頭像都：
/// 1. 把 `https://img3.readpai.com` 前綴改寫為 `https://img2.readpai.com/attachment`；
/// 2. 依 URL 是否含 `bilinovel.com` 決定 Referer；
/// 3. 帶行動版 Chrome UA、Accept、Accept-Language。
///
/// 集中於此，避免各 Widget 散落字串處理（規範 §7.6）。
abstract final class ImageHeaders {
  static const String _img3 = 'https://img3.readpai.com';
  static const String _img2Attachment = 'https://img2.readpai.com/attachment';

  static const String _refererBilinovel = 'https://www.bilinovel.com/';
  static const String _refererLinovelib = 'https://www.linovelib.com/';

  /// 行動版 Chrome UA（doc 07 §2.1：原生兩處 UA 皆為 Mobile，非桌面）。
  static const String _mobileUa =
      'Mozilla/5.0 (Linux; Android 13; Pixel 6) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/124.0.0.0 Mobile Safari/537.36';

  static const String _accept = 'image/webp,image/apng,image/*,*/*;q=0.9';
  static const String _acceptLanguage = 'zh-CN,zh;q=0.9,en-US;q=0.8,en;q=0.7';

  static const String _avatarPrefixBilinovel =
      'https://www.bilinovel.com/files/system/avatar/';

  /// 把正文/封面 URL 中所有 `img3.readpai.com` 前綴改寫為 `img2/attachment`；
  /// 其餘 URL 原樣保留（先 `trim`）。
  static String rewriteCdn(String rawUrl) =>
      rawUrl.trim().replaceAll(_img3, _img2Attachment);

  /// 反盜鏈 Referer：URL（不分大小寫）含 `bilinovel.com` 用 bilinovel，
  /// 否則一律用 linovelib（含 img2/img3.readpai.com 等）。
  static String refererFor(String url) =>
      url.toLowerCase().contains('bilinovel.com')
      ? _refererBilinovel
      : _refererLinovelib;

  /// 供 `cached_network_image` 的 `httpHeaders`：Referer/UA/Accept。
  /// 傳入的 [url] 應為改寫後的最終 URL。
  static Map<String, String> headersFor(String url) => <String, String>{
    'Referer': refererFor(url),
    'User-Agent': _mobileUa,
    'Accept': _accept,
    'Accept-Language': _acceptLanguage,
  };

  /// 組裝頭像 URL（doc 07 §2.3）：`{prefix}/{uid~/1000}/{uid}.jpg`。
  /// 前置條件 `uid > 0 && avatar > 0`，否則回 null（改用預設頭像）。
  /// 優先使用 API 直接回傳的 `avatarUrl`（見 [resolveAvatarUrl]）。
  static String? buildAvatarUrl({required int uid, required int avatar}) {
    if (uid <= 0 || avatar <= 0) {
      return null;
    }
    final int bucket = uid ~/ 1000;
    return '$_avatarPrefixBilinovel$bucket/$uid.jpg';
  }

  /// 頭像 URL 選擇：優先非空白的 [avatarUrl]，否則以 uid/avatar 組裝。
  static String? resolveAvatarUrl({
    String? avatarUrl,
    required int uid,
    required int avatar,
  }) {
    if (avatarUrl != null && avatarUrl.trim().isNotEmpty) {
      return avatarUrl.trim();
    }
    return buildAvatarUrl(uid: uid, avatar: avatar);
  }
}
