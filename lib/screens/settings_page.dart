import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_icons.dart';
import '../core/theme/context_ext.dart';
import '../core/theme/tone.dart';
import '../core/theme/tw_colors.dart';
import '../state/app_state.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_toggle.dart';
import '../widgets/dialogs.dart';
import '../widgets/icon_btn.dart';
import '../widgets/signature_pad.dart';
import '../widgets/toast.dart';
import '../widgets/tone_boxes.dart';

/// SettingsPage.tsx: account settings list, security toggles, app info, and
/// their language / password / mobile / email / signature / about / site-info modals.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _biometric = true;
  bool _notifications = true;
  bool _hasSignature = false;

  final SignatureController _signature = SignatureController();
  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _mobile = TextEditingController(text: '+966 50 123 4567');
  final TextEditingController _email = TextEditingController(text: 'ahmed@hospital.com');

  @override
  void dispose() {
    _signature.dispose();
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    _mobile.dispose();
    _email.dispose();
    super.dispose();
  }

  void _openLanguageModal() {
    final AppState app = context.read<AppState>();
    showAppDialog<void>(
      context,
      builder: (BuildContext ctx) => AppModal(
        title: context.t('selectLanguage'),
        icon: AppIcons.globe,
        tone: Tone.blue,
        child: Column(
          children: <Widget>[
            _LanguageOption(flag: '🇬🇧', label: context.t('english'), sublabel: context.t('englishUS'), selected: !app.isArabic, onTap: () {
              app.setLanguage('en');
              Navigator.of(ctx).pop();
            }),
            const SizedBox(height: 12),
            _LanguageOption(flag: '🇸🇦', label: context.t('arabic'), sublabel: context.t('arabicSA'), selected: app.isArabic, onTap: () {
              app.setLanguage('ar');
              Navigator.of(ctx).pop();
            }),
          ],
        ),
      ),
    );
  }

  void _openSignatureModal() {
    showAppDialog<void>(
      context,
      builder: (BuildContext ctx) => StatefulBuilder(builder: (BuildContext ctx, StateSetter setModalState) {
        return AppModal(
          title: context.t('userSignature'),
          icon: AppIcons.penTool,
          tone: Tone.indigo,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(context.t('signHere'), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: context.textPrimary)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(border: Border.all(color: context.borderColor, width: 2), borderRadius: BorderRadius.circular(12), color: Colors.white),
                clipBehavior: Clip.antiAlias,
                child: SignaturePad(controller: _signature),
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(child: AppButton(label: context.t('clear'), variant: ButtonVariant.outline, fullWidth: true, onPressed: () => setModalState(_signature.clear))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      label: context.t('save'),
                      fullWidth: true,
                      onPressed: () {
                        setState(() => _hasSignature = true);
                        Navigator.of(ctx).pop();
                        showSuccessToast(context, title: context.tRead('signatureSaved'), centered: true);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  void _openPasswordModal() {
    showAppDialog<void>(
      context,
      builder: (BuildContext ctx) => AppModal(
        title: context.t('changePassword'),
        icon: AppIcons.lock,
        tone: Tone.red,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AppTextField(label: context.t('currentPassword'), hint: context.t('enterCurrentPassword'), controller: _currentPassword, obscureText: true),
            const SizedBox(height: 12),
            AppTextField(label: context.t('newPassword'), hint: context.t('enterNewPassword'), controller: _newPassword, obscureText: true),
            const SizedBox(height: 12),
            AppTextField(label: context.t('confirmNewPassword'), hint: context.t('confirmPassword'), controller: _confirmPassword, obscureText: true),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(child: AppButton(label: context.t('cancel'), variant: ButtonVariant.outline, fullWidth: true, onPressed: () => Navigator.of(ctx).pop())),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    label: context.t('updatePasswordBtn'),
                    fullWidth: true,
                    onPressed: () {
                      _currentPassword.clear();
                      _newPassword.clear();
                      _confirmPassword.clear();
                      Navigator.of(ctx).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openMobileModal() {
    showAppDialog<void>(
      context,
      builder: (BuildContext ctx) => AppModal(
        title: context.t('changeMobileNumber'),
        icon: AppIcons.phone,
        tone: Tone.green,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AppTextField(label: context.t('mobileNumber'), hint: context.t('mobileNumberPlaceholder'), controller: _mobile, keyboardType: TextInputType.phone),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Tone.blue.softBg(context.isDark), borderRadius: BorderRadius.circular(12)),
              child: Text(context.t('verificationCodeSent'), style: TextStyle(fontSize: 12, color: Tone.blue.textMid(context.isDark))),
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(child: AppButton(label: context.t('cancel'), variant: ButtonVariant.outline, fullWidth: true, onPressed: () => Navigator.of(ctx).pop())),
                const SizedBox(width: 12),
                Expanded(child: AppButton(label: context.t('updateNumber'), fullWidth: true, onPressed: () => Navigator.of(ctx).pop())),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openEmailModal() {
    showAppDialog<void>(
      context,
      builder: (BuildContext ctx) => AppModal(
        title: context.t('changeEmail'),
        icon: AppIcons.mail,
        tone: Tone.purple,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AppTextField(label: context.t('email'), controller: _email, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(child: AppButton(label: context.t('cancel'), variant: ButtonVariant.outline, fullWidth: true, onPressed: () => Navigator.of(ctx).pop())),
                const SizedBox(width: 12),
                Expanded(child: AppButton(label: context.t('save'), fullWidth: true, onPressed: () => Navigator.of(ctx).pop())),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openAboutModal() {
    showAppDialog<void>(
      context,
      builder: (BuildContext ctx) => AppModal(
        title: context.t('aboutBiomark'),
        icon: AppIcons.info,
        tone: Tone.orange,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Column(
                children: <Widget>[
                  Image.asset('assets/images/logo_white.png', width: 128, color: context.textPrimary, colorBlendMode: BlendMode.srcIn),
                  const SizedBox(height: 12),
                  Text(context.t('biomarkCMMS'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimary)),
                  Text(context.t('healthcareMaintenance'), style: TextStyle(fontSize: 13, color: context.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _InfoLine(label: context.t('version'), value: '1.0.0'),
            const SizedBox(height: 8),
            _InfoLine(label: context.t('developer'), value: context.t('biomarkTech')),
            const SizedBox(height: 8),
            _InfoLine(label: context.t('support'), value: context.t('supportEmail')),
            const SizedBox(height: 16),
            Text(context.t('allRightsReserved'), textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: context.textSecondary)),
            const SizedBox(height: 16),
            AppButton(label: context.t('close'), fullWidth: true, onPressed: () => Navigator.of(ctx).pop()),
          ],
        ),
      ),
    );
  }

  void _openSiteInfoModal() {
    final bool isActive = DateTime.now().isBefore(DateTime(2025, 12, 31));
    showAppDialog<void>(
      context,
      builder: (BuildContext ctx) => AppModal(
        title: context.t('siteInformation'),
        icon: AppIcons.building,
        tone: Tone.teal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset('assets/images/site_logo.jpg', width: 96, height: 96, fit: BoxFit.cover),
                ),
                const SizedBox(height: 12),
                Text(context.t('alSeefHospital'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimary)),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isActive ? Tone.green : Tone.red).softBg(context.isDark),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(isActive ? AppIcons.checkCircleSolid : AppIcons.xCircle, size: 18, color: (isActive ? Tone.green : Tone.red).iconFg(context.isDark)),
                  const SizedBox(width: 8),
                  Text(
                    isActive ? context.t('active') : context.t('inactive'),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: (isActive ? Tone.green : Tone.red).textStrong(context.isDark)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: context.tileBg, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset('assets/images/flag_kuwait.png', width: 48, height: 48, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(context.t('country'), style: TextStyle(fontSize: 12, color: context.textSecondary)),
                        Text(context.t('kuwait'), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: context.tileBg, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: <Widget>[
                  const SoftIconBox(icon: AppIcons.calendar, tone: Tone.blue, size: 48, iconSize: 24),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(context.t('activeUntil'), style: TextStyle(fontSize: 12, color: context.textSecondary)),
                        Text(context.isArabic ? '٣١ ديسمبر ٢٠٢٥' : 'December 31, 2025', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: context.tileBg, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: <Widget>[
                  const SoftIconBox(icon: AppIcons.users, tone: Tone.green, size: 48, iconSize: 24),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(context.t('teamMembers'), style: TextStyle(fontSize: 12, color: context.textSecondary)),
                        Text('${context.isArabic ? '٣٢' : '32'} ${context.t('members')}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppButton(label: context.t('close'), fullWidth: true, onPressed: () => Navigator.of(ctx).pop()),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState app = context.watch<AppState>();

    return ColoredBox(
      color: context.pageBg,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(16, MediaQuery.paddingOf(context).top + 16, 16, 32),
            decoration: const BoxDecoration(gradient: Gradients.headerBlue),
            child: Row(
              children: <Widget>[
                IconBtn(icon: AppIcons.arrowBack, onPressed: () => Navigator.of(context).maybePop(), background: Colors.white.op(0.1), borderColor: Colors.white.op(0.2), color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(context.t('settings'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                      Text(context.t('managePreferences'), style: TextStyle(fontSize: 14, color: Colors.white.op(0.8))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -16),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, context.navBottomPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _SectionLabel(context.t('accountSettings')),
                  AppCard(
                    padding: CardPadding.none,
                    borderColor: context.borderColor,
                    child: Column(
                      children: <Widget>[
                        _SettingRow(icon: AppIcons.globe, tone: Tone.blue, label: context.t('changeLanguage'), sublabel: context.t('currentLanguage'), onTap: _openLanguageModal),
                        _SettingRow(icon: AppIcons.lock, tone: Tone.red, label: context.t('changePassword'), sublabel: context.t('updatePassword'), onTap: _openPasswordModal),
                        _SettingRow(icon: AppIcons.phone, tone: Tone.green, label: context.t('changeMobileNumber'), sublabel: '+966 50 123 4567', onTap: _openMobileModal),
                        _SettingRow(icon: AppIcons.mail, tone: Tone.purple, label: context.t('changeEmail'), sublabel: 'ahmed@hospital.com', onTap: _openEmailModal),
                        _SettingRow(
                          icon: AppIcons.penTool,
                          tone: Tone.indigo,
                          label: context.t('userSignature'),
                          sublabel: _hasSignature ? context.t('signatureSet') : context.t('noSignature'),
                          onTap: _openSignatureModal,
                          last: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _SectionLabel(context.t('security')),
                  AppCard(
                    padding: CardPadding.none,
                    borderColor: context.borderColor,
                    child: Column(
                      children: <Widget>[
                        _SettingRow(
                          icon: AppIcons.fingerprint,
                          tone: Tone.cyan,
                          label: context.t('biometricAuthentication'),
                          sublabel: _biometric ? context.t('enabled') : context.t('disabled'),
                          toggleValue: _biometric,
                          onToggle: (bool v) => setState(() => _biometric = v),
                        ),
                        _SettingRow(
                          icon: AppIcons.bell,
                          tone: Tone.yellow,
                          label: context.t('pushNotifications'),
                          sublabel: _notifications ? context.t('enabled') : context.t('disabled'),
                          toggleValue: _notifications,
                          onToggle: (bool v) => setState(() => _notifications = v),
                          last: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _SectionLabel(context.t('appInformation')),
                  AppCard(
                    padding: CardPadding.none,
                    borderColor: context.borderColor,
                    child: Column(
                      children: <Widget>[
                        _SettingRow(icon: AppIcons.info, tone: Tone.orange, label: context.t('aboutApp'), sublabel: context.t('learnMore'), onTap: _openAboutModal),
                        _SettingRow(icon: AppIcons.building, tone: Tone.teal, label: context.t('siteInformation'), sublabel: context.t('viewSiteDetails'), onTap: _openSiteInfoModal),
                        _SettingRow(icon: AppIcons.tag, tone: const Tone(Tw.gray), label: context.t('appVersion'), sublabel: 'v1.0.0', last: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Column(
                      children: <Widget>[
                        Text(context.t('allRightsReserved'), style: TextStyle(fontSize: 11, color: context.textSecondary)),
                        Text(context.t('healthcareCMMS'), style: TextStyle(fontSize: 11, color: context.textSecondary.op(0.7))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: context.textSecondary),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.tone,
    required this.label,
    required this.sublabel,
    this.onTap,
    this.toggleValue,
    this.onToggle,
    this.last = false,
  });

  final IconData icon;
  final Tone tone;
  final String label;
  final String sublabel;
  final VoidCallback? onTap;
  final bool? toggleValue;
  final ValueChanged<bool>? onToggle;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final bool isToggle = toggleValue != null && onToggle != null;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isToggle ? null : onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(border: last ? null : Border(bottom: BorderSide(color: context.borderColor))),
          child: Row(
            children: <Widget>[
              SoftIconBox(icon: icon, tone: tone, size: 48, iconSize: 24, radius: 16),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimary)),
                    Text(sublabel, style: TextStyle(fontSize: 12, color: context.textSecondary)),
                  ],
                ),
              ),
              if (isToggle)
                AppToggle(value: toggleValue!, onChanged: onToggle!, activeGradient: Gradients.primarySolid)
              else if (onTap != null)
                Icon(AppIcons.chevronRight, size: 20, color: Tw.gray.shade400),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: context.tileBg, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: TextStyle(fontSize: 11, color: context.textSecondary)),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimary)),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({required this.flag, required this.label, required this.sublabel, required this.selected, required this.onTap});

  final String flag;
  final String label;
  final String sublabel;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary.op(context.isDark ? 0.1 : 0.05) : Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: selected ? AppColors.primary : context.borderColor, width: 2)),
          child: Row(
            children: <Widget>[
              Text(flag, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: context.textPrimary)),
                    Text(sublabel, style: TextStyle(fontSize: 12, color: context.textSecondary)),
                  ],
                ),
              ),
              if (selected) const Icon(AppIcons.check, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
