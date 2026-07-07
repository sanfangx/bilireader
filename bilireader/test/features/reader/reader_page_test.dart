import 'package:bilireader/core/di/infra_providers.dart';
import 'package:bilireader/core/network/api_result.dart';
import 'package:bilireader/core/storage/database/app_database.dart';
import 'package:bilireader/core/storage/database/database_providers.dart';
import 'package:bilireader/core/text/chinese_converter.dart';
import 'package:bilireader/core/text/text_providers.dart';
import 'package:bilireader/features/discover/domain/novel_catalog.dart';
import 'package:bilireader/features/discover/presentation/novel_detail_providers.dart';
import 'package:bilireader/features/reader/data/bookmark_local_data_source.dart';
import 'package:bilireader/features/reader/data/chapter_text_providers.dart';
import 'package:bilireader/features/reader/domain/bookmark.dart';
import 'package:bilireader/features/reader/domain/chapter_text.dart';
import 'package:bilireader/features/reader/domain/chapter_text_repository.dart';
import 'package:bilireader/features/reader/domain/reader_anchor.dart';
import 'package:bilireader/features/reader/domain/reader_settings.dart';
import 'package:bilireader/features/reader/domain/reading_progress.dart';
import 'package:bilireader/features/reader/domain/reading_progress_repository.dart';
import 'package:bilireader/features/reader/presentation/reader_page.dart';
import 'package:bilireader/features/reader/presentation/reader_paged_view.dart';
import 'package:bilireader/features/reader/presentation/reader_providers.dart';
import 'package:bilireader/features/reader/presentation/reader_settings_providers.dart';
import 'package:bilireader/features/reader/reading_progress_providers.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

NovelCatalog _catalog() => const NovelCatalog(
  articleId: 1,
  articleName: '測試小說',
  volumes: <CatalogVolume>[
    CatalogVolume(
      volumeId: 10,
      chapters: <CatalogChapter>[
        CatalogChapter(chapterId: 101, title: '第一章'),
        CatalogChapter(chapterId: 102, title: '第二章'),
        CatalogChapter(chapterId: 103, title: '第三章'),
      ],
    ),
  ],
);

class _FakeChapterTextRepo implements ChapterTextRepository {
  const _FakeChapterTextRepo({
    this.longText = false,
    this.delay = Duration.zero,
  });

  final bool longText;

  /// 模擬（快取）非同步讀取延遲，令重跑會經過一個已渲染的 loading frame。
  final Duration delay;

  @override
  Future<ApiResult<ChapterText>> getChapterText({
    required int articleId,
    required int chapterId,
  }) async {
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    return ApiSuccess<ChapterText>(
      ChapterText(
        articleId: articleId,
        chapterId: chapterId,
        chapterName: '章節 $chapterId',
        text: longText
            ? List<String>.generate(
                60,
                (int i) => '第 ${i + 1} 段：這是章節 $chapterId 的內文段落，內容夠長足以捲動。',
              ).join('\n')
            : '這是章節 $chapterId 的內文段落。\n第二段內容。',
      ),
    );
  }

  @override
  Future<ApiResult<void>> downloadChapter({
    required int articleId,
    required int chapterId,
  }) async => const ApiSuccess<void>(null);

  @override
  Future<bool> isCached({
    required int articleId,
    required int chapterId,
  }) async => false;
}

class _FakeProgressRepo implements ReadingProgressRepository {
  _FakeProgressRepo({this.existing});

  final List<ReadingProgress> saves = <ReadingProgress>[];

  /// get() 回傳值（供封面回填測試）。
  final ReadingProgress? existing;

  @override
  Future<void> save(ReadingProgress progress) async => saves.add(progress);

  @override
  Future<ReadingProgress?> get(int ownerUid, int articleId) async => existing;

  @override
  Future<List<ReadingProgress>> getAll(int ownerUid) async =>
      <ReadingProgress>[];

  @override
  Stream<List<ReadingProgress>> watchAll(int ownerUid) =>
      const Stream<List<ReadingProgress>>.empty();
}

void main() {
  group('chapterNavOf（上/下章導覽）', () {
    test('中間章：有上一章與下一章', () {
      final ChapterNav nav = chapterNavOf(_catalog(), 102);
      expect(nav.index, 1);
      expect(nav.count, 3);
      expect(nav.prevChapterId, 101);
      expect(nav.nextChapterId, 103);
    });
    test('首章無上一章、末章無下一章', () {
      expect(chapterNavOf(_catalog(), 101).prevChapterId, isNull);
      expect(chapterNavOf(_catalog(), 103).nextChapterId, isNull);
    });
    test('未知章 index -1', () {
      expect(chapterNavOf(_catalog(), 999).index, -1);
    });
  });

  group('ReaderPage 煙霧測試', () {
    Future<void> pump(
      WidgetTester tester, {
      int chapterId = 101,
      Map<String, Object> seed = const <String, Object>{},
      int? ownerUid,
      ReadingProgressRepository? progressRepo,
      bool longContent = false,
      AppDatabase? db,
      Duration chapterDelay = Duration.zero,
      String poster = '',
    }) async {
      SharedPreferences.setMockInitialValues(seed);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            chineseConverterProvider.overrideWithValue(
              ChineseConverter(loader: (String k) async => ''),
            ),
            chapterTextRepositoryProvider.overrideWithValue(
              _FakeChapterTextRepo(longText: longContent, delay: chapterDelay),
            ),
            novelCatalogProvider(1).overrideWith((Ref ref) => _catalog()),
            currentOwnerUidProvider.overrideWith((Ref ref) => ownerUid),
            if (progressRepo != null)
              readingProgressRepositoryProvider.overrideWithValue(progressRepo),
            if (db != null) appDatabaseProvider.overrideWithValue(db),
          ],
          child: MaterialApp(
            home: ReaderPage(
              articleId: 1,
              initialChapterId: chapterId,
              poster: poster,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('載入章節 → 顯示內文 + 頂/底列', (WidgetTester tester) async {
      await pump(tester);
      expect(find.textContaining('這是章節 101 的內文段落。'), findsOneWidget);
      expect(find.text('章節 101'), findsWidgets); // 頂列章名
      expect(find.text('第 1 章 / 共 3 章'), findsOneWidget); // 底列
      expect(find.text('字體'), findsOneWidget);
      expect(find.text('下一章'), findsOneWidget);
    });

    testWidgets('點下一章 → 切換到第二章', (WidgetTester tester) async {
      await pump(tester);
      await tester.tap(find.text('下一章'));
      await tester.pumpAndSettle();
      expect(find.textContaining('這是章節 102 的內文段落。'), findsOneWidget);
      expect(find.text('第 2 章 / 共 3 章'), findsOneWidget);
    });

    testWidgets('水平翻頁模式：分頁 PageView 渲染內文', (WidgetTester tester) async {
      await pump(
        tester,
        seed: <String, Object>{'reader_scroll_mode': 'horizontal'},
      );
      expect(find.byType(PageView), findsOneWidget);
      expect(find.textContaining('這是章節 101 的內文段落。'), findsWidgets);
    });

    testWidgets('F-21：App paused → 立即 flush 進度（不等 500ms 防抖）', (
      WidgetTester tester,
    ) async {
      final _FakeProgressRepo repo = _FakeProgressRepo();
      await pump(tester, ownerUid: 902220, progressRepo: repo);
      final int base = repo.saves.length; // 章載入 post-frame 已存一次
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump();
      expect(repo.saves.length, base + 1, reason: 'paused 應立即 flush，而非等防抖視窗');
    });

    testWidgets('F-21：連續捲動只在防抖視窗結束後寫一次（合併過密寫入）', (WidgetTester tester) async {
      final _FakeProgressRepo repo = _FakeProgressRepo();
      await pump(
        tester,
        ownerUid: 902220,
        progressRepo: repo,
        longContent: true,
      );
      final int base = repo.saves.length;
      final Finder list = find.byType(Scrollable).first;
      await tester.drag(list, const Offset(0, -200));
      await tester.pump();
      await tester.drag(list, const Offset(0, -200));
      await tester.pump();
      await tester.drag(list, const Offset(0, -200));
      await tester.pump();
      expect(repo.saves.length, base, reason: '防抖視窗內不得寫入');
      await tester.pump(const Duration(milliseconds: 600));
      expect(repo.saves.length, base + 1, reason: '過防抖後只寫最後一筆');
    });

    testWidgets('F-12 閱讀器頂列圖示鈕有語意名（返回/書籤/章節評論）', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await pump(tester);
      for (final String name in <String>['返回', '書籤', '章節評論']) {
        expect(find.bySemanticsLabel(name), findsOneWidget, reason: name);
      }
      handle.dispose();
    });

    testWidgets('F-33 亮度遮罩：dim>0 疊黑遮罩且點擊穿透（切章仍作用）', (
      WidgetTester tester,
    ) async {
      await pump(tester, seed: <String, Object>{'reader_dim_level': 0.4});
      // 遮罩存在：黑 ColoredBox @0.4 疊在內容上，且被 IgnorePointer 包（不攔截手勢）。
      final Finder dim = find.byWidgetPredicate(
        (Widget w) =>
            w is ColoredBox && w.color == Colors.black.withValues(alpha: 0.4),
      );
      expect(dim, findsOneWidget);
      expect(
        find.ancestor(
          of: dim,
          matching: find.byWidgetPredicate(
            (Widget w) => w is IgnorePointer && w.ignoring,
          ),
        ),
        findsOneWidget,
      );
      // 穿透：底列「下一章」仍可點 → 切到第二章（IgnorePointer 讓點擊穿透至內容）。
      await tester.tap(find.text('下一章'));
      await tester.pumpAndSettle();
      expect(find.textContaining('這是章節 102 的內文段落。'), findsOneWidget);
    });

    testWidgets('F-33 dim=0（預設）→ 不插入遮罩層（零影響）', (WidgetTester tester) async {
      await pump(tester);
      expect(
        find.byWidgetPredicate(
          (Widget w) =>
              w is ColoredBox && w.color == Colors.black.withValues(alpha: 0.4),
        ),
        findsNothing,
      );
    });

    testWidgets('登入狀態下卸載閱讀器 → dispose 存進度不觸碰 ref（不崩潰）', (
      WidgetTester tester,
    ) async {
      // 迴歸：舊版 _saveProgress 於 dispose() 內 ref.read → StateError（ref 於卸載後不安全）。
      // 需登入（uid 非 null）＋章名已載入，dispose 才會實際存檔。
      final _FakeProgressRepo repo = _FakeProgressRepo();
      await pump(tester, ownerUid: 902220, progressRepo: repo);
      // 章載入後 _onChapterLoaded 已存一次（欄位 repo）。
      expect(repo.saves, isNotEmpty);

      // 卸載 ReaderPage（整棵樹換掉）→ 觸發 dispose → _saveProgress。
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      // dispose 也再存了一次（欄位 repo，未經 ref）。
      expect(repo.saves.length, greaterThanOrEqualTo(1));
    });

    testWidgets('進度保存含書名（目錄已快取時取當前值，非只聽變更）', (WidgetTester tester) async {
      // 迴歸：舊版以無「當前值派送」的 ref.listen 擷取書名，目錄已是 AsyncData 時
      // listener 永不觸發 → articleName 空 → 書架「繼續閱讀」顯示「未命名作品」。
      // 此測試 harness 的目錄 override 同步回傳 → 首個 build 即 AsyncData（＝快取情境）。
      final _FakeProgressRepo repo = _FakeProgressRepo();
      await pump(tester, ownerUid: 902220, progressRepo: repo);
      expect(repo.saves, isNotEmpty);
      expect(repo.saves.last.articleName, '測試小說');
    });

    testWidgets('進度存檔含封面 poster（入口帶入 → 書架繼續閱讀縮圖）', (WidgetTester tester) async {
      // 迴歸：舊版 _saveProgress 未存 poster → 繼續閱讀卡片封面縮圖空白。
      final _FakeProgressRepo repo = _FakeProgressRepo();
      await pump(
        tester,
        ownerUid: 902220,
        progressRepo: repo,
        poster: 'https://img/cover.jpg',
      );
      expect(repo.saves.last.poster, 'https://img/cover.jpg');
    });

    testWidgets('入口未帶封面 → 由既有進度回填 poster（不以空封面覆蓋）', (
      WidgetTester tester,
    ) async {
      final _FakeProgressRepo repo = _FakeProgressRepo(
        existing: const ReadingProgress(
          ownerUid: 902220,
          anchor: ReaderAnchor(
            articleId: 1,
            chapterId: 101,
            chapterName: '第一章',
            sourceTextOffset: 0,
          ),
          articleName: '測試小說',
          poster: 'https://img/existing.jpg',
        ),
      );
      await pump(tester, ownerUid: 902220, progressRepo: repo); // 未帶 poster
      expect(repo.saves, isNotEmpty);
      expect(repo.saves.last.poster, 'https://img/existing.jpg');
    });

    testWidgets('點擊中央切換控制列後保留捲動位置（垂直模式不跳章首）', (WidgetTester tester) async {
      // 迴歸：頂列於 Column 首位增刪會令內容 Expanded 位移，無 key 時 Flutter 重建內容子樹
      // → ScrollPosition 歸 0 跳章首。keyed 對位後元素保留，位置維持。
      // 需開啟「點擊中央切換工具列」（預設關閉），此迴歸才適用。
      await pump(
        tester,
        longContent: true,
        seed: <String, Object>{'reader_tap_center_toggles_bars': true},
      );

      // 捲到中段。
      final ScrollableState st = tester.state<ScrollableState>(
        find.byType(Scrollable).first,
      );
      st.position.jumpTo(300);
      await tester.pump();
      expect(st.position.pixels, 300);
      expect(find.text('章節 101'), findsWidgets); // 頂列可見（含章名）

      // 點擊中央 → 切換控制列（收起頂/底列）。
      await tester.tapAt(tester.getCenter(find.byType(ListView)));
      await tester.pumpAndSettle();

      // 控制列已收起（頂列章名消失）＋捲動位置維持（未跳回 0）。
      expect(find.text('章節 101'), findsNothing);
      final ScrollableState st2 = tester.state<ScrollableState>(
        find.byType(Scrollable).first,
      );
      expect(st2.position.pixels, 300);

      // 再點一次 → 控制列還原（show/hide 為對稱切換，非單向），位置仍維持。
      await tester.tapAt(tester.getCenter(find.byType(ListView)));
      await tester.pumpAndSettle();
      expect(find.text('章節 101'), findsWidgets);
      expect(
        tester
            .state<ScrollableState>(find.byType(Scrollable).first)
            .position
            .pixels,
        300,
      );
    });

    testWidgets('預設（開關關閉）：點擊中央不收起控制列', (WidgetTester tester) async {
      // 使用者要求：點中間收合預設關閉。tap 中央不得隱藏頂/底列。
      await pump(
        tester,
        longContent: true,
      ); // 未 seed → tapCenterTogglesBars=false
      expect(find.text('章節 101'), findsWidgets); // 頂列可見

      await tester.tapAt(tester.getCenter(find.byType(ListView)));
      await tester.pumpAndSettle();

      // 開關關閉 → 控制列仍在（未因點擊收起）。
      expect(find.text('章節 101'), findsWidgets);
      expect(find.text('字體'), findsOneWidget); // 底列仍在
      expect(find.text('下一章'), findsOneWidget);
    });

    testWidgets('頂列書籤：登入態點擊 → 開書籤面板；加入 → 存 DB + 列出；刪除 → 清空', (
      WidgetTester tester,
    ) async {
      final AppDatabase db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await pump(tester, ownerUid: 902220, db: db);

      // 點頂列書籤 icon → 開啟書籤面板。
      await tester.tap(find.byIcon(Icons.bookmark_border));
      await tester.pumpAndSettle();
      expect(find.text('書籤'), findsOneWidget); // 面板標題
      expect(find.text('在此處加入書籤'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsNothing); // 尚無書籤列

      // 加入 → 存 DB + 出現一列（含刪除鈕）。
      await tester.tap(find.text('在此處加入書籤'));
      await tester.pumpAndSettle();
      expect((await db.bookmarkDao.getBookmarks(902220, 1)).length, 1);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);

      // 刪除 → DB 清空 + 列消失。
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();
      expect(await db.bookmarkDao.getBookmarks(902220, 1), isEmpty);
      expect(find.byIcon(Icons.delete_outline), findsNothing);
    });

    testWidgets('書籤記錄目前 block 序號（§5.5 精準定位，非只比例）', (WidgetTester tester) async {
      final AppDatabase db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await pump(tester, ownerUid: 902220, db: db, longContent: true);

      // 捲離頂端。
      tester
          .state<ScrollableState>(find.byType(Scrollable).first)
          .position
          .jumpTo(600);
      await tester.pumpAndSettle();

      // 開面板 → 加入書籤。
      await tester.tap(find.byIcon(Icons.bookmark_border));
      await tester.pumpAndSettle();
      await tester.tap(find.text('在此處加入書籤'));
      await tester.pumpAndSettle();

      final List<Bookmark> marks = await BookmarkLocalDataSource(
        db.bookmarkDao,
      ).getForBook(902220, 1);
      expect(marks.length, 1);
      // 錨點記錄目前可見 block 序號（已捲離頂端 → > 0）。
      expect(marks.single.anchor.blockIndex, greaterThan(0));
    });

    testWidgets('切換繁簡轉換不重置捲動位置（skipLoadingOnReload）', (
      WidgetTester tester,
    ) async {
      // 章節載入有延遲 → 重跑會經過已渲染的 loading frame；若無 skipLoadingOnReload，
      // ListView 會被 spinner 換掉 → 捲動歸零（此測試據此驗證修正）。
      await pump(
        tester,
        longContent: true,
        chapterDelay: const Duration(milliseconds: 30),
      );
      final ScrollableState st = tester.state<ScrollableState>(
        find.byType(Scrollable).first,
      );
      st.position.jumpTo(400);
      await tester.pump();
      expect(st.position.pixels, 400);

      // 切換 convertMode（tw → t）→ 內容 provider 重跑（延遲 → 會渲染 loading）。
      ProviderScope.containerOf(tester.element(find.byType(ReaderPage)))
          .read(readerSettingsControllerProvider.notifier)
          .setConvertMode(ReaderConvertMode.traditional);
      await tester.pump(); // 渲染 reload 期間（reload frame）
      await tester.pump(const Duration(milliseconds: 50)); // 讓延遲完成
      await tester.pumpAndSettle();

      // 捲動位置維持（未因 loading 換掉 ListView 而歸零）。
      expect(
        tester
            .state<ScrollableState>(find.byType(Scrollable).first)
            .position
            .pixels,
        400,
      );
    });

    testWidgets('點擊中央切換控制列後保留頁碼（翻頁模式：內容 state 不重建）', (
      WidgetTester tester,
    ) async {
      // 迴歸：翻頁模式的頁碼位置存於 ReaderPagedView 的 state（_liveFraction）。若切換控制列
      // 時內容子樹被重建，state 重置 → 跳回初始頁。keyed 對位使 state 實例跨切換保留。
      await pump(
        tester,
        seed: <String, Object>{
          'reader_scroll_mode': 'horizontal',
          'reader_tap_center_toggles_bars': true,
        },
        longContent: true,
      );

      final State<StatefulWidget> before = tester.state<State<StatefulWidget>>(
        find.byType(ReaderPagedView),
      );

      // 點擊中央 → 切換控制列。
      await tester.tapAt(tester.getCenter(find.byType(ReaderPagedView)));
      await tester.pumpAndSettle();

      expect(find.text('章節 101'), findsNothing); // 控制列已收起
      final State<StatefulWidget> after = tester.state<State<StatefulWidget>>(
        find.byType(ReaderPagedView),
      );
      // 同一 State 實例 → 內容子樹（含 _liveFraction 頁碼）跨切換保留。
      expect(identical(before, after), isTrue);
    });
  });
}
