import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isSecondary;
  final bool isFullWidth;
  final bool compact;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isSecondary = false,
    this.isFullWidth = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = isSecondary ? AppColors.textPrimary : Colors.white;
    final childWidget = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(foreground),
            ),
          )
        else if (icon != null)
          Icon(icon, size: compact ? 15 : 17, color: foreground),
        if (isLoading || icon != null) const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelMedium.copyWith(
              fontSize: compact ? 11 : 13,
              letterSpacing: 0,
              color: foreground,
            ),
          ),
        ),
      ],
    );

    final button = SizedBox(
      height: compact ? 38 : 44,
      child: isSecondary
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              child: childWidget,
            )
          : DecoratedBox(
              decoration: BoxDecoration(
                gradient: onPressed == null ? null : AppColors.primaryGradient,
                color: onPressed == null
                    ? AppColors.glassBackgroundStrong
                    : null,
                borderRadius: BorderRadius.circular(9),
                boxShadow: onPressed == null
                    ? null
                    : [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.26),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
              ),
              child: ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 16),
                ),
                child: childWidget,
              ),
            ),
    );

    return isFullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}
