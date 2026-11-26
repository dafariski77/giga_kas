import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/theme/theme_mode_provider.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/status_badge.dart';
import '../../finance/application/finance_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final finance = ref.watch(financeProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          Card(
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              finance.isProMember
                                  ? 'GigaKas Pro Aktif'
                                  : 'Paket Freemium',
                              style: textTheme.titleMedium,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            StatusBadge(
                              label: finance.isProMember ? 'PRO' : 'GRATIS',
                              foregroundColor: colorScheme.primary,
                              backgroundColor: colorScheme.primaryContainer
                                  .withValues(alpha: 0.7),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          finance.isProMember
                              ? 'Unlimited scan struk AI & prediksi bulan sepi aktif.'
                              : 'Upgrade untuk scan struk tanpa batas & prediksi AI.',
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (!finance.isProMember) ...[
                    const SizedBox(width: AppSpacing.md),
                    FilledButton(
                      onPressed: () => context.push(AppRoutes.pro),
                      child: const Text('Upgrade'),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Engine AI & Penyimpanan Lokal'),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Column(
              children: [
                ListTile(
                  title:
                      Text('ONNX Runtime Offline', style: textTheme.titleSmall),
                  subtitle: Text(
                    'Model klasifikasi struk & proyeksi arus kas di perangkat',
                    style: textTheme.bodySmall,
                  ),
                  trailing: StatusBadge(
                    label: finance.onnxReady ? 'Aktif' : 'Standby',
                    showDot: true,
                    foregroundColor: finance.onnxReady
                        ? colorScheme.primary
                        : AppColors.warning,
                    backgroundColor: (finance.onnxReady
                            ? colorScheme.primaryContainer
                            : AppColors.warning.withValues(alpha: 0.14))
                        .withValues(alpha: 0.7),
                  ),
                ),
                const Divider(),
                ListTile(
                  title:
                      Text('Database SQLite Lokal', style: textTheme.titleSmall),
                  subtitle: Text(
                    '${finance.transactions.length} transaksi · ${finance.invoices.length} invoice · ${finance.merchantOverrides.length} koreksi AI',
                    style: textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Keamanan & Data'),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: Text('Kunci Biometrik', style: textTheme.titleSmall),
                  subtitle: Text(
                    'Wajibkan FaceID / Sidik Jari saat membuka aplikasi',
                    style: textTheme.bodySmall,
                  ),
                  value: finance.biometricEnabled,
                  onChanged: (v) =>
                      ref.read(financeProvider.notifier).toggleBiometric(v),
                ),
                const Divider(),
                ListTile(
                  title: Text('Kunci Aplikasi', style: textTheme.titleSmall),
                  subtitle: Text(
                    'Kembali ke layar autentikasi biometrik',
                    style: textTheme.bodySmall,
                  ),
                  trailing: const Icon(Icons.lock_outline_rounded, size: 20),
                  onTap: () => context.go(AppRoutes.auth),
                ),
                const Divider(),
                ListTile(
                  title: Text(
                    'Hapus Semua Data Lokal',
                    style:
                        textTheme.titleSmall?.copyWith(color: AppColors.error),
                  ),
                  subtitle: Text(
                    'Bersihkan transaksi, invoice, brankas & memori AI',
                    style: textTheme.bodySmall,
                  ),
                  trailing: const Icon(
                    Icons.delete_outline_rounded,
                    size: 20,
                    color: AppColors.error,
                  ),
                  onTap: () => _confirmClearData(context, ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Tampilan'),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text('Sistem'),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text('Terang'),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text('Gelap'),
                  ),
                ],
                selected: {themeMode},
                onSelectionChanged: (selection) {
                  ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(selection.first);
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Future<void> _confirmClearData(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Semua Data Lokal?'),
        content: const Text(
          'Seluruh transaksi, invoice, saldo brankas, dan memori koreksi kategori di perangkat ini akan dihapus permanen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(financeProvider.notifier).clearAllLocalData();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Semua data lokal telah dibersihkan.')),
        );
      }
    }
  }
}
