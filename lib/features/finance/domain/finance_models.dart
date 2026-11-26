enum TransactionType { income, expense }

/// Categories aligned 1:1 with `gigakas_receipt_pipeline.onnx` output labels.
enum ExpenseCategory {
  internetSoftware('Internet & Software'),
  clientMeeting('Client Meeting & F&B'),
  transport('Transportasi & Perjalanan'),
  equipment('Peralatan Kerja & ATK'),
  other('Lain-lain'),
  clientPayment('Pembayaran Klien');

  const ExpenseCategory(this.label);
  final String label;

  static List<ExpenseCategory> get expenseOnly => const [
        internetSoftware,
        clientMeeting,
        transport,
        equipment,
        other,
      ];

  static ExpenseCategory fromLabel(String raw) {
    final normalized = raw.trim().toLowerCase();
    for (final cat in ExpenseCategory.values) {
      if (cat.label.toLowerCase() == normalized) return cat;
    }
    if (normalized.contains('internet') || normalized.contains('software')) {
      return internetSoftware;
    }
    if (normalized.contains('meeting') ||
        normalized.contains('f&b') ||
        normalized.contains('kopi')) {
      return clientMeeting;
    }
    if (normalized.contains('transport') || normalized.contains('perjalanan')) {
      return transport;
    }
    if (normalized.contains('peralatan') || normalized.contains('atk')) {
      return equipment;
    }
    if (normalized.contains('klien') || normalized.contains('income')) {
      return clientPayment;
    }
    return other;
  }
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

  static InvoiceStatus fromStorage(String raw) {
    return switch (raw) {
      'paid' => InvoiceStatus.paid,
      'overdue' => InvoiceStatus.overdue,
      _ => InvoiceStatus.pending,
    };
  }
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
    this.taxAmount = 0,
    this.emergencyAllocated = 0,
    this.isDeductibleBusinessExpense = false,
    this.isPendingSync = false,
    this.rawOcrText,
  });

  final int id;
  final String title;
  final String subtitle;
  final int amount;
  final TransactionType type;
  final ExpenseCategory category;
  final DateTime date;
  final int taxAmount;
  final int emergencyAllocated;
  final bool isDeductibleBusinessExpense;
  final bool isPendingSync;
  final String? rawOcrText;
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
    this.clientPhone = '',
  });

  final int id;
  final String invoiceNumber;
  final String clientName;
  final String projectTitle;
  final int amount;
  final DateTime dueDate;
  final InvoiceStatus status;
  final String clientPhone;
}

class MerchantOverrideItem {
  const MerchantOverrideItem({
    required this.id,
    required this.normalizedMerchant,
    required this.correctedCategory,
    required this.updatedAt,
  });

  final int id;
  final String normalizedMerchant;
  final String correctedCategory;
  final DateTime updatedAt;
}

class IncomeForecast {
  const IncomeForecast({
    required this.predictedAmount,
    required this.nextMonthLabel,
    required this.averageRecentIncome,
    required this.recommendedLockPercent,
    required this.recommendedLockAmount,
    required this.isLeanMonthRisk,
    required this.usedOnnxModel,
    required this.usedColdStartFallback,
    required this.activeClients,
    required this.incomeCv,
  });

  final int predictedAmount;
  final String nextMonthLabel;
  final int averageRecentIncome;
  final int recommendedLockPercent;
  final int recommendedLockAmount;
  final bool isLeanMonthRisk;
  final bool usedOnnxModel;
  final bool usedColdStartFallback;
  final int activeClients;
  final double incomeCv;

  double get deltaPercent => averageRecentIncome > 0
      ? ((predictedAmount - averageRecentIncome) / averageRecentIncome) * 100
      : 0;
}

class FinanceState {
  const FinanceState({
    required this.isLoading,
    required this.transactions,
    required this.monthlyHistory,
    required this.invoices,
    required this.merchantOverrides,
    required this.taxScheme,
    required this.emergencyVaultId,
    required this.emergencyLockedAmount,
    required this.emergencyTargetAmount,
    required this.emergencyLockedPercent,
    required this.biometricEnabled,
    required this.isProMember,
    required this.freeScansRemaining,
    required this.onnxReady,
    this.incomeForecast,
  });

  factory FinanceState.initial() => const FinanceState(
        isLoading: true,
        transactions: [],
        monthlyHistory: [],
        invoices: [],
        merchantOverrides: [],
        taxScheme: TaxScheme.pphFinal,
        emergencyVaultId: 1,
        emergencyLockedAmount: 0,
        emergencyTargetAmount: 0,
        emergencyLockedPercent: 15,
        biometricEnabled: true,
        isProMember: false,
        freeScansRemaining: 5,
        onnxReady: false,
      );

  final bool isLoading;
  final List<TransactionItem> transactions;
  final List<MonthlyCashFlowPoint> monthlyHistory;
  final List<InvoiceItem> invoices;
  final List<MerchantOverrideItem> merchantOverrides;
  final TaxScheme taxScheme;
  final int emergencyVaultId;
  final int emergencyLockedAmount;
  final int emergencyTargetAmount;
  final int emergencyLockedPercent;
  final bool biometricEnabled;
  final bool isProMember;
  final int freeScansRemaining;
  final bool onnxReady;
  final IncomeForecast? incomeForecast;

  int get recommendedEmergencyPercent =>
      incomeForecast?.recommendedLockPercent ?? 20;

  int get totalIncome => transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0, (sum, t) => sum + t.amount);

  int get totalExpense => transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0, (sum, t) => sum + t.amount);

  int get deductibleExpenses => transactions
      .where(
        (t) =>
            t.type == TransactionType.expense && t.isDeductibleBusinessExpense,
      )
      .fold(0, (sum, t) => sum + t.amount);

  int get netBalance => totalIncome - totalExpense;

  int get taxVaultAmount => (totalIncome * taxScheme.rate).round();

  int get emergencyVaultAmount => emergencyLockedAmount;

  int get spendableCash => (netBalance - taxVaultAmount - emergencyVaultAmount)
      .clamp(0, netBalance > 0 ? netBalance : 0);

  FinanceState copyWith({
    bool? isLoading,
    List<TransactionItem>? transactions,
    List<MonthlyCashFlowPoint>? monthlyHistory,
    List<InvoiceItem>? invoices,
    List<MerchantOverrideItem>? merchantOverrides,
    TaxScheme? taxScheme,
    int? emergencyVaultId,
    int? emergencyLockedAmount,
    int? emergencyTargetAmount,
    int? emergencyLockedPercent,
    bool? biometricEnabled,
    bool? isProMember,
    int? freeScansRemaining,
    bool? onnxReady,
    IncomeForecast? incomeForecast,
    bool clearForecast = false,
  }) {
    return FinanceState(
      isLoading: isLoading ?? this.isLoading,
      transactions: transactions ?? this.transactions,
      monthlyHistory: monthlyHistory ?? this.monthlyHistory,
      invoices: invoices ?? this.invoices,
      merchantOverrides: merchantOverrides ?? this.merchantOverrides,
      taxScheme: taxScheme ?? this.taxScheme,
      emergencyVaultId: emergencyVaultId ?? this.emergencyVaultId,
      emergencyLockedAmount:
          emergencyLockedAmount ?? this.emergencyLockedAmount,
      emergencyTargetAmount:
          emergencyTargetAmount ?? this.emergencyTargetAmount,
      emergencyLockedPercent:
          emergencyLockedPercent ?? this.emergencyLockedPercent,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      isProMember: isProMember ?? this.isProMember,
      freeScansRemaining: freeScansRemaining ?? this.freeScansRemaining,
      onnxReady: onnxReady ?? this.onnxReady,
      incomeForecast:
          clearForecast ? null : (incomeForecast ?? this.incomeForecast),
    );
  }
}
