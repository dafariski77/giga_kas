import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/cash_flow_chart.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/status_badge.dart';
import '../../finance/application/finance_provider.dart';
import '../../finance/domain/finance_models.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(financeProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('GigaKas'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xs),
            child: StatusBadge(
              label: 'Offline Ready',
              showDot: true,
              foregroundColor: colorScheme.primary,
              backgroundColor:
                  colorScheme.primaryContainer.withValues(alpha: 0.7),
            ),
          ),
          IconButton(
            tooltip: 'Pengaturan',
            onPressed: () => context.push(AppRoutes.settings),
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => ref.read(financeProvider.notifier).refreshAll(),
              child: ListView(
                padding: AppSpacing.screenPadding,
                children: [
                  _BalanceSummaryCard(
                    state: state,
                    onQuickRecord: () => _showQuickRecordSheet(context, ref),
                    onScanReceipt: () => context.go(AppRoutes.scanner),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _LeanMonthBanner(
                    state: state,
                    onRecordIncome: () => _showQuickRecordSheet(context, ref),
                    onLockRecommended: () async {
                      final rec = state.recommendedEmergencyPercent;
                      await ref
                          .read(financeProvider.notifier)
                          .lockRecommendedToEmergencyVault();
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Alokasi Dana Darurat diperbarui ke $rec% & disimpan ke brankas lokal.',
                          ),
                        ),
                      );
                    },
                    onOpenVault: () => context.go(AppRoutes.vault),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Card(
                    child: Padding(
                      padding: AppSpacing.cardPadding,
                      child: CashFlowChart(points: state.monthlyHistory),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SectionHeader(
                    title: 'Aktivitas Terakhir',
                    actionLabel: '+ Catat Kas',
                    onActionTap: () => _showQuickRecordSheet(context, ref),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (state.transactions.isEmpty)
                    Card(
                      child: Padding(
                        padding: AppSpacing.cardPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Belum ada transaksi tercatat',
                              style: textTheme.titleSmall,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Mulai catat pemasukan dari klien atau pindai struk pengeluaran bisnis pertamamu.',
                              style: textTheme.bodySmall,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            FilledButton.icon(
                              onPressed: () =>
                                  _showQuickRecordSheet(context, ref),
                              icon: const Icon(Icons.add_rounded, size: 18),
                              label: const Text('Catat Transaksi Pertama'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Card(
                      child: Column(
                        children: [
                          for (var i = 0;
                              i < state.transactions.take(8).length;
                              i++) ...[
                            _TransactionRow(item: state.transactions[i]),
                            if (i < state.transactions.take(8).length - 1)
                              const Divider(),
                          ],
                        ],
                      ),
                    ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
    );
  }

  Future<void> _showQuickRecordSheet(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final financeState = ref.read(financeProvider);
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    var selectedType = TransactionType.income;
    var selectedCategory = ExpenseCategory.internetSoftware;
    var selectedTaxScheme = financeState.taxScheme;
    var parsedAmount = 0;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final textTheme = Theme.of(context).textTheme;
            final colorScheme = Theme.of(context).colorScheme;
            final taxSplit = (parsedAmount * selectedTaxScheme.rate).round();
            final emergencySplit = (parsedAmount *
                    (financeState.emergencyLockedPercent / 100.0))
                .round();
            final spendableSplit = (parsedAmount - taxSplit - emergencySplit)
                .clamp(0, parsedAmount);

            return Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                top: AppSpacing.xl,
                bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Catat Transaksi', style: textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.md),
                    SegmentedButton<TransactionType>(
                      segments: const [
                        ButtonSegment(
                          value: TransactionType.income,
                          label: Text('Pemasukan'),
                        ),
                        ButtonSegment(
                          value: TransactionType.expense,
                          label: Text('Pengeluaran'),
                        ),
                      ],
                      selected: {selectedType},
                      onSelectionChanged: (value) {
                        setModalState(() => selectedType = value.first);
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: selectedType == TransactionType.income
                            ? 'Nama Klien / Sumber'
                            : 'Merchant / Keperluan',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final n = int.tryParse(
                              value.replaceAll(RegExp(r'[^0-9]'), ''),
                            ) ??
                            0;
                        setModalState(() => parsedAmount = n);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Nominal (Rp)',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (selectedType == TransactionType.income) ...[
                      Text(
                        'Skema Pemisahan Pajak (Tax Vault)',
                        style: textTheme.labelMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
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
                        selected: {selectedTaxScheme},
                        onSelectionChanged: (value) {
                          setModalState(() => selectedTaxScheme = value.first);
                        },
                      ),
                      if (parsedAmount > 0) ...[
                        const SizedBox(height: AppSpacing.md),
                        Container(
                          padding: AppSpacing.compactPadding,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainer,
                            borderRadius: AppRadius.borderSm,
                          ),
                          child: Column(
                            children: [
                              _SplitPreviewRow(
                                label: 'Tax Vault (${selectedTaxScheme.label})',
                                value: CurrencyFormatter.formatIdr(taxSplit),
                                valueColor: colorScheme.tertiary,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              _SplitPreviewRow(
                                label:
                                    'Dana Darurat (${financeState.emergencyLockedPercent}%)',
                                value:
                                    CurrencyFormatter.formatIdr(emergencySplit),
                                valueColor: AppColors.warning,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              _SplitPreviewRow(
                                label: 'Dana Siap Pakai',
                                value:
                                    CurrencyFormatter.formatIdr(spendableSplit),
                                valueColor: colorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ] else ...[
                      DropdownButtonFormField<ExpenseCategory>(
                        initialValue: selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Kategori Pengeluaran',
                        ),
                        items: ExpenseCategory.expenseOnly
                            .map(
                              (cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(cat.label),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setModalState(() => selectedCategory = value);
                          }
                        },
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () async {
                          final rawTitle = titleController.text.trim();
                          final amount = int.tryParse(
                            amountController.text
                                .replaceAll(RegExp(r'[^0-9]'), ''),
                          );
                          if (rawTitle.isEmpty ||
                              amount == null ||
                              amount <= 0) {
                            return;
                          }
                          final notifier = ref.read(financeProvider.notifier);
                          if (selectedType == TransactionType.income) {
                            notifier.setTaxScheme(selectedTaxScheme);
                          }
                          await notifier.addTransaction(
                            title: rawTitle,
                            subtitle: selectedType == TransactionType.income
                                ? 'Pemasukan tercatat'
                                : selectedCategory.label,
                            amount: amount,
                            type: selectedType,
                            category: selectedType == TransactionType.income
                                ? ExpenseCategory.clientPayment
                                : selectedCategory,
                            isDeductibleBusinessExpense:
                                selectedType == TransactionType.expense,
                            customTaxRate: selectedTaxScheme.rate,
                          );
                          if (sheetContext.mounted) {
                            Navigator.of(sheetContext).pop();
                          }
                        },
                        child: const Text('Simpan Transaksi'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SplitPreviewRow extends StatelessWidget {
  const _SplitPreviewRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text(label, style: textTheme.bodySmall)),
        const SizedBox(width: AppSpacing.sm),
        Text(
          value,
          style: textTheme.labelLarge?.copyWith(
            color: valueColor,
            fontSize: 12,
            fontFeatures: AppTypography.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _BalanceSummaryCard extends StatelessWidget {
  const _BalanceSummaryCard({
    required this.state,
    required this.onQuickRecord,
    required this.onScanReceipt,
  });

  final FinanceState state;
  final VoidCallback onQuickRecord;
  final VoidCallback onScanReceipt;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hasPositiveNet = state.netBalance > 0;

    final total = hasPositiveNet ? state.netBalance : 1;
    final spendFlex =
        ((state.spendableCash / total) * 100).round().clamp(1, 100);
    final taxFlex =
        ((state.taxVaultAmount / total) * 100).round().clamp(1, 100);
    final emergencyFlex =
        ((state.emergencyVaultAmount / total) * 100).round().clamp(1, 100);

    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('DANA SIAP PAKAI', style: textTheme.labelSmall),
                Text(
                  'Kas Bersih ${CurrencyFormatter.formatCompactIdr(state.netBalance)}',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              CurrencyFormatter.formatIdr(state.spendableCash),
              style: textTheme.displaySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            ClipRRect(
              borderRadius: AppRadius.borderFull,
              child: SizedBox(
                height: 8,
                child: hasPositiveNet
                    ? Row(
                        children: [
                          Expanded(
                            flex: spendFlex,
                            child: Container(color: colorScheme.primary),
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            flex: taxFlex,
                            child: Container(color: colorScheme.tertiary),
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            flex: emergencyFlex,
                            child: Container(color: AppColors.warning),
                          ),
                        ],
                      )
                    : Container(color: colorScheme.surfaceContainer),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _AllocationMetric(
                    dotColor: colorScheme.primary,
                    label: 'Dana Bebas',
                    value:
                        CurrencyFormatter.formatCompactIdr(state.spendableCash),
                  ),
                ),
                Expanded(
                  child: _AllocationMetric(
                    dotColor: colorScheme.tertiary,
                    label: 'Tax Vault',
                    value: CurrencyFormatter.formatCompactIdr(
                      state.taxVaultAmount,
                    ),
                  ),
                ),
                Expanded(
                  child: _AllocationMetric(
                    dotColor: AppColors.warning,
                    label: 'Dana Darurat',
                    value: CurrencyFormatter.formatCompactIdr(
                      state.emergencyVaultAmount,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onQuickRecord,
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Catat Kas'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onScanReceipt,
                    icon: const Icon(Icons.document_scanner_outlined, size: 18),
                    label: const Text('Scan Struk'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AllocationMetric extends StatelessWidget {
  const _AllocationMetric({
    required this.dotColor,
    required this.label,
    required this.value,
  });

  final Color dotColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 7,
              height: 7,
              decoration:
                  BoxDecoration(color: dotColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(label, style: textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          value,
          style: textTheme.titleSmall?.copyWith(
            fontFeatures: AppTypography.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _LeanMonthBanner extends StatelessWidget {
  const _LeanMonthBanner({
    required this.state,
    required this.onRecordIncome,
    required this.onLockRecommended,
    required this.onOpenVault,
  });

  final FinanceState state;
  final VoidCallback onRecordIncome;
  final VoidCallback onLockRecommended;
  final VoidCallback onOpenVault;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final forecast = state.incomeForecast;

    if (forecast == null) {
      return Card(
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('AI Prediktor Bulan Sepi', style: textTheme.titleSmall),
                  StatusBadge(
                    label: state.onnxReady ? 'ONNX Siap' : 'Siap Dipakai',
                    foregroundColor: colorScheme.primary,
                    backgroundColor:
                        colorScheme.primaryContainer.withValues(alpha: 0.7),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Catat pemasukan pertamamu agar model AI menghitung proyeksi arus kas bulan depan dan rekomendasi alokasi Dana Darurat.',
                style: textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton.icon(
                onPressed: onRecordIncome,
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Catat Pemasukan'),
              ),
            ],
          ),
        ),
      );
    }

    final isLeanRisk = forecast.isLeanMonthRisk;
    final nextMonth = forecast.nextMonthLabel;
    final predictedText = CurrencyFormatter.formatIdr(forecast.predictedAmount);
    final recPercent = state.recommendedEmergencyPercent;
    final recAmount = forecast.recommendedLockAmount;
    final needsIncrease = state.emergencyLockedPercent < recPercent;

    return Card(
      color: isLeanRisk
          ? AppColors.warning.withValues(alpha: 0.06)
          : colorScheme.primaryContainer.withValues(alpha: 0.35),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        isLeanRisk
                            ? Icons.trending_down_rounded
                            : Icons.verified_outlined,
                        size: 18,
                        color: isLeanRisk
                            ? AppColors.warning
                            : colorScheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Flexible(
                        child: Text(
                          isLeanRisk
                              ? 'Status Cash Flow $nextMonth: Waspada'
                              : 'Status Cash Flow $nextMonth: Stabil',
                          style: textTheme.titleSmall,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadge(
                  label: forecast.usedOnnxModel ? 'ONNX Offline' : 'Estimasi AI',
                  foregroundColor: colorScheme.primary,
                  backgroundColor:
                      colorScheme.primaryContainer.withValues(alpha: 0.7),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Proyeksi pemasukan $nextMonth: $predictedText. '
              'Saran kunci $recPercent% (${CurrencyFormatter.formatCompactIdr(recAmount)}) ke Kantong Dana Darurat.',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            if (forecast.usedColdStartFallback) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Mode Cold-Start aktif: menggunakan rata-rata riwayat awal hingga genap 3 bulan.',
                style: textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                if (needsIncrease || isLeanRisk) ...[
                  FilledButton(
                    onPressed: onLockRecommended,
                    child: Text('Kunci $recPercent%'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                OutlinedButton(
                  onPressed: onOpenVault,
                  child: const Text('Lihat Brankas'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.item});

  final TransactionItem item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isIncome = item.type == TransactionType.income;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: AppRadius.borderSm,
            ),
            child: Icon(
              isIncome ? Icons.south_west_rounded : Icons.north_east_rounded,
              size: 18,
              color:
                  isIncome ? colorScheme.primary : colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${item.category.label} · ${CurrencyFormatter.formatShortDate(item.date)}',
                  style: textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyFormatter.formatIdr(
                  isIncome ? item.amount : -item.amount,
                  showSign: isIncome,
                ),
                style: textTheme.titleSmall?.copyWith(
                  color: isIncome ? colorScheme.primary : colorScheme.onSurface,
                  fontFeatures: AppTypography.tabularFigures,
                ),
              ),
              if (item.isDeductibleBusinessExpense)
                Text(
                  'Biaya Bisnis',
                  style: textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                    letterSpacing: 0.2,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
