import 'package:bilireader_app/features/reader/content_block.dart';
import 'package:bilireader_app/features/reader/data/chapter_text_assembler.dart';
import 'package:bilireader_app/features/reader/domain/chapter_text.dart';
import 'package:bilireader_app/features/reader/domain/reader_block.dart';
import 'package:bilireader_app/features/reader/domain/reader_content_builder.dart';
import 'package:flutter_test/flutter_test.dart';

/// Step 3 內容橋接（方案 a）端到端純邏輯驗證：
/// ContentBlock 串 → ChapterTextAssembler → ChapterText → ReaderContentBuilder → ReaderBlock 串。
String _identity(String s) => s;

void main() {
  const ChapterTextAssembler assembler = ChapterTextAssembler();
  const ReaderContentBuilder builder = ReaderContentBuilder();

  ChapterContent content(List<ContentBlock> blocks, {String? title}) =>
      ChapterContent(title: title, blocks: blocks);

  List<ReaderBlock> pipe(ChapterContent c) => builder.build(
    assembler.assemble(
      articleId: 42,
      chapterId: 7,
      chapterName: '備援章名',
      content: c,
    ),
    convert: _identity,
    illustrationSpoiler: false,
    chapterCommentEnabled: false,
  );

  group('assemble', () {
    test('title 優先於備援章名；空 title 用備援', () {
      final ChapterText a = assembler.assemble(
        articleId: 42,
        chapterId: 7,
        chapterName: '備援章名',
        content: content(<ContentBlock>[ContentBlock.text('x')], title: ' 第一章 '),
      );
      expect(a.chapterName, '第一章'); // trim + 優先
      final ChapterText b = assembler.assemble(
        articleId: 42,
        chapterId: 7,
        chapterName: '備援章名',
        content: content(<ContentBlock>[ContentBlock.text('x')], title: '   '),
      );
      expect(b.chapterName, '備援章名');
    });

    test('DOM 順序保留：文字/圖片交錯合成整章 HTML', () {
      final ChapterText a = assembler.assemble(
        articleId: 42,
        chapterId: 7,
        chapterName: '章',
        content: content(<ContentBlock>[
          ContentBlock.text('第一段'),
          ContentBlock.image('https://tw.linovelib.com/i/a.jpg'),
          ContentBlock.text('第二段'),
        ]),
      );
      expect(
        a.text,
        '第一段\n<img src="https://tw.linovelib.com/i/a.jpg">\n第二段',
      );
      expect(a.images.single.url, 'https://tw.linovelib.com/i/a.jpg');
      expect(a.images.single.aspectRatio, 0);
    });
  });

  group('端到端管線', () {
    test('文字段 → ParagraphBlock（保留富文本、置中偵測、sourceOffset）', () {
      final List<ReaderBlock> out = pipe(content(<ContentBlock>[
        ContentBlock.text('前<ruby>漢<rt>かん</rt></ruby>後'),
        ContentBlock.text('＊＊＊'),
        ContentBlock.text('末段'),
      ]));
      final List<ParagraphBlock> paras =
          out.whereType<ParagraphBlock>().toList();
      expect(paras.length, 3);
      expect(paras[0].html, '前<ruby>漢<rt>かん</rt></ruby>後'); // 富文本原樣保留
      expect(paras[1].centered, isTrue); // ＊＊＊ 置中
      expect(paras[0].centered, isFalse);
      expect(paras[0].sourceOffset, 0);
    });

    test('圖片段 → ImageBlock，URL 正確、獨立成塊', () {
      final List<ReaderBlock> out = pipe(content(<ContentBlock>[
        ContentBlock.text('圖前'),
        ContentBlock.image('https://tw.linovelib.com/i/a.jpg'),
      ]));
      expect(out.whereType<ParagraphBlock>().length, 1);
      final List<ImageBlock> imgs = out.whereType<ImageBlock>().toList();
      expect(imgs.single.url, 'https://tw.linovelib.com/i/a.jpg');
    });

    test('無章末章評 block（web 端恆關）', () {
      final List<ReaderBlock> out =
          pipe(content(<ContentBlock>[ContentBlock.text('內文')]));
      expect(out.whereType<ChapterCommentBlock>(), isEmpty);
    });
  });

  group('hasRenderableContent（VIP/空章偵測）', () {
    test('有文字或圖片 → true', () {
      expect(
        hasRenderableContent(content(<ContentBlock>[ContentBlock.text('x')])),
        isTrue,
      );
      expect(
        hasRenderableContent(
          content(<ContentBlock>[ContentBlock.image('u')]),
        ),
        isTrue,
      );
    });

    test('空 blocks 或全空白文字 → false', () {
      expect(hasRenderableContent(content(<ContentBlock>[])), isFalse);
      expect(
        hasRenderableContent(
          content(<ContentBlock>[ContentBlock.text('   ')]),
        ),
        isFalse,
      );
    });
  });
}
