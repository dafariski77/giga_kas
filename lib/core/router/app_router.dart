import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../features/auth/presentation/auth_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/invoices/presentation/create_invoice_page.dart';
import '../../features/invoices/presentation/invoices_page.dart';
import '../../features/scanner/presentation/scanner_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/subscription/presentation/pro_paywall_page.dart';
import '../../features/vault/presentation/vault_page.dart';
import '../widgets/app_shell.dart';

/// Named route paths used across the application.
abstract final class AppRoutes {
  static const String auth = '/auth';
  static const String home = '/';
  static const String scanner = '/scanner';
  static const String vault = '/vault';
  static const String invoices = '/invoices';
  static const String createInvoice = '/invoices/new';
  static const String settings = '/settings';
  static const String pro = '/pro';
}

/// Provides the application's [GoRouter] configuration.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.auth,
        name: 'auth',
        builder: (context, state) => const AuthPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: 'home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.scanner,
                name: 'scanner',
                builder: (context, state) => const ScannerPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.vault,
                name: 'vault',
                builder: (context, state) => const VaultPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.invoices,
                name: 'invoices',
                builder: (context, state) => const InvoicesPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.createInvoice,
        name: 'createInvoice',
        builder: (context, state) => const CreateInvoicePage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.pro,
        name: 'pro',
        builder: (context, state) => const ProPaywallPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Halaman Tidak Ditemukan')),
      body: Center(
        child: Text(
          state.error?.toString() ?? 'Rute tidak ditemukan: ${state.uri}',
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
});
