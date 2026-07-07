/// Route path 與 name 常數（規範 §6.2）。路徑對齊 apk/docs/flutter/09。
/// Phase 1 只需底部四分頁與少量 shell 外 route；其餘於各 feature 階段新增。
abstract final class AppRoutes {
  // 底部四分頁（StatefulShellRoute branches）。
  static const String store = '/store';
  static const String storeName = 'store';
  static const String shelf = '/shelf';
  static const String shelfName = 'shelf';
  static const String quanzi = '/quanzi';
  static const String quanziName = 'quanzi';
  static const String user = '/user';
  static const String userName = 'user';

  // shell 外全屏 route（Phase 1 以佔位頁呈現）。
  static const String novelDetail = '/novel/:articleId';
  static const String novelDetailName = 'novelDetail';
  static const String catalog = '/novel/:articleId/catalog';
  static const String catalogName = 'catalog';
  static const String reader = '/read/:articleId';
  static const String readerName = 'reader';
  static const String search = '/search';
  static const String searchName = 'search';
  static const String ranking = '/ranking';
  static const String rankingName = 'ranking';
  static const String tag = '/tag';
  static const String tagName = 'tag';
  static const String login = '/login';
  static const String loginName = 'login';
  static const String register = '/register';
  static const String registerName = 'register';

  // Feature ⑤ 圈子 / 書評（shell 外全屏 route，doc 09 §7）。
  static const String circlePublish = '/circle/publish';
  static const String circlePublishName = 'circlePublish';
  static const String circlePost = '/circle/:topicId';
  static const String circlePostName = 'circlePost';
  static const String bookReview = '/review/:topicId';
  static const String bookReviewName = 'bookReview';
  static const String bookReviewList = '/novel/:articleId/reviews';
  static const String bookReviewListName = 'bookReviewList';

  // Feature ⑥ 通知 / 私訊（shell 外全屏 route，doc 09）。
  static const String notifications = '/notices';
  static const String notificationsName = 'notifications';
  static const String messages = '/messages';
  static const String messagesName = 'messages';
  static const String chat = '/messages/:peerId';
  static const String chatName = 'chat';

  // Feature ⑧ 系統設定 / 意見回饋 / 更新日誌（shell 外全屏 route）。
  static const String settings = '/settings';
  static const String settingsName = 'settings';
  static const String feedback = '/feedback';
  static const String feedbackName = 'feedback';
  static const String changelog = '/changelog';
  static const String changelogName = 'changelog';

  // Feature ⑦ 作者專區（shell 外全屏 route，doc 09）。閘門：登入 + groupid ∈ {1,5,6}。
  static const String authorZone = '/author';
  static const String authorZoneName = 'authorZone';
  static const String authorChapters = '/author/:articleId/chapters';
  static const String authorChaptersName = 'authorChapters';
  static const String chapterEditor = '/author/:articleId/editor';
  static const String chapterEditorName = 'chapterEditor';
}
