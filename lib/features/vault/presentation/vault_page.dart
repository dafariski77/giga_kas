import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/status_badge.dart';
import '../../finance/application/finance_provider.dart';
import '../../finance/domain/finance_models.dart';

class VaultPage extends ConsumerWidget {
  const VaultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(financeProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final emergencyProgress = (state.emergencyVaultAmount /
            (state.emergencyTargetAmount > 0 ? state.emergencyTargetAmount : 1))
        .clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(title: const Text('Tax Vault & Dana Darurat')),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          const SectionHeader(title: 'Tax Vault Otomatis'),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Estimasi PPh Disisihkan', style: textTheme.bodySmall),
                      StatusBadge(
                        label: state.taxScheme == TaxScheme.pphFinal
                            ? 'Tarif 0,5%'
                            : 'Norma 50%',
                        foregroundColor: colorScheme.tertiary,
                        backgroundColor:
                            colorScheme.tertiaryContainer.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    CurrencyFormatter.formatIdr(state.taxVaultAmount),
                    style: textTheme.displaySmall,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SegmentedButton<TaxScheme>(
                    segments: const [
                      ButtonSegment(
                        value: TaxScheme.pphFinal,
                        label: Text('PPh Final 0,5%'),
                      ),
                      ButtonSegment(
                        value: TaxScheme.pph21Norma,
                        label: Text('PPh 21 Norma'),
                      ),
                    ],
                    selected: {state.taxScheme},
                    onSelectionChanged: (selection) {
                      ref
                          .read(financeProvider.notifier)
                          .setTaxScheme(selection.first);
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Divider(),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Pemasukan Tercatat', style: textTheme.bodySmall),
                      Text(
                        CurrencyFormatter.formatIdr(state.totalIncome),
                        style: textTheme.titleSmall?.copyWith(
                          fontFeatures: AppTypography.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Biaya Bisnis Terdeteksi', style: textTheme.bodySmall),
                      Text(
                        CurrencyFormatter.formatIdr(state.deductibleExpenses),
                        style: textTheme.titleSmall?.copyWith(
                          color: colorScheme.primary,
                          fontFeatures: AppTypography.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Kantong Dana Darurat (Lean Month)'),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Dana Terkunci Saat Ini', style: textTheme.bodySmall),
                      Text(
                        'Target ${CurrencyFormatter.formatCompactIdr(state.emergencyTargetAmount)}',
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    CurrencyFormatter.formatIdr(state.emergencyVaultAmount),
                    style: textTheme.displaySmall,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ClipRRect(
                    borderRadius: AppRadius.borderFull,
                    child: LinearProgressIndicator(
                      value: emergencyProgress,
                      minHeight: 8,
                      backgroundColor: colorScheme.surfaceContainer,
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Persentase Kunci Otomatis',
                        style: textTheme.titleSmall,
                      ),
                      Text(
                        '${state.emergencyLockedPercent}%',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                          fontFeatures: AppTypography.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: state.emergencyLockedPercent.toDouble(),
                    min: 5,
                    max: 40,
                    divisions: 7,
                    label: '${state.emergencyLockedPercent}%',
                    onChanged: (value) {
                      ref
                          .read(financeProvider.notifier)
                          .setEmergencyPercent(value.round());
                    },
                  ),
                  Text(
                    'Saran AI berdasarkan riwayat 6 bulan: ${state.recommendedEmergencyPercent}% untuk 3 bulan cadangan biaya pokok.',
                    style: textTheme.bodySmall,
                  ),
                  if (!state.isProMember) ...[
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => context.push(AppRoutes.pro),
                        child: const Text('Buka Prediktor AI Lanjutan di Pro'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
