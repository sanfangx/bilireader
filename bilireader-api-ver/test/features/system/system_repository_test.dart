import 'dart:io';

import 'package:bilireader/core/network/api_result.dart';
import 'package:bilireader/core/text/chinese_converter.dart';
import 'package:bilireader/features/system/data/dto/system_dtos.dart';
import 'package:bilireader/features/system/data/system_remote_data_source.dart';
import 'package:bilireader/features/system/data/system_repository_impl.dart';
import 'package:bilireader/features/system/domain/feedback_options.dart';
import 'package:bilireader/features/system/domain/system_entities.dart';
import 'package:flutter_test/flutter_test.dart';

/// 以固定 DTO 驗證系統 repository 映射 + 顯示文字轉繁（§5.0）+ 版本檢查 fail-open。
/// 不觸網。未觸發真實 sign_in/feedback（§7.0）——remote 為 fake。
class _FakeSystemRemote implements SystemRemoteDataSource {
  _FakeSystemRemote({
    this.signInDto = const SignInResponseDto(),
    this.signedAlready = false,
    this.version = const VersionCheck(needUpdate: false),
    this.versionThrows = false,
    this.changelogList = const <VersionLogItemDto>[],
    this.announcement,
    this.feedbackResponse = const FeedbackSubmitResponseDto(),
  });

  final SignInResponseDto signInDto;
  final bool signedAlready;
  final VersionCheck version;
  final bool versionThrows;
  final List<VersionLogItemDto> changelogList;
  final AppStartupAnnouncementDto? announcement;
  final FeedbackSubmitResponseDto feedbackResponse;

  int? lastSort;
  int? lastType;

  @override
  Future<({SignInResponseDto data, bool alreadySigned})> signIn() async =>
      (data: signInDto, alreadySigned: signedAlready);

  @override
  Future<VersionCheck> checkVersion() async {
    if (versionThrows) {
      throw const SocketException('offline');
    }
    return version;
  }

  @override
  Future<List<VersionLogItemDto>> changelog() async => changelogList;

  @override
  Future<AppStartupAnnouncementDto?> startupAnnouncement() async =>
      announcement;

  @override
  Future<FeedbackSubmitResponseDto> submitFeedback({
    required int reportSort,
    required int reportType,
    required String title,
    required String content,
  }) async {
    lastSort = reportSort;
    lastType = reportType;
    return feedbackResponse;
  }
}

void main() {
  late ChineseConverter converter;

  setUpAll(() async {
    converter = ChineseConverter(loader: (String k) => File(k).readAsString());
    await converter.ensureLoaded();
  });

  SystemRepositoryImpl build(_FakeSystemRemote remote) =>
      SystemRepositoryImpl(remote: remote, converter: converter);

  test('signIn：{points,totalScore} 映射', () async {
    final repo = build(
      _FakeSystemRemote(
        signInDto: const SignInResponseDto(points: 5, totalScore: 128),
      ),
    );
    final SignInResult r =
        ((await repo.signIn()) as ApiSuccess<SignInResult>).data;
    expect(r.points, 5);
    expect(r.totalScore, 128);
    expect(r.alreadySigned, isFalse);
  });

  test('signIn：server 未回 points → 預設 3（DEFAULT_SIGN_IN_POINTS）', () async {
    // DTO 未帶 points → freezed 預設 3。
    final repo = build(
      _FakeSystemRemote(
        signInDto: SignInResponseDto.fromJson(const <String, dynamic>{
          'totalScore': 10,
        }),
      ),
    );
    final SignInResult r =
        ((await repo.signIn()) as ApiSuccess<SignInResult>).data;
    expect(r.points, 3);
    expect(r.totalScore, 10);
  });

  test('signIn：今日已簽（201/已簽到）→ alreadySigned=true', () async {
    final repo = build(_FakeSystemRemote(signedAlready: true));
    final SignInResult r =
        ((await repo.signIn()) as ApiSuccess<SignInResult>).data;
    expect(r.alreadySigned, isTrue);
  });

  test('checkVersion：fail-open（網路錯誤 → needUpdate=false）', () async {
    final repo = build(_FakeSystemRemote(versionThrows: true));
    final VersionCheck v = await repo.checkVersion();
    expect(v.needUpdate, isFalse);
  });

  test('checkVersion：501 → needUpdate=true + appUrl', () async {
    final repo = build(
      _FakeSystemRemote(
        version: const VersionCheck(
          needUpdate: true,
          appUrl: 'https://x/a.apk',
        ),
      ),
    );
    final VersionCheck v = await repo.checkVersion();
    expect(v.needUpdate, isTrue);
    expect(v.appUrl, 'https://x/a.apk');
  });

  test('changelog：更新內容轉繁 + current 旗標', () async {
    final repo = build(
      _FakeSystemRemote(
        changelogList: const <VersionLogItemDto>[
          VersionLogItemDto(
            versionName: '1.74.1',
            updateContent: '修复了若干问题', // 簡體
            current: true,
          ),
        ],
      ),
    );
    final List<VersionLog> logs =
        ((await repo.changelog()) as ApiSuccess<List<VersionLog>>).data;
    expect(logs.single.versionName, '1.74.1');
    expect(logs.single.updateContent, '修復了若干問題'); // 轉繁
    expect(logs.single.isCurrent, isTrue);
  });

  test('startupAnnouncement：無公告回 null；有則轉繁', () async {
    expect(
      ((await build(_FakeSystemRemote()).startupAnnouncement())
              as ApiSuccess<StartupAnnouncement?>)
          .data,
      isNull,
    );
    final repo = build(
      _FakeSystemRemote(
        announcement: const AppStartupAnnouncementDto(
          bid: 3,
          title: '春季书单', // 簡體
          content: '限时免费',
          actionUrl: 'https://x/list',
        ),
      ),
    );
    final StartupAnnouncement ann =
        ((await repo.startupAnnouncement()) as ApiSuccess<StartupAnnouncement?>)
            .data!;
    expect(ann.title, '春季書單'); // 轉繁
    expect(ann.hasAction, isTrue);
    expect(ann.identityKey, 'system_block_3'); // 無 dismissKey → bid fallback
  });

  test('submitFeedback：sort/type 值原樣送出（reportType=0 為合法）', () async {
    final remote = _FakeSystemRemote(
      feedbackResponse: const FeedbackSubmitResponseDto(reportId: 99),
    );
    final repo = build(remote);
    final int id =
        ((await repo.submitFeedback(
                  sort: FeedbackSort.error,
                  type: FeedbackSort.error.types.last, // 其他 = 0
                  title: '标题',
                  content: '内容',
                ))
                as ApiSuccess<int>)
            .data;
    expect(id, 99);
    expect(remote.lastSort, 2); // 錯誤
    expect(remote.lastType, 0); // 其他
  });
}
