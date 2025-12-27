import 'package:flutter/material.dart';

/// App-wide color constants.
///
/// Using a dedicated class for colors ensures a consistent color scheme
/// across the entire application, making it easy to update and maintain.
class AppColors {
  AppColors._(); // Prevent instantiation

  /// The primary color for the application, used for major UI elements.
  static const Color primaryBlue = Colors.blue;

  /// An accent color for highlighting important actions or alerts.
  static const Color accentRed = Colors.redAccent;

  /// An alternative accent color for secondary UI elements.
  static const Color accentIndigo = Colors.indigo;

  /// The default text color for dark-themed backgrounds.
  static const Color textDark = Colors.black87;

  /// The default text color for light-themed backgrounds.
  static const Color textLight = Colors.white;
}

/// App-wide string constants.
///
/// Centralizing strings simplifies localization and ensures consistency
/// in user-facing text. It also helps prevent typos and makes the code
/// more readable.
class AppStrings {

  AppStrings._(); // Prevent instantiation

  /// The main welcome message on the entry screen.
  static const String welcome = 'Welcome to Paylent';

  /// The application's tagline, displayed below the welcome message.
  static const String tagline = 'Your smart, simple finance manager.';

  /// The label for the currency selection dropdown.
  static const String selectCurrency = 'Select Currency';

  /// The title for the 'Add Expense' screen and button.
  static const String addExpense = 'Add Expense';

  /// The label for the button that saves a new expense.
  static const String saveExpense = 'Save Expense';
}

/// App-wide padding and spacing constants.
///
/// Using predefined padding values ensures a consistent layout and spacing
/// throughout the app, which is crucial for a polished user experience.
class AppPaddings {

  AppPaddings._(); // Prevent instantiation
  
  /// The default padding for screens and major layout components.
  static const double screen = 24.0;

  /// The padding used to separate sections within a screen.
  static const double section = 16.0;
}

class AppRoutes {
  AppRoutes._(); // Prevent instantiation

  static const String splash = '/splash';
  static const String authEntry = '/auth_entry';
  static const String emailLogin = '/email_login';
  static const String fingerprintLogin = '/fingerprint_login';
  static const String googleLogin = '/google_login';
  static const String home = '/home';
  static const String addExpense = '/add_expense';
  static const String forgotPassword = '/forgot_password';
}