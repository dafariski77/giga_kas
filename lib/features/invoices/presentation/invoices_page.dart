import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/router/app_router.dart';
import '../../../core/services/invoice_pdf_service.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/status_badge.dart';
import '../../finance/application/finance_provider.dart';
import '../../finance/domain/finance_models.dart';

class InvoicesPage extends ConsumerStatefulWidget {
  const InvoicesPage({super.key});

  @override
  ConsumerState<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends ConsumerState<InvoicesPage> {
  InvoiceStatus? _filter;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(financeProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final filtered = _filter == null
        ? state.invoices
        : state.invoices.where((inv) => inv.status == _filter).toList();

    final unpaidTotal = state.invoices
        .where((i) => i.status != InvoiceStatus.paid)
        .fold(0, (sum, i) => sum + i.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice & Tagihan'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: TextButton.icon(
              onPressed: () => context.push(AppRoutes.createInvoice),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Buat'),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('MENUNGGU PEMBAYARAN', style: textTheme.labelSmall),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        CurrencyFormatter.formatIdr(unpaidTotal),
                        style: textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  FilledButton(
                    onPressed: () => context.push(AppRoutes.createInvoice),
                    child: const Text('Invoice Baru'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Semua'),
                  selected: _filter == null,
                  onSelected: (_) => setState(() => _filter = null),
                ),
                const SizedBox(width: AppSpacing.sm),
                FilterChip(
                  label: const Text('Terlambat'),
                  selected: _filter == InvoiceStatus.overdue,
                  onSelected: (_) =>
                      setState(() => _filter = InvoiceStatus.overdue),
                ),
                const SizedBox(width: AppSpacing.sm),
                FilterChip(
                  label: const Text('Menunggu'),
                  selected: _filter == InvoiceStatus.pending,
                  onSelected: (_) =>
                      setState(() => _filter = InvoiceStatus.pending),
                ),
                const SizedBox(width: AppSpacing.sm),
                FilterChip(
                  label: const Text('Lunas'),
                  selected: _filter == InvoiceStatus.paid,
                  onSelected: (_) =>
                      setState(() => _filter = InvoiceStatus.paid),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          for (final invoice in filtered) ...[
            Card(
              child: InkWell(
                borderRadius: AppRadius.borderMd,
                onTap: () => _showInvoiceActions(context, invoice),
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            invoice.invoiceNumber,
                            style: textTheme.bodySmall,
                          ),
                          _InvoiceStatusBadge(status: invoice.status),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              invoice.clientName,
                              style: textTheme.titleMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.formatIdr(invoice.amount),
                            style: textTheme.titleMedium?.copyWith(
                              fontFeatures: AppTypography.tabularFigures,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${invoice.projectTitle} · Jatuh tempo ${CurrencyFormatter.formatShortDate(invoice.dueDate)}',
                        style: textTheme.bodySmall,
                      ),
                      if (invoice.status != InvoiceStatus.paid) ...[
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    _showInvoiceActions(context, invoice),
                                icon: const Icon(
                                  Icons.picture_as_pdf_outlined,
                                  size: 16,
                                ),
                                label: const Text('PDF & Pengingat'),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: FilledButton(
                                onPressed: () async {
                                  await ref
                                      .read(financeProvider.notifier)
                                      .markInvoicePaid(invoice);
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${invoice.invoiceNumber} lunas & otomatis masuk kas + Tax Vault.',
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Tandai Lunas'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          if (filtered.isEmpty)
            Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.invoices.isEmpty
                          ? 'Belum ada invoice dibuat'
                          : 'Tidak ada invoice pada filter ini',
                      style: textTheme.titleSmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      state.invoices.isEmpty
                          ? 'Buat tagihan PDF offline untuk klien dan kirim pengingat lewat WhatsApp atau Email.'
                          : 'Ubah filter untuk melihat daftar tagihan lainnya.',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (state.invoices.isEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      FilledButton.icon(
                        onPressed: () => context.push(AppRoutes.createInvoice),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Buat Invoice Pertama'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _showInvoiceActions(
    BuildContext context,
    InvoiceItem invoice,
  ) async {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${invoice.invoiceNumber} · ${invoice.clientName}',
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${invoice.projectTitle} (${CurrencyFormatter.formatIdr(invoice.amount)})',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.picture_as_pdf_outlined),
                title: const Text('Buat & Bagikan PDF Offline'),
                subtitle: const Text('Generate dokumen PDF langsung di HP'),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  try {
                    await InvoicePdfService.shareInvoicePdf(invoice);
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal membagikan PDF: $e')),
                    );
                  }
                },
              ),
              if (invoice.clientPhone.trim().isNotEmpty)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.chat_bubble_outline_rounded),
                  title: const Text('Kirim Pengingat WhatsApp'),
                  subtitle: Text('Tujuan: ${invoice.clientPhone}'),
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    final launched =
                        await InvoicePdfService.openWhatsAppReminder(invoice);
                    if (!launched && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'WhatsApp tidak tersedia untuk ${invoice.clientName}.',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.mail_outline_rounded),
                title: const Text('Kirim Pengingat Email'),
                subtitle: const Text('Buka aplikasi email dengan isi tagihan'),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  final launched =
                      await InvoicePdfService.openEmailReminder(invoice);
                  if (!launched && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Aplikasi email tidak ditemukan untuk ${invoice.clientName}.',
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        );
      },
    );
  }
}

class _InvoiceStatusBadge extends StatelessWidget {
  const _InvoiceStatusBadge({required this.status});

  final InvoiceStatus status;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (status) {
      InvoiceStatus.paid => StatusBadge(
          label: status.label,
          foregroundColor: colorScheme.primary,
          backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.7),
        ),
      InvoiceStatus.pending => StatusBadge(
          label: status.label,
          foregroundColor: colorScheme.secondary,
          backgroundColor: colorScheme.secondaryContainer,
        ),
      InvoiceStatus.overdue => StatusBadge(
          label: status.label,
          foregroundColor: AppColors.error,
          backgroundColor: AppColors.error.withValues(alpha: 0.12),
        ),
    };
  }
}
