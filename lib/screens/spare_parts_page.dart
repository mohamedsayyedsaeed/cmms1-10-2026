import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_icons.dart';
import '../core/theme/context_ext.dart';
import '../data/mock_data.dart';
import '../data/models.dart';
import '../widgets/app_badge.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/app_text_field.dart';
import '../widgets/layout.dart';

/// SparePartsPage.tsx.
class SparePartsPage extends StatelessWidget {
  const SparePartsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageList(
      safeTop: true,
      children: <Widget>[
        PageTitle(context.t('spareParts')),
        AppTextField(hint: context.t('search'), icon: AppIcons.search),
        Column(
          children: spaced(mockSpareParts.map((SparePart part) {
            return AppCard(
              borderColor: context.borderColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.op(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(AppIcons.package, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
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
                                  Text(
                                    part.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: context.textPrimary,
                                    ),
                                  ),
                                  Text(part.partNumber, style: TextStyle(fontSize: 12, color: context.textSecondary)),
                                ],
                              ),
                            ),
                            AppBadge(part.status.label, variant: _statusVariant(part.status), small: true),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.only(top: 12),
                          decoration: BoxDecoration(border: Border(top: BorderSide(color: context.borderColor))),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Stock: ${part.stockLevel} / Min: ${part.minStock}',
                                      style: TextStyle(fontSize: 12, color: context.textSecondary),
                                    ),
                                    Text(part.location, style: TextStyle(fontSize: 12, color: context.textSecondary)),
                                  ],
                                ),
                              ),
                              AppButton(label: context.t('issue'), variant: ButtonVariant.outline, size: ButtonSize.sm, onPressed: () {}),
                              const SizedBox(width: 8),
                              AppButton(label: context.t('return'), variant: ButtonVariant.secondary, size: ButtonSize.sm, onPressed: () {}),
                            ],
                          ),
                        ),
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

  static BadgeVariant _statusVariant(StockStatus s) {
    switch (s) {
      case StockStatus.outOfStock:
        return BadgeVariant.danger;
      case StockStatus.lowStock:
        return BadgeVariant.warning;
      case StockStatus.inStock:
        return BadgeVariant.success;
    }
  }
}
