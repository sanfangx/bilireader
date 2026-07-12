import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../../../core/auth/auth_session_manager.dart';
import '../../../core/crypto/login_proof.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/app_error.dart';
import '../../../core/network/error_mapper.dart';
import '../domain/auth_repository.dart';
import '../domain/register_captcha.dart';
import '../domain/user_info.dart';
import 'auth_remote_data_source.dart';
import 'device_id_resolver.dart';
import 'dto/user_entity.dart';

/// [AuthRepository] 實作（規範 §7.3）。login 編排 challenge→proof→login→存 token→
/// getUserInfo→存 uid/groupid。`pass` 明文只於此短暫存在（proof 計算與 login body），
/// 不儲存 / 不記錄（§7.3）。
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthSessionManager session,
    required DeviceIdResolver deviceIdResolver,
    Uuid? uuid,
    int Function()? clockMs,
  }) : _remote = remote,
       _session = session,
       _deviceIdResolver = deviceIdResolver,
       _uuid = uuid ?? const Uuid(),
       _clockMs = clockMs;

  final AuthRemoteDataSource _remote;
  final AuthSessionManager _session;
  final DeviceIdResolver _deviceIdResolver;
  final Uuid _uuid;
  final int Function()? _clockMs;

  @override
  Future<ApiResult<UserInfo>> login({
    required String uname,
    required String pass,
  }) async {
    try {
      final challenge = await _remote.challenge(uname);
      final String nonce = LoginProof.newNonce(_uuid);
      final int ts = _clockMs?.call() ?? DateTime.now().millisecondsSinceEpoch;
      final String proof = LoginProof.build(
        challenge: challenge.challenge,
        uname: uname,
        pass: pass,
        nonce: nonce,
        timestampMs: ts,
      );
      final loginResp = await _remote.login(
        uname: uname,
        pass: pass,
        challengeId: challenge.challengeId,
        proof: proof,
        nonce: nonce,
        timestampMs: ts,
      );
      // 先存 token，讓後續 getUserInfo 帶上 Authorization。
      await _session.persist(token: loginResp.token);
      return _fetchAndPersistUser(loginResp.token);
    } on DioException catch (e) {
      return ApiFailure<UserInfo>(ErrorMapper.fromDio(e));
    } on AppError catch (e) {
      return ApiFailure<UserInfo>(e);
    }
  }

  @override
  Future<ApiResult<UserInfo>> getUserInfo() async {
    try {
      final UserEntity entity = await _remote.getUserInfo();
      return ApiSuccess<UserInfo>(_mapUser(entity));
    } on DioException catch (e) {
      return ApiFailure<UserInfo>(ErrorMapper.fromDio(e));
    } on AppError catch (e) {
      return ApiFailure<UserInfo>(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _remote.logout();
    } on Object catch (_) {
      // best-effort：忽略 server 錯誤。
    }
    await _session.clear();
  }

  @override
  Future<ApiResult<RegisterCaptcha>> loadCaptcha() async {
    try {
      final captcha = await _remote.loadCaptcha();
      return ApiSuccess<RegisterCaptcha>(
        RegisterCaptcha(captchaId: captcha.captchaId, imageBase64: captcha.img),
      );
    } on DioException catch (e) {
      return ApiFailure<RegisterCaptcha>(ErrorMapper.fromDio(e));
    } on AppError catch (e) {
      return ApiFailure<RegisterCaptcha>(e);
    }
  }

  @override
  Future<ApiResult<UserInfo>> register({
    required String uname,
    required String nickname,
    required String pass,
    required String email,
    required String captchaId,
    required String captcha,
  }) async {
    try {
      final String deviceId = await _deviceIdResolver.resolve();
      final resp = await _remote.register(
        uname: uname,
        name: nickname,
        pass: pass,
        email: email,
        captchaId: captchaId,
        captcha: captcha,
        deviceId: deviceId,
      );
      await _session.persist(token: resp.token);
      return _fetchAndPersistUser(resp.token);
    } on DioException catch (e) {
      return ApiFailure<UserInfo>(ErrorMapper.fromDio(e));
    } on AppError catch (e) {
      return ApiFailure<UserInfo>(e);
    }
  }

  Future<ApiResult<UserInfo>> _fetchAndPersistUser(String token) async {
    final UserEntity entity = await _remote.getUserInfo();
    final UserInfo info = _mapUser(entity);
    await _session.persist(token: token, uid: info.uid, groupId: info.groupid);
    return ApiSuccess<UserInfo>(info);
  }

  UserInfo _mapUser(UserEntity e) {
    return UserInfo(
      uid: e.uid ?? 0,
      username: e.uname,
      nickname: e.name,
      avatarUrl: e.avatarUrl,
      groupid: e.groupid,
      level: e.level,
      isVip: e.isVipUser,
      experience: e.experience,
      score: e.score,
      egold: e.egold,
      credit: e.credit,
      votes: e.votes,
      sign: e.sign,
      email: e.email,
    );
  }
}
