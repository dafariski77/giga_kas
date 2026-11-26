enum TransactionType { income, expense }

enum ExpenseCategory {
  operational('Operasional'),
  connectivity('Internet & Software'),
  clientMeeting('Meeting Klien'),
  equipment('Peralatan Kerja'),
  clientPayment('Pembayaran Klien');

  const ExpenseCategory(this.label);
  final String label;
}

enum TaxScheme {
  pphFinal('PPh Final UMKM 0,5%', 0.005),
  pph21Norma('Estimasi PPh 21 (Norma 50%)', 0.025);

  const TaxScheme(this.label, this.rate);
  final String label;
  final double rate;
}

enum InvoiceStatus {
  paid('Lunas'),
  pending('Menunggu'),
  overdue('Terlambat');

  const InvoiceStatus(this.label);
  final String label;
}

class TransactionItem {
  const TransactionItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.isDeductibleBusinessExpense = false,
    this.isPendingSync = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final int amount;
  final TransactionType type;
  final ExpenseCategory category;
  final DateTime date;
  final bool isDeductibleBusinessExpense;
  final bool isPendingSync;

  TransactionItem copyWith({bool? isPendingSync}) {
    return TransactionItem(
      id: id,
      title: title,
      subtitle: subtitle,
      amount: amount,
      type: type,
      category: category,
      date: date,
      isDeductibleBusinessExpense: isDeductibleBusinessExpense,
      isPendingSync: isPendingSync ?? this.isPendingSync,
    );
  }
}

class MonthlyCashFlowPoint {
  const MonthlyCashFlowPoint({
    required this.monthLabel,
    required this.income,
    required this.expense,
    this.isProjectedLean = false,
  });

  final String monthLabel;
  final int income;
  final int expense;
  final bool isProjectedLean;
}

class InvoiceItem {
  const InvoiceItem({
    required this.id,
    required this.invoiceNumber,
    required this.clientName,
    required this.projectTitle,
    required this.amount,
    required this.dueDate,
    required this.status,
    this.clientPhone = '+62 812-3456-7890',
  });

  final String id;
  final String invoiceNumber;
  final String clientName;
  final String projectTitle;
  final int amount;
  final DateTime dueDate;
  final InvoiceStatus status;
  final String clientPhone;

  InvoiceItem copyWith({InvoiceStatus? status}) {
    return InvoiceItem(
      id: id,
      invoiceNumber: invoiceNumber,
      clientName: clientName,
      projectTitle: projectTitle,
      amount: amount,
      dueDate: dueDate,
      status: status ?? this.status,
      clientPhone: clientPhone,
    );
  }
}

class FinanceState {
  const FinanceState({
    required this.transactions,
    required this.monthlyHistory,
    required this.invoices,
    required this.taxScheme,
    required this.emergencyTargetAmount,
    required this.emergencyLockedPercent,
    required this.recommendedEmergencyPercent,
    required this.isOfflineMode,
    required this.biometricEnabled,
    required this.isProMember,
    required this.freeScansRemaining,
  });

  final List<TransactionItem> transactions;
  final List<MonthlyCashFlowPoint> monthlyHistory;
  final List<InvoiceItem> invoices;
  final TaxScheme taxScheme;
  final int emergencyTargetAmount;
  final int emergencyLockedPercent;
  final int recommendedEmergencyPercent;
  final bool isOfflineMode;
  final bool biometricEnabled;
  final bool isProMember;
  final int freeScansRemaining;

  int get totalIncome => transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0, (sum, t) => sum + t.amount);

  int get totalExpense => transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0, (sum, t) => sum + t.amount);

  int get deductibleExpenses => transactions
      .where(
        (t) => t.type == TransactionType.expense && t.isDeductibleBusinessExpense,
      )
      .fold(0, (sum, t) => sum + t.amount);

  int get netBalance => totalIncome - totalExpense;

  int get taxVaultAmount => (totalIncome * taxScheme.rate).round();

  int get emergencyVaultAmount =>
      ((netBalance > 0 ? netBalance : 0) * (emergencyLockedPercent / 100)).round();

  int get spendableCash =>
      (netBalance - taxVaultAmount - emergencyVaultAmount).clamp(0, netBalance);

  int get pendingSyncCount =>
      transactions.where((t) => t.isPendingSync).length;

  FinanceState copyWith({
    List<TransactionItem>? transactions,
    List<MonthlyCashFlowPoint>? monthlyHistory,
    List<InvoiceItem>? invoices,
    TaxScheme? taxScheme,
    int? emergencyTargetAmount,
    int? emergencyLockedPercent,
    int? recommendedEmergencyPercent,
    bool? isOfflineMode,
    bool? biometricEnabled,
    bool? isProMember,
    int? freeScansRemaining,
  }) {
    return FinanceState(
      transactions: transactions ?? this.transactions,
      monthlyHistory: monthlyHistory ?? this.monthlyHistory,
      invoices: invoices ?? this.invoices,
      taxScheme: taxScheme ?? this.taxScheme,
      emergencyTargetAmount:
          emergencyTargetAmount ?? this.emergencyTargetAmount,
      emergencyLockedPercent:
          emergencyLockedPercent ?? this.emergencyLockedPercent,
      recommendedEmergencyPercent:
          recommendedEmergencyPercent ?? this.recommendedEmergencyPercent,
      isOfflineMode: isOfflineMode ?? this.isOfflineMode,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      isProMember: isProMember ?? this.isProMember,
      freeScansRemaining: freeScansRemaining ?? this.freeScansRemaining,
    );
  }
}
