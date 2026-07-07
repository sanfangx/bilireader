import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common_widgets/app_capsule_button.dart';
import '../../../core/network/app_error.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/router/auth_controller.dart';
import '../../../core/text/text_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'login_controller.dart';

/// 登入頁（規範 §5.2、§7.3）。challenge→proof→login→getUserInfo 由 repository 完成；
/// 顯示 loading / error（server 訊息經 OpenCC 轉繁）；成功後返回並刷新認證狀態。
/// login 的 uname/pass 不 trim（對照原生），密碼欄不記錄。
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _uname = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  @override
  void dispose() {
    _uname.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    // 成功後導航由 router 守衛負責（登入態刷新 → refreshListenable → 導離 /login）；
    // 失敗則留在本頁顯示錯誤。此處不手動 pop，避免與刷新重建競態。
    await ref
        .read(loginControllerProvider.notifier)
        .submit(uname: _uname.text, pass: _pass.text);
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
    // 認證態一旦成立即離開登入頁（§5.2「成功後返回」）。以「觀察登入態 + post-frame
    // pop」取代 submit 內手動 pop：即使認證刷新導致本頁重建，重建後仍會偵測到已登入
    // 並返回，避免刷新重建與 pop 的競態。
    final bool loggedIn = ref.watch(authControllerProvider).isLoggedIn;
    if (loggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && context.canPop()) {
          context.pop();
        }
      });
    }

    final AsyncValue<void> state = ref.watch(loginControllerProvider);
    final bool loading = state.isLoading;
    final Object? err = state.error;
    final String? errorText =
        (state.hasError && err is AppError && !err.isCancelled)
        ? _toTw(err.message)
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('登入')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: AppSpacing.xl),
              _InputField(
                key: const Key('login_uname'),
                controller: _uname,
                label: '帳號或信箱',
                enabled: !loading,
              ),
              const SizedBox(height: AppSpacing.md),
              _InputField(
                key: const Key('login_pass'),
                controller: _pass,
                label: '密碼',
                obscure: true,
                enabled: !loading,
                onSubmitted: loading ? null : (_) => _submit(),
              ),
              if (errorText != null) ...<Widget>[
                const SizedBox(height: AppSpacing.md),
                Text(
                  errorText,
                  key: const Key('login_error'),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.badgeRed,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              AppCapsuleButton(
                key: const Key('login_submit'),
                label: loading ? '登入中…' : '登入',
                expanded: true,
                onPressed: loading ? null : _submit,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: loading
                    ? null
                    : () => context.pushNamed(AppRoutes.registerName),
                child: const Text('還沒有帳號？前往註冊'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.label,
    required this.enabled,
    this.obscure = false,
    this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final bool enabled;
  final bool obscure;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      enabled: enabled,
      onSubmitted: onSubmitted,
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
