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
          const SectionHeader(title: 'Keamanan & Sinkronisasi'),
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
                SwitchListTile(
                  title: Text('Simulasi Mode Offline', style: textTheme.titleSmall),
                  subtitle: Text(
                    'Catat transaksi lokal lalu sinkronkan saat online',
                    style: textTheme.bodySmall,
                  ),
                  value: finance.isOfflineMode,
                  onChanged: (v) =>
                      ref.read(financeProvider.notifier).toggleOfflineMode(v),
                ),
                const Divider(),
                ListTile(
                  title: Text('Layar Login & Biometrik', style: textTheme.titleSmall),
                  subtitle: Text(
                    'Pratinjau gerbang autentikasi Google/Apple',
                    style: textTheme.bodySmall,
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.go(AppRoutes.auth),
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
        ],
      ),
    );
  }
}
