import 'package:flutter/material.dart';

class AppNav {
  /// Navigates to any screen passed in the 'to' parameter
  static Future<T?> push<T>(final BuildContext context, final Widget to) => Navigator.push(
      context,
      MaterialPageRoute(builder: (final context) => to),
    );

  /// Replaces the current screen (e.g., after Login)
  static Future<T?> pushReplacement<T>(final BuildContext context, final Widget to) => Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (final context) => to),
    );
}