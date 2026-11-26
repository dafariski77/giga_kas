import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/receipt_pipeline_service.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/status_badge.dart';
import '../../finance/application/finance_provider.dart';
import '../../finance/domain/finance_models.dart';

class ScannerPage extends ConsumerStatefulWidget {
  const ScannerPage({super.key});

  @override
  ConsumerState<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends ConsumerState<ScannerPage> {
  final _picker = ImagePicker();
  final _merchantController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime _receiptDate = DateTime.now();
  ExpenseCategory _selectedCategory = ExpenseCategory.internetSoftware;
  String? _aiSuggestedCategory;
  double? _confidence;
  ClassificationSource? _source;
  double? _inferenceMs;
  String _rawOcrText = '';
  String? _processedImagePath;
  bool _isDeductible = true;
  bool _isScanning = false;
  bool _showRawOcr = false;
  String? _scanError;

  @override
  void dispose() {
    _merchantController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _scanFromSource(ImageSource source) async {
    final state = ref.read(financeProvider);
    if (!state.isProMember && state.freeScansRemaining <= 0) {
      context.push(AppRoutes.pro);
      return;
    }

    setState(() {
      _isScanning = true;
      _scanError = null;
    });

    try {
      final picked = await _picker.pickImage(source: source);
      if (picked == null) {
        if (mounted) setState(() => _isScanning = false);
        return;
      }

      final pipeline = ref.read(receiptPipelineProvider);
      final result = await pipeline.processImageFile(picked.path);
      if (!mounted) return;
      _applyScanResult(result);
    } catch (e) {
      if (mounted) {
        setState(() => _scanError = 'Gagal memindai struk: $e');
      }
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  void _applyScanResult(ReceiptScanResult result) {
    setState(() {
      _merchantController.text = result.merchantName;
      _amountController.text = result.amount?.toString() ?? '';
      _receiptDate = result.date;
      _selectedCategory = ExpenseCategory.fromLabel(result.categoryLabel);
      _aiSuggestedCategory = result.categoryLabel;
      _confidence = result.confidence;
      _source = result.source;
      _inferenceMs = result.inferenceMs;
      _rawOcrText = result.rawOcrText;
      _processedImagePath = result.processedImagePath;
      _isDeductible = true;
    });
  }

  void _resetForm() {
    setState(() {
      _merchantController.clear();
      _amountController.clear();
      _receiptDate = DateTime.now();
      _selectedCategory = ExpenseCategory.internetSoftware;
      _aiSuggestedCategory = null;
      _confidence = null;
      _source = null;
      _inferenceMs = null;
      _rawOcrText = '';
      _processedImagePath = null;
      _showRawOcr = false;
      _scanError = null;
    });
  }

  Future<void> _saveScannedReceipt() async {
    final state = ref.read(financeProvider);
    if (!state.isProMember && state.freeScansRemaining <= 0) {
      context.push(AppRoutes.pro);
      return;
    }

    final merchant = _merchantController.text.trim();
    final amount = int.tryParse(
      _amountController.text.replaceAll(RegExp(r'[^0-9]'), ''),
    );
    if (merchant.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lengkapi nama merchant dan nominal struk.'),
        ),
      );
      return;
    }

    final savedOverride =
        await ref.read(financeProvider.notifier).saveScannedReceipt(
              merchant: merchant,
              amount: amount,
              date: _receiptDate,
              selectedCategory: _selectedCategory,
              aiSuggestedCategory: _aiSuggestedCategory,
              isDeductible: _isDeductible,
              rawOcrText: _rawOcrText,
            );

    if (!mounted) return;
    _resetForm();
    final msg = savedOverride
        ? '$merchant disimpan (${CurrencyFormatter.formatIdr(amount)}). Koreksi kategori diingat otomatis.'
        : '$merchant (${CurrencyFormatter.formatIdr(amount)}) tersimpan ke database lokal.';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(financeProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final isUserCorrected = _aiSuggestedCategory != null &&
        _selectedCategory.label.toLowerCase() !=
            _aiSuggestedCategory!.toLowerCase();

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
              backgroundColor:
                  colorScheme.primaryContainer.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          Card(
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                children: [
                  if (_processedImagePath != null) ...[
                    ClipRRect(
                      borderRadius: AppRadius.borderSm,
                      child: Image.file(
                        File(_processedImagePath!),
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ] else ...[
                    Container(
                      height: 132,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLow,
                        borderRadius: AppRadius.borderSm,
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.center_focus_weak_rounded,
                            size: 34,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Foto struk untuk ekstraksi AI offline',
                            style: textTheme.titleSmall,
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            'Nominal, tanggal & kategori diisi otomatis',
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _isScanning
                              ? null
                              : () => _scanFromSource(ImageSource.camera),
                          icon: _isScanning
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.photo_camera_outlined,
                                  size: 18,
                                ),
                          label: Text(_isScanning ? 'Memindai...' : 'Kamera'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isScanning
                              ? null
                              : () => _scanFromSource(ImageSource.gallery),
                          icon: const Icon(
                            Icons.photo_library_outlined,
                            size: 18,
                          ),
                          label: const Text('Galeri'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (_scanError != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              _scanError!,
              style: textTheme.bodySmall?.copyWith(color: AppColors.error),
            ),
          ],

          const SizedBox(height: AppSpacing.lg),
          Card(
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Detail Struk', style: textTheme.titleMedium),
                      if (_source != null)
                        StatusBadge(
                          label: _source == ClassificationSource.userMemory
                              ? 'Memori Lokal'
                              : '${_source!.label}${_inferenceMs != null ? ' · ${_inferenceMs!.toStringAsFixed(1)} ms' : ''}',
                          foregroundColor:
                              _source == ClassificationSource.userMemory
                                  ? colorScheme.tertiary
                                  : colorScheme.primary,
                          backgroundColor:
                              (_source == ClassificationSource.userMemory
                                      ? colorScheme.tertiaryContainer
                                      : colorScheme.primaryContainer)
                                  .withValues(alpha: 0.7),
                        ),
                    ],
                  ),
                  if (_confidence != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tingkat Keyakinan Model',
                          style: textTheme.bodySmall,
                        ),
                        Text(
                          '${(_confidence! * 100).toStringAsFixed(1)}%',
                          style: textTheme.labelMedium?.copyWith(
                            fontFeatures: AppTypography.tabularFigures,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    ClipRRect(
                      borderRadius: AppRadius.borderFull,
                      child: LinearProgressIndicator(
                        value: _confidence!.clamp(0.0, 1.0),
                        minHeight: 5,
                        backgroundColor: colorScheme.surfaceContainer,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _merchantController,
                    decoration: const InputDecoration(
                      labelText: 'Merchant / Toko',
                      hintText: 'Terisi otomatis dari hasil scan struk',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Total (Rp)',
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          borderRadius: AppRadius.borderSm,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _receiptDate,
                              firstDate: DateTime(2024),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              setState(() => _receiptDate = picked);
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Tanggal',
                            ),
                            child: Text(
                              CurrencyFormatter.formatShortDate(_receiptDate),
                              style: textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<ExpenseCategory>(
                    key: ValueKey(_selectedCategory),
                    initialValue: _selectedCategory,
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
                        setState(() => _selectedCategory = value);
                      }
                    },
                  ),
                  if (isUserCorrected) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      padding: AppSpacing.compactPadding,
                      decoration: BoxDecoration(
                        color: colorScheme.tertiaryContainer
                            .withValues(alpha: 0.45),
                        borderRadius: AppRadius.borderSm,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.memory_rounded,
                            size: 16,
                            color: colorScheme.tertiary,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'Koreksi kategori akan diingat otomatis untuk "${_merchantController.text.trim()}".',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Tandai sebagai Biaya Bisnis',
                      style: textTheme.titleSmall,
                    ),
                    subtitle: Text(
                      'Masuk rekap pengurang beban pajak operasional',
                      style: textTheme.bodySmall,
                    ),
                    value: _isDeductible,
                    onChanged: (value) => setState(() => _isDeductible = value),
                  ),
                  if (_rawOcrText.isNotEmpty) ...[
                    TextButton(
                      onPressed: () =>
                          setState(() => _showRawOcr = !_showRawOcr),
                      child: Text(
                        _showRawOcr
                            ? 'Sembunyikan Teks OCR'
                            : 'Lihat Teks OCR',
                      ),
                    ),
                    if (_showRawOcr)
                      Container(
                        width: double.infinity,
                        padding: AppSpacing.compactPadding,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainer,
                          borderRadius: AppRadius.borderSm,
                        ),
                        child: Text(_rawOcrText, style: textTheme.bodySmall),
                      ),
                  ],
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
