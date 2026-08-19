import 'dart:ui';

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double borderRadius;
  final double blur;
  final double borderWidth;
  final Color? borderColor;
  final Color? color;
  final bool selected;
  final bool showShadow;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.borderRadius = 12,
    this.blur = 16,
    this.borderWidth = 1,
    this.borderColor,
    this.color,
    this.selected = false,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    final resolvedBorder = borderColor ??
        (selected ? AppColors.primaryLight : AppColors.glassBorder);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: showShadow
            ? const [
                BoxShadow(
                  color: AppColors.glassShadow,
                  blurRadius: 22,
                  offset: Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Material(
            color: color ?? AppColors.glassBackground,
            child: InkWell(
              onTap: onTap,
              borderRadius: radius,
              splashColor: AppColors.primary.withValues(alpha: 0.12),
              highlightColor: Colors.white.withValues(alpha: 0.04),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                padding: padding ?? const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: radius,
                  gradient: selected ? AppColors.glassGradient : null,
                  border: Border.all(
                    color: resolvedBorder,
                    width: selected ? 1.35 : borderWidth,
                  ),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
