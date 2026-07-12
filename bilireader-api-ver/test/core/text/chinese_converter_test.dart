import 'dart:io';

import 'package:bilireader/core/text/chinese_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ChineseConverter converter;

  setUpAll(() async {
    // 以檔案系統載入打包字典（測試 cwd 為套件根目錄）。
    converter = ChineseConverter(loader: (String k) => File(k).readAsString());
    await converter.ensureLoaded();
  });

  group('toTraditionalTw（簡→繁台灣，顯示）', () {
    test('字元級簡→繁', () {
      expect(converter.toTraditionalTw('简体中文'), '簡體中文');
      expect(converter.toTraditionalTw('国家学习'), '國家學習');
    });

    test('台灣片語（s2twp idiom）：软件→軟體、网络→網路', () {
      expect(converter.toTraditionalTw('软件'), '軟體');
      expect(converter.toTraditionalTw('网络'), '網路');
    });

    test('已是繁體則維持不變', () {
      expect(converter.toTraditionalTw('測試繁體'), '測試繁體');
    });

    test('台灣字元變體（TWVariants）：不得留 OpenCC 標準繁體異體（使用者回報）', () {
      // 迴歸：TWVariants.txt 曾為「空白分隔＋簡體 key」→ 解析為空 dict → 台灣變體全失效，
      // 使用者看到 纔/爲/麪/着/裏。改用官方 tab 分隔、繁體 key 的 TWVariants 後應正確。
      expect(converter.toTraditionalTw('才不是'), '才不是'); // 非「纔不是」
      expect(converter.toTraditionalTw('因为'), '因為'); // 非「爲」
      expect(converter.toTraditionalTw('拉面'), '拉麵'); // 非「麪」
      expect(converter.toTraditionalTw('睡着了'), '睡著了'); // 非「着」
      expect(converter.toTraditionalTw('那里'), '那裡'); // 非「裏」
      expect(converter.toTraditionalTw('这里'), '這裡');
      expect(converter.toTraditionalTw('里面'), '裡面');
    });

    test('台灣字元變體：已是 OpenCC 標準異體的來源亦轉為台灣字（t→tw pass）', () {
      // 來源本身已是 爲/裏/麪/着/纔（繁體 OpenCC 標準）時，TWVariants pass 仍須轉台灣字。
      expect(converter.toTraditionalTw('爲什麼'), '為什麼');
      expect(converter.toTraditionalTw('那裏'), '那裡');
      expect(converter.toTraditionalTw('纔剛'), '才剛');
    });

    test('純非漢字 early-out 原樣回傳', () {
      expect(converter.toTraditionalTw('Hello 42!'), 'Hello 42!');
      expect(converter.toTraditionalTw(''), '');
    });
  });

  group('toTraditional（簡→繁一般，閱讀器 t 選項）', () {
    test('字元級簡→繁', () {
      expect(converter.toTraditional('简体中文'), '簡體中文');
      expect(converter.toTraditional('国家学习'), '國家學習');
    });

    test('不套台灣片語（對照 tw）：软件→軟件、网络→網絡', () {
      expect(converter.toTraditional('软件'), '軟件');
      expect(converter.toTraditional('网络'), '網絡');
      expect(converter.toTraditionalTw('软件'), '軟體');
      expect(converter.toTraditionalTw('网络'), '網路');
    });

    test('純非漢字 early-out 原樣回傳', () {
      expect(converter.toTraditional('Hello 42!'), 'Hello 42!');
    });
  });

  group('toSimplified（繁→簡，僅供查詢 fallback）', () {
    test('繁→簡', () {
      expect(converter.toSimplified('簡體中文'), '简体中文');
    });

    test('查詢用簡體轉換，顯示仍轉回繁體（字元級 round-trip）', () {
      final String simplified = converter.toSimplified('國家');
      expect(simplified, '国家');
      expect(converter.toTraditionalTw(simplified), '國家');
    });
  });

  test('快取：重複轉換結果一致', () {
    expect(converter.toTraditionalTw('简体'), '簡體');
    expect(converter.toTraditionalTw('简体'), '簡體');
  });

  test('未 ensureLoaded 前呼叫拋出 StateError', () {
    final ChineseConverter fresh = ChineseConverter(
      loader: (String k) => File(k).readAsString(),
    );
    expect(() => fresh.toTraditionalTw('简'), throwsStateError);
  });
}
