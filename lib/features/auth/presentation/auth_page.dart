import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/theme.dart';
import '../../finance/application/finance_provider.dart';

class AuthPage extends ConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final biometricEnabled = ref.watch(financeProvider).biometricEnabled;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: AppRadius.borderSm,
                ),
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: colorScheme.onPrimary,
                  size: 22,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Keuangan terstruktur untuk pekerja lepas.',
                style: textTheme.displaySmall,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Pisahkan dana pajak, siapkan cadangan bulan sepi, dan catat struk bisnis dalam hitungan detik.',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              if (biometricEnabled) ...[
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => context.go(AppRoutes.home),
                    icon: const Icon(Icons.fingerprint_rounded, size: 20),
                    label: const Text('Buka dengan FaceID / Sidik Jari'),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.go(AppRoutes.home),
                  icon: const Icon(Icons.g_mobiledata_rounded, size: 24),
                  label: const Text('Masuk dengan Google'),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.go(AppRoutes.home),
                  icon: const Icon(Icons.apple_rounded, size: 20),
                  label: const Text('Masuk dengan Apple'),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: Text(
                  'Data terenkripsi lokal · Tetap berfungsi saat offline',
                  style: textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
