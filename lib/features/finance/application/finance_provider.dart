import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/finance_models.dart';

class FinanceNotifier extends Notifier<FinanceState> {
  @override
  FinanceState build() {
    final now = DateTime(2026, 11, 26);

    return FinanceState(
      taxScheme: TaxScheme.pphFinal,
      emergencyTargetAmount: 18000000,
      emergencyLockedPercent: 15,
      recommendedEmergencyPercent: 20,
      isOfflineMode: false,
      biometricEnabled: true,
      isProMember: false,
      freeScansRemaining: 4,
      monthlyHistory: const [
        MonthlyCashFlowPoint(monthLabel: 'Jul', income: 14500000, expense: 6200000),
        MonthlyCashFlowPoint(monthLabel: 'Agu', income: 18200000, expense: 7100000),
        MonthlyCashFlowPoint(monthLabel: 'Sep', income: 11800000, expense: 5800000),
        MonthlyCashFlowPoint(monthLabel: 'Okt', income: 16400000, expense: 6400000),
        MonthlyCashFlowPoint(monthLabel: 'Nov', income: 21500000, expense: 5350000),
        MonthlyCashFlowPoint(
          monthLabel: 'Des*',
          income: 8900000,
          expense: 6000000,
          isProjectedLean: true,
        ),
      ],
      transactions: [
        TransactionItem(
          id: 'tx-1',
          title: 'PT Aksara Digital',
          subtitle: 'Retainer UI/UX November',
          amount: 14500000,
          type: TransactionType.income,
          category: ExpenseCategory.clientPayment,
          date: now.subtract(const Duration(days: 1)),
        ),
        TransactionItem(
          id: 'tx-2',
          title: 'Studio Kopi Ruang',
          subtitle: 'Kopi meeting brief klien',
          amount: 145000,
          type: TransactionType.expense,
          category: ExpenseCategory.clientMeeting,
          date: now.subtract(const Duration(days: 2)),
          isDeductibleBusinessExpense: true,
        ),
        TransactionItem(
          id: 'tx-3',
          title: 'Biznet Home Dedicated',
          subtitle: 'Kuota & internet kerja',
          amount: 450000,
          type: TransactionType.expense,
          category: ExpenseCategory.connectivity,
          date: now.subtract(const Duration(days: 4)),
          isDeductibleBusinessExpense: true,
        ),
        TransactionItem(
          id: 'tx-4',
          title: 'Kreasi Nusantara',
          subtitle: 'Pelunasan landing page',
          amount: 7000000,
          type: TransactionType.income,
          category: ExpenseCategory.clientPayment,
          date: now.subtract(const Duration(days: 6)),
        ),
        TransactionItem(
          id: 'tx-5',
          title: 'Figma Professional',
          subtitle: 'Langganan software bulanan',
          amount: 240000,
          type: TransactionType.expense,
          category: ExpenseCategory.connectivity,
          date: now.subtract(const Duration(days: 8)),
          isDeductibleBusinessExpense: true,
        ),
      ],
      invoices: [
        InvoiceItem(
          id: 'inv-1',
          invoiceNumber: 'INV-2026-041',
          clientName: 'Sinar Media Kreatif',
          projectTitle: 'Desain Kampanye Q4',
          amount: 6500000,
          dueDate: now.subtract(const Duration(days: 3)),
          status: InvoiceStatus.overdue,
          clientPhone: '+62 811-2233-4455',
        ),
        InvoiceItem(
          id: 'inv-2',
          invoiceNumber: 'INV-2026-042',
          clientName: 'Kopi Lokal ID',
          projectTitle: 'Identitas Visual & Menu',
          amount: 4200000,
          dueDate: now.add(const Duration(days: 5)),
          status: InvoiceStatus.pending,
          clientPhone: '+62 813-9988-7766',
        ),
        InvoiceItem(
          id: 'inv-3',
          invoiceNumber: 'INV-2026-039',
          clientName: 'PT Aksara Digital',
          projectTitle: 'Retainer UI/UX November',
          amount: 14500000,
          dueDate: now.subtract(const Duration(days: 1)),
          status: InvoiceStatus.paid,
          clientPhone: '+62 812-7700-1122',
        ),
      ],
    );
  }

  void addTransaction({
    required String title,
    required String subtitle,
    required int amount,
    required TransactionType type,
    required ExpenseCategory category,
    bool isDeductibleBusinessExpense = false,
    bool consumeFreeScan = false,
  }) {
    final item = TransactionItem(
      id: 'tx-${DateTime.now().microsecondsSinceEpoch}',
      title: title,
      subtitle: subtitle,
      amount: amount,
      type: type,
      category: category,
      date: DateTime(2026, 11, 26),
      isDeductibleBusinessExpense: isDeductibleBusinessExpense,
      isPendingSync: state.isOfflineMode,
    );

    final nextFreeScans = consumeFreeScan && !state.isProMember
        ? (state.freeScansRemaining - 1).clamp(0, 99)
        : state.freeScansRemaining;

    state = state.copyWith(
      transactions: [item, ...state.transactions],
      freeScansRemaining: nextFreeScans,
    );
  }

  void applyRecommendedEmergencyPercent() {
    state = state.copyWith(
      emergencyLockedPercent: state.recommendedEmergencyPercent,
    );
  }

  void setEmergencyPercent(int percent) {
    state = state.copyWith(emergencyLockedPercent: percent.clamp(5, 40));
  }

  void setTaxScheme(TaxScheme scheme) {
    state = state.copyWith(taxScheme: scheme);
  }

  void toggleOfflineMode(bool offline) {
    if (!offline) {
      // Auto-sync pending transactions when returning online
      final synced = state.transactions
          .map((t) => t.isPendingSync ? t.copyWith(isPendingSync: false) : t)
          .toList();
      state = state.copyWith(isOfflineMode: false, transactions: synced);
    } else {
      state = state.copyWith(isOfflineMode: true);
    }
  }

  void toggleBiometric(bool enabled) {
    state = state.copyWith(biometricEnabled: enabled);
  }

  void activateProSubscription() {
    state = state.copyWith(isProMember: true);
  }

  void addInvoice({
    required String clientName,
    required String projectTitle,
    required int amount,
    required DateTime dueDate,
    String clientPhone = '+62 812-0000-1234',
  }) {
    final nextNum = 43 + state.invoices.length;
    final invoice = InvoiceItem(
      id: 'inv-${DateTime.now().microsecondsSinceEpoch}',
      invoiceNumber: 'INV-2026-0$nextNum',
      clientName: clientName,
      projectTitle: projectTitle,
      amount: amount,
      dueDate: dueDate,
      status: InvoiceStatus.pending,
      clientPhone: clientPhone,
    );
    state = state.copyWith(invoices: [invoice, ...state.invoices]);
  }

  void markInvoicePaid(String invoiceId) {
    InvoiceItem? target;
    final updated = state.invoices.map((inv) {
      if (inv.id == invoiceId) {
        target = inv.copyWith(status: InvoiceStatus.paid);
        return target!;
      }
      return inv;
    }).toList();

    state = state.copyWith(invoices: updated);

    if (target != null) {
      addTransaction(
        title: target!.clientName,
        subtitle: 'Pelunasan ${target!.invoiceNumber}',
        amount: target!.amount,
        type: TransactionType.income,
        category: ExpenseCategory.clientPayment,
      );
    }
  }
}

final financeProvider = NotifierProvider<FinanceNotifier, FinanceState>(
  FinanceNotifier.new,
);
