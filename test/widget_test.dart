import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:giga_kas/app.dart';
import 'package:giga_kas/core/theme/theme.dart';
import 'package:giga_kas/core/utils/currency_formatter.dart';

void main() {
  testWidgets('Navigates across GigaKas core MVP tabs and settings', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: GigaKasApp()));
    await tester.pumpAndSettle();

    // Home screen renders cash flow summary and AI Lean Month banner
    expect(find.text('GigaKas'), findsOneWidget);
    expect(find.text('DANA SIAP PAKAI'), findsOneWidget);
    expect(find.text('Prediksi Bulan Sepi: Desember'), findsOneWidget);

    // Navigate to Scan tab
    await tester.tap(find.text('Scan'));
    await tester.pumpAndSettle();
    expect(find.text('Smart Receipt Scanner'), findsOneWidget);
    expect(find.text('Simpan Pengeluaran'), findsOneWidget);

    // Navigate to Brankas tab (Tax Vault & Dana Darurat)
    await tester.tap(find.text('Brankas'));
    await tester.pumpAndSettle();
    expect(find.text('Tax Vault & Dana Darurat'), findsOneWidget);
    expect(find.text('PPh Final 0,5%'), findsOneWidget);

    // Navigate to Invoice tab
    await tester.tap(find.text('Invoice'));
    await tester.pumpAndSettle();
    expect(find.text('Invoice & Tagihan'), findsOneWidget);
    expect(find.text('Sinar Media Kreatif'), findsOneWidget);

    // Return to Beranda and open Settings
    await tester.tap(find.text('Beranda'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.tune_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Pengaturan'), findsOneWidget);
    expect(find.text('Kunci Biometrik'), findsOneWidget);
  });

  test('CurrencyFormatter formats IDR cleanly', () {
    expect(CurrencyFormatter.formatIdr(14500000), 'Rp 14.500.000');
    expect(CurrencyFormatter.formatCompactIdr(8900000), 'Rp 8.9jt');
    expect(AppSpacing.lg, 16);
    expect(AppRadius.md, 12);
  });
}
