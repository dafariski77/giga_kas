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

class ScannerPage extends ConsumerStatefulWidget {
  const ScannerPage({super.key});

  @override
  ConsumerState<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends ConsumerState<ScannerPage> {
  final _merchantController = TextEditingController(text: 'Kopi Kenangan');
  final _amountController = TextEditingController(text: '85000');
  ExpenseCategory _selectedCategory = ExpenseCategory.clientMeeting;
  bool _isDeductible = true;
  String _selectedSample = 'Struk Meeting Klien';

  @override
  void dispose() {
    _merchantController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _applySample({
    required String label,
    required String merchant,
    required int amount,
    required ExpenseCategory category,
  }) {
    setState(() {
      _selectedSample = label;
      _merchantController.text = merchant;
      _amountController.text = amount.toString();
      _selectedCategory = category;
      _isDeductible = true;
    });
  }

  void _saveScannedReceipt() {
    final state = ref.read(financeProvider);
    if (!state.isProMember && state.freeScansRemaining <= 0) {
      context.push(AppRoutes.pro);
      return;
    }

    final merchant = _merchantController.text.trim();
    final amount = int.tryParse(
      _amountController.text.replaceAll(RegExp(r'[^0-9]'), ''),
    );
    if (merchant.isEmpty || amount == null || amount <= 0) return;

    ref.read(financeProvider.notifier).addTransaction(
          title: merchant,
          subtitle: 'Scan Struk · ${_selectedCategory.label}',
          amount: amount,
          type: TransactionType.expense,
          category: _selectedCategory,
          isDeductibleBusinessExpense: _isDeductible,
          consumeFreeScan: true,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$merchant (${CurrencyFormatter.formatIdr(amount)}) dicatat ke pengeluaran.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(financeProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Receipt Scanner'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            child: StatusBadge(
              label: state.isProMember
                  ? 'Pro Unlimited'
                  : '${state.freeScansRemaining} scan gratis',
              foregroundColor: colorScheme.primary,
              backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          Container(
            height: 170,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: AppRadius.borderMd,
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.center_focus_weak_rounded,
                  size: 40,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Arahkan kamera ke struk fisik',
                  style: textTheme.titleSmall,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'AI OCR mengekstrak nominal, tanggal & kategori pajak',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader(title: 'Contoh Hasil Ekstraksi AI'),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              ChoiceChip(
                label: const Text('Struk Meeting Klien'),
                selected: _selectedSample == 'Struk Meeting Klien',
                onSelected: (_) => _applySample(
                  label: 'Struk Meeting Klien',
                  merchant: 'Kopi Kenangan',
                  amount: 85000,
                  category: ExpenseCategory.clientMeeting,
                ),
              ),
              ChoiceChip(
                label: const Text('Kuota Internet'),
                selected: _selectedSample == 'Kuota Internet',
                onSelected: (_) => _applySample(
                  label: 'Kuota Internet',
                  merchant: 'Telkomsel Halo',
                  amount: 165000,
                  category: ExpenseCategory.connectivity,
                ),
              ),
              ChoiceChip(
                label: const Text('Software Kerja'),
                selected: _selectedSample == 'Software Kerja',
                onSelected: (_) => _applySample(
                  label: 'Software Kerja',
                  merchant: 'Adobe Creative Cloud',
                  amount: 320000,
                  category: ExpenseCategory.connectivity,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Card(
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Detail Terdeteksi', style: textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _merchantController,
                    decoration: const InputDecoration(
                      labelText: 'Merchant / Toko',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Nominal (Rp)',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<ExpenseCategory>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Kategori Pengeluaran',
                    ),
                    items: ExpenseCategory.values
                        .where((c) => c != ExpenseCategory.clientPayment)
                        .map(
                          (cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat.label),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedCategory = value);
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Tandai sebagai Biaya Bisnis',
                      style: textTheme.titleSmall,
                    ),
                    subtitle: Text(
                      'Dapat menjadi pengurang beban pajak operasional',
                      style: textTheme.bodySmall,
                    ),
                    value: _isDeductible,
                    onChanged: (value) => setState(() => _isDeductible = value),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _saveScannedReceipt,
                      icon: const Icon(Icons.check_rounded, size: 18),
                      label: const Text('Simpan Pengeluaran'),
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
