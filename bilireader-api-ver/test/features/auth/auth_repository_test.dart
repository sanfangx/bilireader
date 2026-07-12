import 'package:bilireader/core/auth/auth_session_manager.dart';
import 'package:bilireader/core/crypto/login_proof.dart';
import 'package:bilireader/core/network/api_result.dart';
import 'package:bilireader/core/network/error_mapper.dart';
import 'package:bilireader/features/auth/data/auth_remote_data_source.dart';
import 'package:bilireader/features/auth/data/auth_repository_impl.dart';
import 'package:bilireader/features/auth/data/device_id_resolver.dart';
import 'package:bilireader/features/auth/data/dto/login_challenge_response.dart';
import 'package:bilireader/features/auth/data/dto/login_response.dart';
import 'package:bilireader/features/auth/data/dto/register_captcha_response.dart';
import 'package:bilireader/features/auth/data/dto/user_entity.dart';
import 'package:bilireader/features/auth/domain/user_info.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_stores.dart';

class _FakeAuthRemote implements AuthRemoteDataSource {
  _FakeAuthRemote({this.challengeResp, this.loginResp, this.userEntity});

  LoginChallengeResponse? challengeResp;
  LoginResponse? loginResp;
  UserEntity? userEntity;
  Object? loginError;
  bool logoutThrows = false;
  bool logoutCalled = false;
  Map<String, Object?>? capturedLogin;

  @override
  Future<LoginChallengeResponse> challenge(String uname) async =>
      challengeResp!;

  @override
  Future<LoginResponse> login({
    required String uname,
    required String pass,
    required String challengeId,
    required String proof,
    required String nonce,
    required int timestampMs,
  }) async {
    capturedLogin = <String, Object?>{
      'uname': uname,
      'pass': pass,
      'challengeId': challengeId,
      'proof': proof,
      'nonce': nonce,
      'timestamp': timestampMs,
    };
    final Object? err = loginError;
    if (err != null) {
      throw err;
    }
    return loginResp!;
  }

  @override
  Future<UserEntity> getUserInfo() async => userEntity!;

  @override
  Future<void> logout() async {
    logoutCalled = true;
    if (logoutThrows) {
      throw Exception('network');
    }
  }

  @override
  Future<RegisterCaptchaResponse> loadCaptcha() async =>
      throw UnimplementedError();

  @override
  Future<LoginResponse> register({
    required String uname,
    required String name,
    required String pass,
    required String email,
    required String captchaId,
    required String captcha,
    required String deviceId,
  }) async => throw UnimplementedError();
}

class _FakeDeviceIdResolver implements DeviceIdResolver {
  @override
  Future<String> resolve() async => 'device-xyz';
}

void main() {
  test('login：challenge→proof→login→getUserInfo→存 session，proof 正確', () async {
    final _FakeAuthRemote remote = _FakeAuthRemote(
      challengeResp: const LoginChallengeResponse(
        challenge: 'CH',
        challengeId: 'CID',
      ),
      loginResp: const LoginResponse(token: 'TOK'),
      userEntity: const UserEntity(uid: 42, name: '张三', groupid: 5),
    );
    final FakeTokenStore ts = FakeTokenStore();
    final FakeSessionStore ss = FakeSessionStore();
    final AuthRepositoryImpl repo = AuthRepositoryImpl(
      remote: remote,
      session: AuthSessionManager(tokenStore: ts, sessionStore: ss),
      deviceIdResolver: _FakeDeviceIdResolver(),
      clockMs: () => 1700000000000,
    );

    final ApiResult<UserInfo> result = await repo.login(
      uname: 'user',
      pass: 'pass',
    );
    final UserInfo info = (result as ApiSuccess<UserInfo>).data;

    expect(info.uid, 42);
    expect(info.nickname, '张三'); // data 層保留原文；presentation 才轉繁
    expect(info.groupid, 5);
    // session 已存 token/uid/groupid。
    expect(ts.token, 'TOK');
    expect(ss.uid, 42);
    expect(ss.groupId, 5);
    // proof = md5(challenge|uname|pass|nonce|timestamp)。
    final Map<String, Object?> cap = remote.capturedLogin!;
    expect(cap['timestamp'], 1700000000000);
    expect(
      cap['proof'],
      LoginProof.build(
        challenge: 'CH',
        uname: 'user',
        pass: 'pass',
        nonce: cap['nonce']! as String,
        timestampMs: 1700000000000,
      ),
    );
  });

  test('login 401 → ApiFailure(unauthorized)', () async {
    final _FakeAuthRemote remote = _FakeAuthRemote(
      challengeResp: const LoginChallengeResponse(
        challenge: 'CH',
        challengeId: 'CID',
      ),
    )..loginError = ErrorMapper.fromBusinessCode(code: 401);
    final AuthRepositoryImpl repo = AuthRepositoryImpl(
      remote: remote,
      session: AuthSessionManager(
        tokenStore: FakeTokenStore(),
        sessionStore: FakeSessionStore(),
      ),
      deviceIdResolver: _FakeDeviceIdResolver(),
    );

    final ApiResult<UserInfo> result = await repo.login(uname: 'u', pass: 'p');
    expect((result as ApiFailure<UserInfo>).error.isUnauthorized, isTrue);
  });

  test('logout：即使 server 失敗也清本地 session', () async {
    final _FakeAuthRemote remote = _FakeAuthRemote()..logoutThrows = true;
    final FakeTokenStore ts = FakeTokenStore()..token = 'TOK';
    final FakeSessionStore ss = FakeSessionStore()..uid = 42;
    final AuthSessionManager session = AuthSessionManager(
      tokenStore: ts,
      sessionStore: ss,
    );
    await session.load();
    final AuthRepositoryImpl repo = AuthRepositoryImpl(
      remote: remote,
      session: session,
      deviceIdResolver: _FakeDeviceIdResolver(),
    );

    await repo.logout();

    expect(remote.logoutCalled, isTrue);
    expect(ts.token, isNull);
    expect(ss.uid, isNull);
  });
}
