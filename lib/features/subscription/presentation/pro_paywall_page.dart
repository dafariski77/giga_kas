import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/status_badge.dart';
import '../../finance/application/finance_provider.dart';

class ProPaywallPage extends ConsumerWidget {
  const ProPaywallPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPro = ref.watch(financeProvider).isProMember;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('GigaKas Pro')),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          StatusBadge(
            label: 'PAKET FREELANCER PRO',
            foregroundColor: colorScheme.primary,
            backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.7),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Kendali penuh arus kas & pajak tanpa batas.',
            style: textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Dirancang untuk pekerja lepas aktif yang membutuhkan otomasi AI setiap bulan.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Card(
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Rp 49.000', style: textTheme.displaySmall),
                      const SizedBox(width: AppSpacing.xs),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text('/ bulan', style: textTheme.bodySmall),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const _FeatureLine('Unlimited Smart Receipt Scanner (AI OCR)'),
                  const SizedBox(height: AppSpacing.sm),
                  const _FeatureLine('Prediksi Bulan Sepi & Rekomendasi Dana Darurat'),
                  const SizedBox(height: AppSpacing.sm),
                  const _FeatureLine('Laporan Estimasi PPh 21 & PPh Final Siap SPT'),
                  const SizedBox(height: AppSpacing.sm),
                  const _FeatureLine('Invoice PDF Kustom & Pengingat Otomatis'),
                  const SizedBox(height: AppSpacing.xl),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: isPro
                          ? null
                          : () {
                              ref
                                  .read(financeProvider.notifier)
                                  .activateProSubscription();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('GigaKas Pro berhasil diaktifkan.'),
                                ),
                              );
                              context.pop();
                            },
                      child: Text(
                        isPro
                            ? 'Paket Pro Sudah Aktif'
                            : 'Mulai Uji Coba 14 Hari Gratis',
                      ),
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

class _FeatureLine extends StatelessWidget {
  const _FeatureLine(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(Icons.check_rounded, size: 18, color: colorScheme.primary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(text, style: textTheme.bodyMedium)),
      ],
    );
  }
}
