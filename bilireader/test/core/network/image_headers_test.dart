import 'package:bilireader/core/network/image_headers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('rewriteCdn（img3 → img2/attachment）', () {
    test('改寫 img3 前綴，其餘保留', () {
      expect(
        ImageHeaders.rewriteCdn('https://img3.readpai.com/2024/01/x.jpg'),
        'https://img2.readpai.com/attachment/2024/01/x.jpg',
      );
    });

    test('不含 img3 的 URL 原樣不動（先 trim）', () {
      expect(
        ImageHeaders.rewriteCdn('  https://img2.readpai.com/a/b.jpg  '),
        'https://img2.readpai.com/a/b.jpg',
      );
    });
  });

  group('refererFor（反盜鏈）', () {
    test('含 bilinovel.com → bilinovel referer', () {
      expect(
        ImageHeaders.refererFor('https://www.bilinovel.com/x.jpg'),
        'https://www.bilinovel.com/',
      );
    });

    test('其他主機（含 readpai）→ linovelib referer', () {
      expect(
        ImageHeaders.refererFor('https://img2.readpai.com/a.jpg'),
        'https://www.linovelib.com/',
      );
    });
  });

  group('headersFor', () {
    test('帶 Referer / 行動版 UA / Accept', () {
      final Map<String, String> h = ImageHeaders.headersFor(
        'https://img2.readpai.com/a.jpg',
      );
      expect(h['Referer'], 'https://www.linovelib.com/');
      expect(h['User-Agent'], contains('Mobile'));
      expect(h['Accept'], contains('image/webp'));
    });
  });

  group('buildAvatarUrl（uid/1000 分桶）', () {
    test('uid>0 且 avatar>0 → 組裝 URL', () {
      expect(
        ImageHeaders.buildAvatarUrl(uid: 1234567, avatar: 1),
        'https://www.bilinovel.com/files/system/avatar/1234/1234567.jpg',
      );
    });

    test('avatar<=0 → null（用預設頭像）', () {
      expect(ImageHeaders.buildAvatarUrl(uid: 1234567, avatar: 0), isNull);
    });

    test('resolveAvatarUrl 優先用非空 avatarUrl', () {
      expect(
        ImageHeaders.resolveAvatarUrl(
          avatarUrl: 'https://x/y.jpg',
          uid: 1,
          avatar: 0,
        ),
        'https://x/y.jpg',
      );
    });
  });
}
