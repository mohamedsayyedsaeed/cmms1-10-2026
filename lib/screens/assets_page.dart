import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_icons.dart';
import '../core/theme/context_ext.dart';
import '../core/theme/tw_colors.dart';
import '../data/mock_data.dart';
import '../data/models.dart';
import '../widgets/app_badge.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/app_text_field.dart';
import '../widgets/dialogs.dart';
import '../widgets/icon_btn.dart';
import '../widgets/layout.dart';

/// AssetsPage.tsx: search, risk-colored cards, and the filter bottom-sheet
/// (location / manufacturer / risk factor / device type — collapsible sections).
class AssetsPage extends StatefulWidget {
  const AssetsPage({super.key});

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  String _search = '';
  String _riskFilter = 'all';
  bool get _hasFilter => _riskFilter != 'all';

  List<Asset> get _filtered {
    return mockAssets.where((Asset a) {
      if (_search.isNotEmpty) {
        final String q = _search.toLowerCase();
        final bool matches = a.name.toLowerCase().contains(q) ||
            a.model.toLowerCase().contains(q) ||
            a.serialNumber.toLowerCase().contains(q) ||
            a.location.toLowerCase().contains(q);
        if (!matches) return false;
      }
      if (_riskFilter != 'all' && a.riskScore.label != _riskFilter) return false;
      return true;
    }).toList();
  }

  Color _riskBorder(RiskScore r) {
    switch (r) {
      case RiskScore.high:
        return Tw.red.shade500;
      case RiskScore.medium:
        return Tw.yellow.shade500;
      case RiskScore.low:
        return Tw.green.shade500;
    }
  }

  BadgeVariant _riskVariant(RiskScore r) {
    switch (r) {
      case RiskScore.high:
        return BadgeVariant.danger;
      case RiskScore.medium:
        return BadgeVariant.warning;
      case RiskScore.low:
        return BadgeVariant.success;
    }
  }

  String _riskLabel(BuildContext context, RiskScore r) {
    switch (r) {
      case RiskScore.high:
        return context.t('highRisk');
      case RiskScore.medium:
        return context.t('mediumRisk');
      case RiskScore.low:
        return context.t('lowRisk');
    }
  }

  BadgeVariant _statusVariant(AssetStatus s) {
    switch (s) {
      case AssetStatus.operational:
        return BadgeVariant.success;
      case AssetStatus.maintenance:
        return BadgeVariant.warning;
      case AssetStatus.outOfService:
        return BadgeVariant.danger;
    }
  }

  void _openFilters() {
    showTopSheet<void>(
      context,
      builder: (BuildContext ctx) => _FilterSheet(
        selected: _riskFilter,
        onApply: (String v) {
          setState(() => _riskFilter = v);
          Navigator.of(ctx).pop();
        },
        onClear: () {
          setState(() => _riskFilter = 'all');
          Navigator.of(ctx).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Asset> assets = _filtered;

    return PageList(
      safeTop: true,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: PageTitle(context.t('assets'))),
            IconBtn(
              icon: AppIcons.filter,
              onPressed: _openFilters,
              background: _hasFilter ? AppColors.primary : null,
              color: _hasFilter ? Colors.white : null,
            ),
            const SizedBox(width: 8),
            IconBtn(icon: AppIcons.qrCode, onPressed: () {}),
          ],
        ),
        AppTextField(
          hint: context.t('search'),
          icon: AppIcons.search,
          onChanged: (String v) => setState(() => _search = v),
        ),
        if (_hasFilter)
          Row(
            children: <Widget>[
              Icon(AppIcons.filter, size: 16, color: context.textSecondary),
              const SizedBox(width: 8),
              Text('${context.t('filter')} active', style: TextStyle(fontSize: 13, color: context.textSecondary)),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() => _riskFilter = 'all'),
                child: Text(context.t('clearFilters'), style: const TextStyle(fontSize: 13, color: AppColors.primary)),
              ),
            ],
          ),
        if (assets.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Center(child: Text(context.t('noData'), style: TextStyle(color: context.textSecondary))),
          )
        else
          Column(
            children: spaced(assets.map((Asset a) {
              return AppCard(
                padding: CardPadding.md,
                borderColor: context.borderColor,
                leftAccent: _riskBorder(a.riskScore),
                onTap: () => context.go('/assets/${a.id}'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(a.name, style: TextStyle(fontWeight: FontWeight.w600, color: context.textPrimary)),
                              Text('${a.model} • ${a.serialNumber}', style: TextStyle(fontSize: 13, color: context.textSecondary)),
                            ],
                          ),
                        ),
                        AppBadge(_riskLabel(context, a.riskScore), variant: _riskVariant(a.riskScore)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(border: Border(top: BorderSide(color: context.borderColor))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(a.location, style: TextStyle(fontSize: 12, color: context.textSecondary)),
                          AppBadge(a.status.label, variant: _statusVariant(a.status), small: true),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(), 12),
          ),
      ],
    );
  }
}

class _FilterSheet extends StatelessWidget {
  const _FilterSheet({required this.selected, required this.onApply, required this.onClear});

  final String selected;
  final ValueChanged<String> onApply;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    String pending = selected;
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.85),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(16, MediaQuery.paddingOf(context).top + 16, 16, 16),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text(context.t('filterAssets'), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: context.textPrimary))),
                  IconBtn(icon: AppIcons.x, onPressed: () => Navigator.of(context).pop()),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: <Widget>[
                    Text(context.t('riskFactor'), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimary)),
                    const SizedBox(height: 8),
                    Column(
                      children: <(String, String)>[
                        ('all', context.t('allRiskFactors')),
                        ('high', context.t('highRisk')),
                        ('medium', context.t('mediumRisk')),
                        ('low', context.t('lowRisk')),
                      ].map((opt) {
                        final bool active = pending == opt.$1;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Material(
                            color: active ? AppColors.primary.op(context.isDark ? 0.1 : 0.05) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              onTap: () => setState(() => pending = opt.$1),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: active ? AppColors.primary : context.borderColor, width: 2),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(child: Text(opt.$2, style: TextStyle(fontWeight: FontWeight.w500, color: context.textPrimary))),
                                    if (active) const Icon(AppIcons.check, color: AppColors.primary),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.paddingOf(context).bottom),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: context.borderColor))),
              child: Row(
                children: <Widget>[
                  Expanded(child: AppButton(label: context.t('clearFilters'), variant: ButtonVariant.outline, fullWidth: true, onPressed: onClear)),
                  const SizedBox(width: 12),
                  Expanded(child: AppButton(label: context.t('applyFilters'), fullWidth: true, onPressed: () => onApply(pending))),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
