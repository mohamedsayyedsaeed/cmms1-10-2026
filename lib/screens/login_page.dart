import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_icons.dart';
import '../core/theme/context_ext.dart';
import '../core/theme/tone.dart';
import '../state/app_state.dart';
import '../widgets/anim.dart';
import '../widgets/backgrounds.dart';
import '../widgets/glass.dart';
import '../widgets/icon_btn.dart';

/// LoginPage.tsx: brand-blue background, Face-ID button, staff-ID/password form.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _staffId = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _rememberMe = false;
  bool _loading = false;

  @override
  void dispose() {
    _staffId.dispose();
    _password.dispose();
    super.dispose();
  }

  void _login() {
    setState(() => _loading = true);
    Future<void>.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) context.go('/dashboard');
    });
  }

  void _biometricLogin() {
    setState(() => _loading = true);
    Future<void>.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) context.go('/dashboard');
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppState app = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppColors.brandBlue,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const DecoratedBox(decoration: BoxDecoration(gradient: Gradients.brandScreen)),
          Opacity(
            opacity: 0.2,
            child: CustomPaint(painter: GridPainter(spacing: 50, color: Colors.white.op(0.1))),
          ),
          const Positioned.fill(child: BinaryRain()),
          Positioned(
            top: 40,
            left: 40,
            child: Float(
              child: Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.cyanAccent.op(0.2)),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: 40,
            child: Float(
              delay: const Duration(seconds: 1),
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.cyanAccent.op(0.2)),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: IconBtn(
                      icon: AppIcons.globe,
                      onPressed: app.toggleLanguage,
                      background: Colors.white.op(0.1),
                      borderColor: Colors.white.op(0.2),
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset('assets/images/logo_white.png', width: 200),
                            const SizedBox(height: 24),
                            Text(
                              context.t('welcomeBack'),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              context.t('loginToContinue'),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14, color: Colors.cyan.shade100),
                            ),
                            const SizedBox(height: 32),
                            GlassBox(
                              radius: 24,
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 24),
                                    child: Column(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: _loading ? null : _biometricLogin,
                                          child: Opacity(
                                            opacity: _loading ? 0.5 : 1,
                                            child: Container(
                                              width: 96,
                                              height: 96,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: <Color>[
                                                    Colors.cyan.shade300,
                                                    Colors.cyan.shade700,
                                                  ],
                                                ),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                    color: Colors.cyan.op(0.3),
                                                    blurRadius: 25,
                                                    spreadRadius: -4,
                                                  ),
                                                ],
                                              ),
                                              child: const Icon(
                                                AppIcons.faceId,
                                                size: 48,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          context.t('biometricLogin'),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: Colors.white.op(0.2),
                                    margin: const EdgeInsets.only(bottom: 24),
                                  ),
                                  _LoginField(
                                    label: 'Staff ID',
                                    hint: 'EMP-12345',
                                    icon: AppIcons.user,
                                    controller: _staffId,
                                  ),
                                  const SizedBox(height: 16),
                                  _LoginField(
                                    label: context.t('password'),
                                    hint: '••••••••',
                                    icon: AppIcons.lock,
                                    controller: _password,
                                    obscure: true,
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Checkbox(
                                          value: _rememberMe,
                                          onChanged: (bool? v) =>
                                              setState(() => _rememberMe = v ?? false),
                                          fillColor: WidgetStateProperty.resolveWith(
                                            (states) => states.contains(WidgetState.selected)
                                                ? Colors.cyanAccent
                                                : Colors.white.op(0.1),
                                          ),
                                          side: BorderSide(color: Colors.white.op(0.5)),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        context.t('rememberMe'),
                                        style: const TextStyle(color: Colors.white, fontSize: 14),
                                      ),
                                      const Spacer(),
                                      TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          context.t('forgotPassword'),
                                          style: TextStyle(
                                            color: Colors.cyan.shade200,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: _GradientSubmitButton(
                                      loading: _loading,
                                      label: context.t('login'),
                                      onPressed: _loading ? null : _login,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              context.t('allRightsReserved'),
                              style: TextStyle(color: Colors.white.op(0.6), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginField extends StatelessWidget {
  const _LoginField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.obscure = false,
  });

  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.op(0.5)),
            prefixIcon: Icon(icon, size: 20, color: Colors.white.op(0.6)),
            filled: true,
            fillColor: Colors.white.op(0.1),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            constraints: const BoxConstraints(minHeight: 44),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.op(0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.op(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _GradientSubmitButton extends StatelessWidget {
  const _GradientSubmitButton({
    required this.loading,
    required this.label,
    required this.onPressed,
  });

  final bool loading;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPressed == null ? 0.5 : 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: <Color>[Colors.cyan.shade400, Colors.cyan.shade600],
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.cyan.op(0.3), blurRadius: 15, spreadRadius: -3),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              constraints: const BoxConstraints(minHeight: 44),
              alignment: Alignment.center,
              child: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
