import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common_widgets/app_capsule_button.dart';
import '../../../core/network/app_error.dart';
import '../../../core/router/auth_controller.dart';
import '../../../core/text/text_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../domain/register_captcha.dart';
import 'register_controller.dart';

/// 註冊頁（設計稿「② 註冊 Register」）。欄位/規則比照原生 `RegisterActivity`：
/// 帳號 2–20、暱稱 1–20、密碼 6–32、確認密碼相符、Email 格式、圖形驗證碼（單次有效、點圖刷新）。
/// 成功即自動登入（repository 存 token）→ 觀察認證態自動返回（§5.2，同登入頁）。
/// 密碼為明文送出（比照原生註冊，非登入的挑戰式）；密碼欄不記錄。
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final TextEditingController _uname = TextEditingController();
  final TextEditingController _nick = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _captcha = TextEditingController();

  /// 前端驗證訊息（伺服器錯誤另由 controller state 顯示）。
  String? _clientError;

  @override
  void dispose() {
    _uname.dispose();
    _nick.dispose();
    _pass.dispose();
    _confirm.dispose();
    _email.dispose();
    _captcha.dispose();
    super.dispose();
  }

  /// 前端驗證（比照原生 `RegisterActivity`：uname/nickname/email/captcha 皆 trim 後驗證＋送出，
  /// 密碼/確認密碼不 trim）。回 null 表通過。
  String? _validate() {
    final String uname = _uname.text.trim();
    final String nick = _nick.text.trim();
    if (uname.length < 2 || uname.length > 20) {
      return '帳號需 2–20 字';
    }
    if (nick.isEmpty || nick.length > 20) {
      return '暱稱需 1–20 字';
    }
    if (_pass.text.length < 6 || _pass.text.length > 32) {
      return '密碼需 6–32 字';
    }
    if (_confirm.text != _pass.text) {
      return '兩次輸入的密碼不一致';
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(_email.text.trim())) {
      return 'Email 格式不正確';
    }
    if (_captcha.text.trim().isEmpty) {
      return '請輸入圖形驗證碼';
    }
    return null;
  }

  Future<void> _submit(String captchaId) async {
    FocusScope.of(context).unfocus();
    final String? err = _validate();
    if (err != null) {
      setState(() => _clientError = err);
      return;
    }
    setState(() => _clientError = null);
    // 成功後導航由「觀察認證態 → 自動返回」處理（同登入頁），此處不手動 pop。
    await ref
        .read(registerControllerProvider.notifier)
        .submit(
          uname: _uname.text.trim(),
          nickname: _nick.text.trim(),
          pass: _pass.text,
          email: _email.text.trim(),
          captchaId: captchaId,
          captcha: _captcha.text.trim(),
        );
  }

  String _toTw(String text) {
    try {
      return ref.read(chineseConverterProvider).toTraditionalTw(text);
    } on Object catch (_) {
      return text;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 註冊成功即自動登入 → 認證態成立即離開本頁（同登入頁，避免刷新重建與 pop 競態）。
    final bool loggedIn = ref.watch(authControllerProvider).isLoggedIn;
    if (loggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && context.canPop()) {
          context.pop();
        }
      });
    }

    final AsyncValue<void> state = ref.watch(registerControllerProvider);
    final bool loading = state.isLoading;
    final Object? err = state.error;
    final String? serverError =
        (state.hasError && err is AppError && !err.isCancelled)
        ? _toTw(err.message)
        : null;
    final String? errorText = _clientError ?? serverError;

    final AsyncValue<RegisterCaptcha> captcha = ref.watch(
      registerCaptchaProvider,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('註冊帳號')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: AppSpacing.md),
              _Field(
                key: const Key('reg_uname'),
                controller: _uname,
                label: '帳號（2–20 字）',
                enabled: !loading,
              ),
              const SizedBox(height: AppSpacing.md),
              _Field(
                key: const Key('reg_nick'),
                controller: _nick,
                label: '暱稱（1–20 字）',
                enabled: !loading,
              ),
              const SizedBox(height: AppSpacing.md),
              _Field(
                key: const Key('reg_pass'),
                controller: _pass,
                label: '密碼（6–32 字）',
                obscure: true,
                enabled: !loading,
              ),
              const SizedBox(height: AppSpacing.md),
              _Field(
                key: const Key('reg_confirm'),
                controller: _confirm,
                label: '確認密碼',
                obscure: true,
                enabled: !loading,
              ),
              const SizedBox(height: AppSpacing.md),
              _Field(
                key: const Key('reg_email'),
                controller: _email,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                enabled: !loading,
              ),
              const SizedBox(height: AppSpacing.md),
              // 驗證碼列（設計 `.reg-cap`）：輸入框 + 圖片（點圖刷新）。
              Row(
                children: <Widget>[
                  Expanded(
                    child: _Field(
                      key: const Key('reg_captcha'),
                      controller: _captcha,
                      label: '圖形驗證碼',
                      enabled: !loading,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _CaptchaImage(
                    state: captcha,
                    onRefresh: () => ref.invalidate(registerCaptchaProvider),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '點圖可刷新 · 單次有效',
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 10,
                  color: AppColors.mut,
                ),
              ),
              if (errorText != null) ...<Widget>[
                const SizedBox(height: AppSpacing.md),
                Text(
                  errorText,
                  key: const Key('reg_error'),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.badgeRed,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              AppCapsuleButton(
                key: const Key('reg_submit'),
                label: loading ? '註冊中…' : '註冊並登入',
                expanded: true,
                onPressed: loading
                    ? null
                    : () => _submit(captcha.value?.captchaId ?? ''),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 驗證碼圖片（設計 `.reg-capimg`）：Base64 解碼顯示，點擊刷新。載入中/失敗顯示可點擊佔位。
class _CaptchaImage extends StatelessWidget {
  const _CaptchaImage({required this.state, required this.onRefresh});

  final AsyncValue<RegisterCaptcha> state;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    const double w = 100;
    const double h = 50;
    Widget child;
    final RegisterCaptcha? cap = state.value;
    if (cap != null && cap.imageBase64.isNotEmpty) {
      try {
        child = Image.memory(
          base64Decode(_stripDataUri(cap.imageBase64)),
          width: w,
          height: h,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          errorBuilder: (_, _, _) => const _CaptchaHint('重試'),
        );
      } on Object {
        child = const _CaptchaHint('重試');
      }
    } else if (state.isLoading) {
      child = const _CaptchaHint('…');
    } else {
      child = const _CaptchaHint('重試');
    }
    return GestureDetector(
      key: const Key('reg_captcha_image'),
      onTap: onRefresh,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: w,
          height: h,
          color: AppColors.surf,
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }

  /// 去除可能的 `data:image/...;base64,` 前綴。
  static String _stripDataUri(String s) {
    final int comma = s.indexOf(',');
    return (s.startsWith('data:') && comma >= 0) ? s.substring(comma + 1) : s;
  }
}

class _CaptchaHint extends StatelessWidget {
  const _CaptchaHint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: AppTypography.bodySmall.copyWith(color: AppColors.acc));
}

/// 輸入框（比照登入頁 `_InputField`）。
class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.enabled,
    this.obscure = false,
    this.keyboardType,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final bool enabled;
  final bool obscure;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      enabled: enabled,
      keyboardType: keyboardType,
      style: AppTypography.bodyLarge,
      cursorColor: AppColors.acc,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.mut),
        filled: true,
        fillColor: AppColors.surf,
        border: const OutlineInputBorder(
          borderRadius: AppRadius.buttonAll,
          borderSide: BorderSide(color: AppColors.line),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.buttonAll,
          borderSide: BorderSide(color: AppColors.line),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.buttonAll,
          borderSide: BorderSide(color: AppColors.acc),
        ),
      ),
    );
  }
}
