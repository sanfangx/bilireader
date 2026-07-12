/// API 契約硬常數（規範 §2.1、§7.0，對照 apk/docs/API.md 與 02/03）。
/// 這些值不得自行更改；除非使用者要求改版策略。
abstract final class ApiConstants {
  /// Base URL，結尾 slash 必須保留。
  static const String baseUrl = 'https://api.readpai.com/phone/api/';

  // 版本 header（VersionInterceptor）。App-Version-Code 硬編字串 "39"。
  static const String appVersionCode = '39';
  static const String appVersionName = '1.74.1';

  // 通用 header 名稱。
  static const String headerVersionCode = 'App-Version-Code';
  static const String headerVersionName = 'App-Version-Name';
  static const String headerAcceptLanguage = 'Accept-Language';
  static const String headerAuthorization = 'Authorization';

  /// `Accept-Language` 僅在 zh-CN locale 送出；本 App 預設繁中，預設不送。
  static const String acceptLanguageZhCn = 'zh-CN';

  // 逾時（connect 30s、receive/send 60s）。
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 60);
  static const Duration sendTimeout = Duration(seconds: 60);

  // 業務狀態碼。
  static const int codeSuccess = 200;

  /// 簽到「今日已簽到」（AutoSignInManager.java:155）：僅記錄當日已簽、不彈 Toast。
  static const int codeSignedInAlready = 201;
  static const int codeTokenInvalid = 401;
  static const int codeAccountBanned = 666;
  static const int codeUpdateRequired = 501;

  /// 簽到預設積分（AutoSignInManager.java:27）：server 未回 points 時退回。
  static const int defaultSignInPoints = 3;

  /// 401/666 泛用錯誤路徑清登入的 debounce（毫秒）。
  static const int clearLoginDebounceMs = 5000;

  /// WebSocket 通道 URL（doc 08：由 baseUrl 換 scheme→wss + path/chat|notice；常數）。
  /// 送出 raw `Authorization` header（無 Bearer）+ App-Version-*；傳輸層 ping 25s。
  static const String chatWsUrl = 'wss://api.readpai.com/phone/api/chat';
  static const String noticeWsUrl = 'wss://api.readpai.com/phone/api/notice';

  /// WebSocket 傳輸層 ping 間隔（doc 08 §5.1）。
  static const Duration wsPingInterval = Duration(seconds: 25);

  /// 記憶體快取 TTL（10 分鐘，Phase 3/5 使用）。
  static const int readCacheTtlMs = 600000;

  /// 章節請求失敗節流（Phase 5 使用）。
  static const int chapterFailureThrottleMs = 1500;

  /// 已知不可用的 ANDROID_ID（register deviceId 規則，Phase 4）。
  static const String badAndroidId = '9774d56d682e549c';

  /// 搜尋每頁筆數（doc 11 SEARCH_PAGE_SIZE）；分頁 page 由 1 起。
  static const int searchPageSize = 20;

  /// 榜單每頁筆數（doc 11 RankingActivity.java:45）。
  static const int rankingPageSize = 20;

  /// 社群清單（圈子 / 書評 / 章評）每頁筆數（feature ⑤，pageNum/pageSize 由 1 起）。
  static const int defaultPageSize = 20;

  /// 熱門搜尋關鍵字預設筆數（API.md §8.2 hotSearch limit 預設 12）。
  static const int hotSearchLimit = 12;

  /// 首頁橫向書卡區塊載入筆數（強推/新書等；page/limit 制）。
  static const int homeSectionLimit = 12;

  /// 列表分頁起始頁（page/limit 與 pageNum/pageSize 皆由 1 起）。
  static const int firstPage = 1;
}

/// 認證相關端點路徑（相對 [ApiConstants.baseUrl]，無前導 slash）。
/// Phase 2 僅登記；實際呼叫於 Phase 4 認證 feature。
abstract final class ApiPaths {
  static const String loginChallenge = 'client/bilinovel/user/login/challenge';
  static const String login = 'client/bilinovel/user/login';
  static const String getUserInfo = 'client/bilinovel/user/getuserInfo';
  static const String registerCaptcha =
      'client/bilinovel/user/register/captcha';
  static const String register = 'client/bilinovel/user/register';
  static const String logout = 'client/bilinovel/user/logout';

  /// 搜尋 / 篩選小說（API.md：Body + query pageNum/pageSize）。
  static const String searchNovel = 'client/bilinovel/novel/searchNovel';

  // 書城首頁 / 榜單 / 詳情 / 目錄（BookApiService，API.md §8.2）。
  static const String carousel = 'client/bilinovel/novel/getCarousel';
  static const String ranking = 'client/bilinovel/novel/getRanking';
  static const String newBookRanking =
      'client/bilinovel/novel/getNewBookRanking';
  static const String weekHot = 'client/bilinovel/novel/getweekhot';
  static const String novelInfo = 'client/bilinovel/novel/getNovelInfo';
  static const String sameAuthor = 'client/bilinovel/novel/sameAuthor';
  static const String sameTranslator = 'client/bilinovel/novel/sameTranslator';
  static const String alsoReading = 'client/bilinovel/novel/alsoReading';
  static const String hotSearch = 'client/bilinovel/novel/hotSearch';
  static const String novelTags = 'client/bilinovel/novel/tags';
  static const String chapterCatalog = 'client/bilinovel/novel/getchapter';

  /// 章節正文（Phase 5 閱讀器）。Query articleid/chapterid → TextRequestEntity（未加密 HTML）。
  static const String novelText = 'client/bilinovel/novel/getNovelText';

  // 書架（UserApiService，API.md §8.1）。
  static const String bookcaseList = 'client/bilinovel/bookcase/list';
  static const String bookcaseAdd = 'client/bilinovel/bookcase/add';
  static const String bookcaseDelete = 'client/bilinovel/bookcase/delete';
  static const String bookcaseUpdateClass =
      'client/bilinovel/bookcase/updateClass';
  static const String bookcaseCheck = 'client/bilinovel/bookcase/check';

  // 評分（BookApiService，API.md §8.2）。
  static const String ratingSubmit = 'client/bilinovel/rating/submit';
  static const String ratingMy = 'client/bilinovel/rating/myRating';

  // 投票（VoteApiService，API.md §8.4）。
  static const String voteAdd = 'client/bilinovel/vote/addVote';
  static const String voteGetNovelVotes = 'client/bilinovel/vote/getNovelVotes';

  // 禮物 / 鮮花（GiftApiService，API.md §8.5）。
  static const String giftBalance = 'client/bilinovel/gift/balance';
  static const String giftExchange = 'client/bilinovel/gift/exchange';
  static const String giftSend = 'client/bilinovel/gift/send';
  static const String giftNovelStat = 'client/bilinovel/gift/novel_stat';

  // Feature ⑤ 書評（book_review，API.md §8.2）。皆 Query；reply 為純文字（非 Multipart）。
  static const String bookReviewList = 'client/bilinovel/book_review/list';
  static const String bookReviewAdd = 'client/bilinovel/book_review/add';
  static const String bookReviewDelete = 'client/bilinovel/book_review/delete';
  static const String bookReviewDetail = 'client/bilinovel/book_review/detail';
  static const String bookReviewMy = 'client/bilinovel/book_review/my';
  static const String bookReviewMyList = 'client/bilinovel/book_review/my_list';
  static const String bookReviewMyStats =
      'client/bilinovel/book_review/my_stats';
  static const String bookReviewMyReplies =
      'client/bilinovel/book_review/my_replies';
  static const String bookReviewReplies =
      'client/bilinovel/book_review/replies';
  static const String bookReviewReply = 'client/bilinovel/book_review/reply';
  static const String bookReviewLike = 'client/bilinovel/book_review/like';
  static const String bookReviewReplyLike =
      'client/bilinovel/book_review/reply_like';

  // Feature ⑤ 章評（chapter_comment，API.md §8.2）。皆 Query。
  static const String chapterCommentList =
      'client/bilinovel/chapter_comment/list';
  static const String chapterCommentAdd =
      'client/bilinovel/chapter_comment/add';
  static const String chapterCommentDelete =
      'client/bilinovel/chapter_comment/delete';
  static const String chapterCommentLike =
      'client/bilinovel/chapter_comment/like';
  static const String chapterCommentMy = 'client/bilinovel/chapter_comment/my';

  // Feature ⑥ 通知（notification，API.md §8.6）。皆 Query。
  static const String notificationList = 'client/bilinovel/notification/list';
  static const String notificationUnreadCount =
      'client/bilinovel/notification/unread_count';
  static const String notificationReadAll =
      'client/bilinovel/notification/read_all';
  static const String notificationRead = 'client/bilinovel/notification/read';
  static const String notificationReadByTopic =
      'client/bilinovel/notification/read_by_topic';

  // Feature ⑥ 私訊（message，API.md §8.6）。送訊走 WebSocket，非 REST。
  static const String messageConversations =
      'client/bilinovel/message/conversations';
  static const String messageHistory = 'client/bilinovel/message/history';
  static const String messageUnreadCount =
      'client/bilinovel/message/unread_count';
  static const String messageRead = 'client/bilinovel/message/read';
  static const String messageReadAll = 'client/bilinovel/message/read_all';
  static const String messageBlock = 'client/bilinovel/message/block';

  // Feature ⑤ 圈子（circle，API.md §8.2）。publish/reply 為 Multipart🔒（需 BNUP2）。
  static const String circleList = 'client/bilinovel/circle/list';
  static const String circleSections = 'client/bilinovel/circle/sections';
  static const String circleDetail = 'client/bilinovel/circle/detail';
  static const String circleMyList = 'client/bilinovel/circle/my_list';
  static const String circleMyReplies = 'client/bilinovel/circle/my_replies';
  static const String circlePublish = 'client/bilinovel/circle/publish';
  static const String circleEdit = 'client/bilinovel/circle/edit';
  static const String circleReplies = 'client/bilinovel/circle/replies';
  static const String circleLike = 'client/bilinovel/circle/like';
  static const String circleReplyLike = 'client/bilinovel/circle/reply_like';
  static const String circleReply = 'client/bilinovel/circle/reply';

  // Feature ⑦ 作者專區（AuthorApiService，API.md §8.3）。全部需登入；
  // create/cover/attach/upload 為 Multipart🔒（BNUP2，doc 04）。
  static const String authorNovelList = 'client/bilinovel/author/novel/list';
  static const String authorNovelUpdate =
      'client/bilinovel/author/novel/update';
  static const String authorNovelDelete =
      'client/bilinovel/author/novel/delete';
  static const String authorNovelCreate =
      'client/bilinovel/author/novel/create';
  static const String authorNovelCover = 'client/bilinovel/author/novel/cover';
  static const String authorVolumeCreate =
      'client/bilinovel/author/volume/create';
  static const String authorVolumeUpdate =
      'client/bilinovel/author/volume/update';
  static const String authorVolumeDelete =
      'client/bilinovel/author/volume/delete';
  static const String authorVolumeCover =
      'client/bilinovel/author/volume/cover';
  static const String authorChapterTree =
      'client/bilinovel/author/chapter/tree';
  static const String authorChapterText =
      'client/bilinovel/author/chapter/text';
  static const String authorChapterPublishDirect =
      'client/bilinovel/author/chapter/publishDirect';
  static const String authorChapterPublish =
      'client/bilinovel/author/chapter/publish';
  static const String authorChapterUpdate =
      'client/bilinovel/author/chapter/update';
  static const String authorChapterDelete =
      'client/bilinovel/author/chapter/delete';
  static const String authorChapterMove =
      'client/bilinovel/author/chapter/move';
  static const String authorChapterAttachUpload =
      'client/bilinovel/author/chapter/attach/upload';
  static const String authorChapterAttachDelete =
      'client/bilinovel/author/chapter/attach/delete';
  static const String authorDraftList = 'client/bilinovel/author/draft/list';
  static const String authorDraftSave = 'client/bilinovel/author/draft/save';
  static const String authorDraftDelete =
      'client/bilinovel/author/draft/delete';

  // Feature ⑧ 簽到 / 版本 / 公告 / 反饋（API.md §8.7-8.9 + system/feedback）。
  static const String taskSignIn = 'client/bilinovel/task/sign_in';
  static const String versionCheck = 'client/bilinovel/version/check';
  static const String versionChangelog = 'client/bilinovel/version/changelog';
  static const String startupAnnouncement =
      'client/bilinovel/system/startupAnnouncement';
  static const String feedbackSubmit = 'client/bilinovel/feedback/submit';
}
