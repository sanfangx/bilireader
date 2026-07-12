import 'package:bilireader_app/core/network/linovelib_api.dart';
import 'package:flutter_test/flutter_test.dart';

/// 驗證 `/user.php` 身分解析（切片① 的高風險部分：CSS 選擇器未實測，
/// 但頭像路徑規則為實測已知，故重點測頭像→userId 與 fallback 行為）。
void main() {
  group('LinovelibApi.parseUserProfileHtml', () {
    test('由頭像路徑解析出 userId 與完整頭像 URL，並取暱稱/等級', () {
      const html = '''
        <html><body>
          <div class="user-info">
            <img src="/files/system/avatar/436/436700s.jpg" />
            <span class="user-name">傲嬌</span>
            <span class="user-level">普通會員</span>
          </div>
        </body></html>
      ''';
      final p = LinovelibApi.parseUserProfileHtml(html);
      expect(p, isNotNull);
      expect(p!.userId, '436700');
      expect(p.avatarUrl,
          'https://tw.linovelib.com/files/system/avatar/436/436700s.jpg');
      expect(p.nickname, '傲嬌');
      expect(p.levelLabel, '普通會員');
      expect(p.isVip, isFalse);
    });

    test('絕對路徑頭像不重複加前綴；大圖 l 後綴也可解析', () {
      const html =
          '<img src="https://tw.linovelib.com/files/system/avatar/1/199l.jpg">';
      final p = LinovelibApi.parseUserProfileHtml(html);
      expect(p, isNotNull);
      expect(p!.userId, '199');
      expect(p.avatarUrl,
          'https://tw.linovelib.com/files/system/avatar/1/199l.jpg');
    });

    test('VIP 等級判定', () {
      const html = '''
        <img src="/files/system/avatar/1/1000s.jpg">
        <span class="member-level">VIP 會員</span>
      ''';
      final p = LinovelibApi.parseUserProfileHtml(html);
      expect(p, isNotNull);
      expect(p!.isVip, isTrue);
      expect(p.levelLabel, 'VIP 會員');
    });

    test('空 body → null', () {
      expect(LinovelibApi.parseUserProfileHtml(''), isNull);
    });

    test('無任何關鍵欄位 → null（避免把過場頁當成 profile）', () {
      expect(
        LinovelibApi.parseUserProfileHtml('<html><body>歡迎</body></html>'),
        isNull,
      );
    });

    test('只有暱稱、無頭像仍算有效（供 fallback）', () {
      final p =
          LinovelibApi.parseUserProfileHtml('<div class="username">某人</div>');
      expect(p, isNotNull);
      expect(p!.nickname, '某人');
      expect(p.userId, isNull);
      expect(p.avatarUrl, isNull);
    });
  });
}
