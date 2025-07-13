// Example usage in other screens:
// import 'package:paylent/screens/main/home_screen.dart';
// import 'package:paylent/glassmorphism_widgets.dart';

import 'dart:ui';
import 'package:flutter/material.dart';

/// GlassButton: A reusable frosted glass button for light/dark mode.
class GlassButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const GlassButton({
    Key? key,
    required this.child,
    this.onTap,
    this.width = 56,
    this.height = 56,
    this.borderRadius = 24,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isPlusButton = width == height && width >= 56 && width <= 80 && borderRadius >= 28; // Heuristic for FAB
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
          child: Container(
            width: width,
            height: height,
            padding: padding,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withOpacity(0.45)
                  : Colors.white.withOpacity(0.20),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.18)
                    : isPlusButton
                      ? Colors.white.withOpacity(0.90) // Nearly solid white for plus button
                      : Colors.white.withOpacity(0.16),
                width: isPlusButton ? 3.5 : 2.0, // Thicker border for plus button
              ),
              boxShadow: [
                if (isPlusButton && !isDark)
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.10),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.45)
                      : Colors.grey.withOpacity(0.13),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
              gradient: !isDark
                  ? LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.18),
                        Colors.white.withOpacity(0.09),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

/// GlassNavBar: A reusable frosted glass navigation bar container.
class GlassNavBar extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double height;
  final EdgeInsetsGeometry? margin;

  const GlassNavBar({
    Key? key,
    required this.child,
    this.borderRadius = 40,
    this.height = 70,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: margin ?? const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withOpacity(0.35)
                  : Colors.white.withOpacity(0.18), // More transparent for glass effect
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.10)
                    : Colors.white.withOpacity(0.13),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.40)
                      : Colors.grey.withOpacity(0.10),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
              gradient: !isDark
                  ? LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.13),
                        Colors.white.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
