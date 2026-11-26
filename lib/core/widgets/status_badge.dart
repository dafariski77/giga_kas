import 'package:material_ui/material_ui.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// Quiet, editorial status pill with optional leading indicator dot.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
    this.showDot = false,
    super.key,
  });

  final String label;
  final Color foregroundColor;
  final Color backgroundColor;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.borderFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: foregroundColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.xs + 2),
          ],
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
