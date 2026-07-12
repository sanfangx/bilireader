import 'package:bilireader/features/system/domain/feedback_options.dart';
import 'package:bilireader/features/system/domain/system_entities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeedbackSort / FeedbackType（值取自反編譯 FeedbackActivity）', () {
    test('reportSort 為 1-based：建議1/錯誤2/投訴3/申請4', () {
      expect(FeedbackSort.suggestion.value, 1);
      expect(FeedbackSort.error.value, 2);
      expect(FeedbackSort.complaint.value, 3);
      expect(FeedbackSort.apply.value, 4);
    });

    test('建議細項值：網站功能1/頁面美工2/求書許願3/其他0', () {
      final List<FeedbackType> t = FeedbackSort.suggestion.types;
      expect(t.map((FeedbackType e) => e.value).toList(), <int>[1, 2, 3, 0]);
      expect(t.last.label, '其他');
      expect(t.last.value, 0); // 其他=0 為合法值
    });

    test('每個分類末項皆為「其他」= 0', () {
      for (final FeedbackSort s in FeedbackSort.values) {
        expect(s.types.last.value, 0, reason: '${s.label} 末項應為其他=0');
        expect(s.types.last.label, '其他');
      }
    });
  });

  group('StartupAnnouncement 去重語意', () {
    test('identityKey：dismissKey 優先，缺則 system_block_<bid>', () {
      expect(
        const StartupAnnouncement(dismissKey: 'spring').identityKey,
        'spring',
      );
      expect(const StartupAnnouncement(bid: 7).identityKey, 'system_block_7');
      expect(const StartupAnnouncement().identityKey, 'system_block_0');
    });

    test('signatureSource：內容變動即產生不同簽章（會重新彈出）', () {
      const StartupAnnouncement a = StartupAnnouncement(
        title: 'T',
        content: 'A',
      );
      const StartupAnnouncement b = StartupAnnouncement(
        title: 'T',
        content: 'B',
      );
      expect(a.signatureSource == b.signatureSource, isFalse);
    });

    test('hasAction：僅 http/https 顯示行動按鈕', () {
      expect(
        const StartupAnnouncement(actionUrl: 'https://x').hasAction,
        isTrue,
      );
      expect(
        const StartupAnnouncement(actionUrl: 'http://x').hasAction,
        isTrue,
      );
      expect(
        const StartupAnnouncement(actionUrl: 'ftp://x').hasAction,
        isFalse,
      );
      expect(const StartupAnnouncement().hasAction, isFalse);
    });

    test('hasAction：大小寫不敏感（HTTPS://）', () {
      expect(
        const StartupAnnouncement(actionUrl: 'HTTPS://x').hasAction,
        isTrue,
      );
      expect(
        const StartupAnnouncement(actionUrl: '  Http://x  ').hasAction,
        isTrue,
      );
    });

    test('hasContent：標題或內文其一非空', () {
      expect(const StartupAnnouncement(title: 'T').hasContent, isTrue);
      expect(const StartupAnnouncement(content: 'C').hasContent, isTrue);
      expect(const StartupAnnouncement().hasContent, isFalse);
      expect(const StartupAnnouncement(title: '  ').hasContent, isFalse);
    });
  });
}
