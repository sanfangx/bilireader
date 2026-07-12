import 'package:bilireader/features/reader/domain/chapter_text.dart';
import 'package:bilireader/features/reader/domain/reader_block.dart';
import 'package:bilireader/features/reader/domain/reader_content_builder.dart';
import 'package:bilireader/features/reader/domain/reader_text_utils.dart';
import 'package:flutter_test/flutter_test.dart';

String _identity(String s) => s;

void main() {
  group('splitTextByNewLine（行內標籤感知）', () {
    test('一般換行切段', () {
      expect(splitTextByNewLine('第一段\n第二段'), <String>['第一段', '第二段']);
    });

    test('ruby 內部的換行不切段', () {
      // <ruby> 未閉合時遇到 \n 不切，保證 ruby 完整。
      const String src = '前<ruby>漢\n字<rt>かんじ</rt></ruby>後\n下一段';
      expect(splitTextByNewLine(src), <String>[
        '前<ruby>漢\n字<rt>かんじ</rt></ruby>後',
        '下一段',
      ]);
    });

    test('\\r\\n 與 \\r 正規化為 \\n', () {
      expect(splitTextByNewLine('a\r\nb\rc'), <String>['a', 'b', 'c']);
    });

    test('自閉合行內標籤不影響堆疊', () {
      expect(splitTextByNewLine('a<br/>b\nc'), <String>['a<br/>b', 'c']);
    });
  });

  group('isReaderCenterLine', () {
    test('純數字（半形/全形）→ true', () {
      expect(isReaderCenterLine('123'), isTrue);
      expect(isReaderCenterLine('０１２'), isTrue);
    });
    test('全為置中符號 → true（含空白間隔、emoji）', () {
      expect(isReaderCenterLine('＊＊＊'), isTrue);
      expect(isReaderCenterLine('★ ☆ ★'), isTrue);
      expect(isReaderCenterLine('🔥🐾'), isTrue);
    });
    test('一般文字 → false', () {
      expect(isReaderCenterLine('第一章'), isFalse);
      expect(isReaderCenterLine('1 2 3'), isFalse); // 含空白＋非符號數字
    });
    test('空字串 → false', () {
      expect(isReaderCenterLine('   '), isFalse);
    });
  });

  group('readerDisplayText', () {
    test('空字串 → 單一空白', () => expect(readerDisplayText('', false, false), ' '));
    test('一般段首行縮排兩全形空格', () {
      expect(readerDisplayText('內文', false, false), '　　內文');
    });
    test('連續段/置中段不縮排', () {
      expect(readerDisplayText('內文', true, false), '內文');
      expect(readerDisplayText('內文', false, true), '內文');
    });
  });

  group('normalizeImageUrl', () {
    test('img3 → img2/attachment（僅開頭）', () {
      expect(
        normalizeImageUrl('  https://img3.readpai.com/2020/a.jpg '),
        'https://img2.readpai.com/attachment/2020/a.jpg',
      );
    });
    test('非 img3 前綴不變', () {
      expect(
        normalizeImageUrl('https://img2.readpai.com/attachment/x.jpg'),
        'https://img2.readpai.com/attachment/x.jpg',
      );
    });
  });

  group('ReaderContentBuilder.build', () {
    const ReaderContentBuilder builder = ReaderContentBuilder();

    ChapterText chapter({
      String text = '',
      String name = '第一章',
      List<ChapterImage> images = const <ChapterImage>[],
      bool isImage = false,
      int isbody = 0,
    }) => ChapterText(
      articleId: 7,
      chapterId: 3,
      chapterName: name,
      text: text,
      images: images,
      isImage: isImage,
      isbody: isbody,
    );

    test('段落 + 章評；置中偵測；sourceOffset 遞增（無 body 章名 block）', () {
      final List<ReaderBlock> out = builder.build(
        chapter(text: '第一段\n＊＊＊\n第二段'),
        convert: _identity,
        illustrationSpoiler: true,
        chapterCommentEnabled: true,
      );
      // 設計取捨：不再插入 body 章名 block。
      expect(out.whereType<ChapterTitleBlock>(), isEmpty);
      expect(out.first, isA<ParagraphBlock>());

      final List<ParagraphBlock> paras = out
          .whereType<ParagraphBlock>()
          .toList();
      expect(paras.map((ParagraphBlock p) => p.html), <String>[
        '第一段',
        '＊＊＊',
        '第二段',
      ]);
      expect(paras[1].centered, isTrue); // ＊＊＊
      expect(paras[0].centered, isFalse);
      // sourceOffset：第二段 = len('第一段')+1 + len('＊＊＊')+1 = 4 + 4 = 8。
      expect(paras[0].sourceOffset, 0);
      expect(paras[2].sourceOffset, 8);

      expect(out.last, isA<ChapterCommentBlock>());
    });

    test('章評關閉 → 無 ChapterCommentBlock', () {
      final List<ReaderBlock> out = builder.build(
        chapter(text: '內文'),
        convert: _identity,
        illustrationSpoiler: true,
        chapterCommentEnabled: false,
      );
      expect(out.whereType<ChapterCommentBlock>(), isEmpty);
    });

    test('<img> 擷取 + 去重 + aspectRatio 對映', () {
      const String u = 'https://img3.readpai.com/2020/a.jpg';
      final List<ReaderBlock> out = builder.build(
        chapter(
          text: '<img src="$u">\n<img src="$u">', // 重複 → 去重
          images: const <ChapterImage>[
            ChapterImage(
              url: 'https://img2.readpai.com/attachment/2020/a.jpg',
              aspectRatio: 1.5,
            ),
          ],
        ),
        convert: _identity,
        illustrationSpoiler: true,
        chapterCommentEnabled: false,
      );
      final List<ImageBlock> imgs = out.whereType<ImageBlock>().toList();
      expect(imgs.length, 1);
      expect(imgs.single.url, 'https://img2.readpai.com/attachment/2020/a.jpg');
      expect(imgs.single.aspectRatio, 1.5);
    });

    test('防劇透門檻：spoiler 開 + isbody=2 → 只留前 2 張正文插圖', () {
      String line(int i) => '<img src="https://img3.readpai.com/$i.jpg">';
      final ChapterText c = chapter(
        text: '${line(1)}\n${line(2)}\n${line(3)}',
        isbody: 2,
      );
      expect(
        builder
            .build(
              c,
              convert: _identity,
              illustrationSpoiler: true,
              chapterCommentEnabled: false,
            )
            .whereType<ImageBlock>()
            .length,
        2,
      );
      // spoiler 關 → 全部 3 張。
      expect(
        builder
            .build(
              c,
              convert: _identity,
              illustrationSpoiler: false,
              chapterCommentEnabled: false,
            )
            .whereType<ImageBlock>()
            .length,
        3,
      );
    });

    test('整章皆圖（isImage）：images[] 全數塞入，不受 spoiler 限制', () {
      final List<ReaderBlock> out = builder.build(
        chapter(
          isImage: true,
          isbody: 1,
          images: const <ChapterImage>[
            ChapterImage(
              url: 'https://img2.readpai.com/attachment/a.jpg',
              aspectRatio: 1,
            ),
            ChapterImage(
              url: 'https://img2.readpai.com/attachment/b.jpg',
              aspectRatio: 1,
            ),
          ],
        ),
        convert: _identity,
        illustrationSpoiler: true,
        chapterCommentEnabled: false,
      );
      expect(out.whereType<ImageBlock>().length, 2);
    });

    test('convert 套用於正文', () {
      final List<ReaderBlock> out = builder.build(
        chapter(text: 'x', name: 'y'),
        convert: (String s) => s.toUpperCase(),
        illustrationSpoiler: true,
        chapterCommentEnabled: false,
      );
      expect(out.whereType<ParagraphBlock>().single.html, 'X');
    });
  });
}
