/// Formatting helpers for Indonesian Rupiah and concise dates.
abstract final class CurrencyFormatter {
  static String formatIdr(int amount, {bool showSign = false}) {
    final absAmount = amount.abs();
    final digits = absAmount.toString();
    final buffer = StringBuffer();

    for (var i = 0; i < digits.length; i++) {
      final positionFromEnd = digits.length - i;
      buffer.write(digits[i]);
      if (positionFromEnd > 1 && positionFromEnd % 3 == 1) {
        buffer.write('.');
      }
    }

    final prefix = amount < 0
        ? '-Rp '
        : showSign && amount > 0
            ? '+Rp '
            : 'Rp ';
    return '$prefix${buffer.toString()}';
  }

  static String formatCompactIdr(int amount) {
    final abs = amount.abs();
    if (abs >= 1000000) {
      final jt = amount / 1000000;
      final formatted =
          jt == jt.roundToDouble() ? jt.toInt().toString() : jt.toStringAsFixed(1);
      return 'Rp ${formatted}jt';
    }
    if (abs >= 1000) {
      return 'Rp ${(amount / 1000).round()}rb';
    }
    return 'Rp $amount';
  }

  static String formatShortDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
