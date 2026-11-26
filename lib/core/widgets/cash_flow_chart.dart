import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../features/finance/domain/finance_models.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../utils/currency_formatter.dart';

/// Clean, low-clutter 6-month income vs. expense bar chart with lean-month indicator.
class CashFlowChart extends StatelessWidget {
  const CashFlowChart({
    required this.points,
    super.key,
  });

  final List<MonthlyCashFlowPoint> points;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Arus Kas 6 Bulan', style: textTheme.titleMedium),
            Row(
              children: [
                _LegendItem(
                  color: colorScheme.primary,
                  label: 'Masuk',
                ),
                const SizedBox(width: AppSpacing.md),
                _LegendItem(
                  color: colorScheme.outline,
                  label: 'Keluar',
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          height: 156,
          width: double.infinity,
          child: CustomPaint(
            painter: _CashFlowPainter(
              points: points,
              incomeColor: colorScheme.primary,
              expenseColor: colorScheme.outline,
              projectedColor: colorScheme.primary.withValues(alpha: 0.35),
              gridColor: colorScheme.outlineVariant,
              labelStyle: textTheme.labelMedium!.copyWith(
                fontSize: 11,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.35),
                borderRadius: AppRadius.borderXs,
              ),
            ),
            const SizedBox(width: AppSpacing.xs + 2),
            Expanded(
              child: Text(
                '*Des proyeksi AI: potensi penurunan proyek (${CurrencyFormatter.formatCompactIdr(8900000)})',
                style: textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppSpacing.xs + 2),
        Text(label, style: textTheme.bodySmall),
      ],
    );
  }
}

class _CashFlowPainter extends CustomPainter {
  _CashFlowPainter({
    required this.points,
    required this.incomeColor,
    required this.expenseColor,
    required this.projectedColor,
    required this.gridColor,
    required this.labelStyle,
  });

  final List<MonthlyCashFlowPoint> points;
  final Color incomeColor;
  final Color expenseColor;
  final Color projectedColor;
  final Color gridColor;
  final TextStyle labelStyle;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    const bottomLabelHeight = 24.0;
    const topPadding = 8.0;
    final chartHeight = size.height - bottomLabelHeight - topPadding;

    final maxVal = points.fold<int>(
      1,
      (max, p) => math.max(max, math.max(p.income, p.expense)),
    );

    // Subtle 3 horizontal hairlines
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    for (var i = 0; i <= 2; i++) {
      final y = topPadding + (chartHeight / 2) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final groupWidth = size.width / points.length;
    const barWidth = 12.0;
    const barGap = 4.0;

    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final centerX = groupWidth * i + groupWidth / 2;

      final incomeHeight = (point.income / maxVal) * chartHeight;
      final expenseHeight = (point.expense / maxVal) * chartHeight;

      final incomeRect = RRect.fromRectAndCorners(
        Rect.fromLTWH(
          centerX - barWidth - barGap / 2,
          topPadding + chartHeight - incomeHeight,
          barWidth,
          incomeHeight,
        ),
        topLeft: const Radius.circular(3),
        topRight: const Radius.circular(3),
      );

      final expenseRect = RRect.fromRectAndCorners(
        Rect.fromLTWH(
          centerX + barGap / 2,
          topPadding + chartHeight - expenseHeight,
          barWidth,
          expenseHeight,
        ),
        topLeft: const Radius.circular(3),
        topRight: const Radius.circular(3),
      );

      canvas.drawRRect(
        incomeRect,
        Paint()..color = point.isProjectedLean ? projectedColor : incomeColor,
      );
      canvas.drawRRect(
        expenseRect,
        Paint()
          ..color = point.isProjectedLean
              ? expenseColor.withValues(alpha: 0.45)
              : expenseColor,
      );

      final textPainter = TextPainter(
        text: TextSpan(text: point.monthLabel, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(
          centerX - textPainter.width / 2,
          topPadding + chartHeight + 6,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CashFlowPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.incomeColor != incomeColor ||
        oldDelegate.gridColor != gridColor;
  }
}
