import 'dart:ui';

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class SoftGlassBackground extends StatelessWidget {
  final Widget child;

  const SoftGlassBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration:
          const BoxDecoration(gradient: AppColors.darkBackgroundGradient),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const IgnorePointer(
              child: CustomPaint(painter: _AtmospherePainter())),
          child,
        ],
      ),
    );
  }
}

class SoftReveal extends StatelessWidget {
  final Widget child;
  final double offset;

  const SoftReveal({super.key, required this.child, this.offset = 12});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
      builder: (context, value, animatedChild) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, offset * (1 - value)),
          child: animatedChild,
        ),
      ),
      child: child,
    );
  }
}

class SoftGlassDock extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onCreate;

  const SoftGlassDock({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.home_rounded, Icons.home_outlined, 'Home'),
      (Icons.description_rounded, Icons.description_outlined, 'Resumes'),
      (Icons.layers_rounded, Icons.layers_outlined, 'Templates'),
      (Icons.person_rounded, Icons.person_outline_rounded, 'Profile'),
    ];

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: SizedBox(
        height: 66,
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.darkBackground.withValues(alpha: 0.62),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.glassBorder),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.glassShadow,
                        blurRadius: 24,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      _DockItem(
                          index: 0,
                          item: items[0],
                          selectedIndex: selectedIndex,
                          onTap: onDestinationSelected),
                      _DockItem(
                          index: 1,
                          item: items[1],
                          selectedIndex: selectedIndex,
                          onTap: onDestinationSelected),
                      const SizedBox(width: 54),
                      _DockItem(
                          index: 2,
                          item: items[2],
                          selectedIndex: selectedIndex,
                          onTap: onDestinationSelected),
                      _DockItem(
                          index: 3,
                          item: items[3],
                          selectedIndex: selectedIndex,
                          onTap: onDestinationSelected),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -12,
              child: Semantics(
                button: true,
                label: 'Create new resume',
                child: InkResponse(
                  onTap: onCreate,
                  radius: 30,
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.42)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.48),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add_rounded,
                        color: Colors.white, size: 28),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DockItem extends StatelessWidget {
  final int index;
  final (IconData, IconData, String) item;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _DockItem({
    required this.index,
    required this.item,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = selectedIndex == index;
    return Expanded(
      child: InkResponse(
        onTap: () => onTap(index),
        radius: 28,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 30,
              height: 26,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary.withValues(alpha: 0.22)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                selected ? item.$1 : item.$2,
                color:
                    selected ? AppColors.primaryLight : AppColors.textSecondary,
                size: 18,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              item.$3,
              maxLines: 1,
              style: TextStyle(
                color: selected ? AppColors.textPrimary : AppColors.textMuted,
                fontSize: 8,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AtmospherePainter extends CustomPainter {
  const _AtmospherePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final upperBeam = Path()
      ..moveTo(size.width * 0.44, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.28)
      ..lineTo(size.width * 0.77, size.height * 0.18)
      ..close();
    canvas.drawPath(
      upperBeam,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0x1FFFFFFF), Color(0x00FFFFFF)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ).createShader(Offset.zero & size),
    );

    final lowerBeam = Path()
      ..moveTo(0, size.height * 0.55)
      ..lineTo(size.width * 0.72, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      lowerBeam,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0x1A4FC8C4), Color(0x0036B6C2)],
          begin: Alignment.centerLeft,
          end: Alignment.bottomRight,
        ).createShader(Offset.zero & size),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
