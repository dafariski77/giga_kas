import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/theme.dart';
import '../../finance/application/finance_provider.dart';

class CreateInvoicePage extends ConsumerStatefulWidget {
  const CreateInvoicePage({super.key});

  @override
  ConsumerState<CreateInvoicePage> createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends ConsumerState<CreateInvoicePage> {
  final _clientController = TextEditingController();
  final _projectController = TextEditingController();
  final _amountController = TextEditingController();
  final _phoneController = TextEditingController(text: '+62 812-');
  int _dueDays = 7;

  @override
  void dispose() {
    _clientController.dispose();
    _projectController.dispose();
    _amountController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    final client = _clientController.text.trim();
    final project = _projectController.text.trim();
    final amount = int.tryParse(
      _amountController.text.replaceAll(RegExp(r'[^0-9]'), ''),
    );

    if (client.isEmpty || project.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi nama klien, proyek, dan nominal.')),
      );
      return;
    }

    ref.read(financeProvider.notifier).addInvoice(
          clientName: client,
          projectTitle: project,
          amount: amount,
          dueDate: DateTime(2026, 11, 26).add(Duration(days: _dueDays)),
          clientPhone: _phoneController.text.trim(),
        );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Buat Invoice')),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          Card(
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Informasi Tagihan', style: textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _clientController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Klien / Perusahaan',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _projectController,
                    decoration: const InputDecoration(
                      labelText: 'Judul Proyek / Jasa',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Nominal Tagihan (Rp)',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Nomor WhatsApp Klien',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Jatuh Tempo', style: textTheme.titleSmall),
                  const SizedBox(height: AppSpacing.sm),
                  SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(value: 7, label: Text('7 Hari')),
                      ButtonSegment(value: 14, label: Text('14 Hari')),
                      ButtonSegment(value: 30, label: Text('30 Hari')),
                    ],
                    selected: {_dueDays},
                    onSelectionChanged: (value) {
                      setState(() => _dueDays = value.first);
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _submit,
                      child: const Text('Terbitkan Invoice'),
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
