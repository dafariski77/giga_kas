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

    final hasTarget = state.emergencyTargetAmount > 0;
    final emergencyProgress = hasTarget
        ? (state.emergencyVaultAmount / state.emergencyTargetAmount)
            .clamp(0.0, 1.0)
        : 0.0;

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
                      Text('Estimasi PPh Disisihkan',
                          style: textTheme.bodySmall),
                      StatusBadge(
                        label: state.taxScheme == TaxScheme.pphFinal
                            ? 'Tarif 0,5%'
                            : 'Norma 50%',
                        foregroundColor: colorScheme.tertiary,
                        backgroundColor: colorScheme.tertiaryContainer
                            .withValues(alpha: 0.7),
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
                      Text('Total Pemasukan Tercatat',
                          style: textTheme.bodySmall),
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
                      Text('Biaya Bisnis Terdeteksi',
                          style: textTheme.bodySmall),
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
          SectionHeader(
            title: 'Kantong Dana Darurat (Lean Month)',
            actionLabel: 'Atur Target',
            onActionTap: () => _showTargetDialog(context, ref, state),
          ),
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
                      Text('Dana Terkunci Saat Ini',
                          style: textTheme.bodySmall),
                      Text(
                        hasTarget
                            ? 'Target ${CurrencyFormatter.formatCompactIdr(state.emergencyTargetAmount)}'
                            : 'Target belum diatur',
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
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _showDepositDialog(context, ref),
                        icon: const Icon(Icons.lock_outline_rounded, size: 16),
                        label: const Text('Kunci Dana'),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      TextButton(
                        onPressed: () => _showTargetDialog(context, ref, state),
                        child: Text(hasTarget ? 'Ubah Target' : 'Atur Target'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
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
                    state.incomeForecast != null
                        ? 'Saran AI berdasarkan riwayat pemasukan: ${state.recommendedEmergencyPercent}% untuk cadangan bulan sepi.'
                        : 'Persentase ini otomatis dialokasikan setiap kali pemasukan dicatat.',
                    style: textTheme.bodySmall,
                  ),
                  if (!state.isProMember) ...[
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => context.push(AppRoutes.pro),
                        child: const Text('Buka Fitur AI Lanjutan di Pro'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SectionHeader(
            title:
                'Memori Koreksi AI (${state.merchantOverrides.length} Merchant)',
          ),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: state.merchantOverrides.isEmpty
                ? Padding(
                    padding: AppSpacing.cardPadding,
                    child: Text(
                      'Belum ada koreksi kategori. Saat Anda mengubah kategori hasil scan struk, GigaKas menyimpannya di perangkat agar scan berikutnya lebih akurat.',
                      style: textTheme.bodySmall,
                    ),
                  )
                : Column(
                    children: [
                      for (var i = 0; i < state.merchantOverrides.length; i++) ...[
                        ListTile(
                          title: Text(
                            state.merchantOverrides[i].normalizedMerchant,
                            style: textTheme.titleSmall,
                          ),
                          subtitle: Text(
                            state.merchantOverrides[i].correctedCategory,
                            style: textTheme.bodySmall,
                          ),
                          trailing: IconButton(
                            tooltip: 'Hapus memori',
                            icon: const Icon(Icons.close_rounded, size: 18),
                            onPressed: () {
                              ref
                                  .read(financeProvider.notifier)
                                  .deleteMerchantOverride(
                                    state.merchantOverrides[i].id,
                                  );
                            },
                          ),
                        ),
                        if (i < state.merchantOverrides.length - 1)
                          const Divider(),
                      ],
                    ],
                  ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Future<void> _showTargetDialog(
    BuildContext context,
    WidgetRef ref,
    FinanceState state,
  ) async {
    final controller = TextEditingController(
      text: state.emergencyTargetAmount > 0
          ? state.emergencyTargetAmount.toString()
          : '',
    );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Target Dana Darurat'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Nominal Target (Rp)',
            hintText: 'Misal: 3 bulan biaya hidup',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              final value = int.tryParse(
                controller.text.replaceAll(RegExp(r'[^0-9]'), ''),
              );
              if (value != null && value >= 0) {
                await ref
                    .read(financeProvider.notifier)
                    .setEmergencyTargetAmount(value);
              }
              if (dialogContext.mounted) Navigator.of(dialogContext).pop();
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDepositDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Kunci Dana ke Brankas'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Nominal Tambahan (Rp)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              final value = int.tryParse(
                controller.text.replaceAll(RegExp(r'[^0-9]'), ''),
              );
              if (value != null && value > 0) {
                await ref
                    .read(financeProvider.notifier)
                    .depositToEmergencyVault(value);
              }
              if (dialogContext.mounted) Navigator.of(dialogContext).pop();
            },
            child: const Text('Kunci'),
          ),
        ],
      ),
    );
  }
}
