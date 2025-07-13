import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:paylent/screens/add_expense_screen.dart';
import 'package:paylent/screens/auth_entry_screen.dart';
import 'package:paylent/screens/email_login_screen.dart';
import 'package:paylent/screens/fingerprint_login_screen.dart';
import 'package:paylent/screens/google_login_screen.dart';
import 'package:paylent/screens/home_screen.dart';
import 'package:paylent/screens/splash_screen.dart';
import 'package:paylent/screens/forgot_password_screen.dart';
import 'package:paylent/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';

/// A global `ValueNotifier` for managing the application's theme mode.
///
/// Using a `ValueNotifier` allows for efficient theme switching without needing
/// a full state management library. Widgets that need to react to theme changes
/// can listen to this notifier and rebuild automatically.
ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.dark);

/// The main entry point of the application.
Future<void> main() async {
  await dotenv.load();
  await Firebase.initializeApp();
  runApp(const PaylentApp());
}

/// The root widget of the Paylent application.
class PaylentApp extends StatelessWidget {
  /// Creates a new instance of the PaylentApp.
  const PaylentApp({super.key});

  @override
  Widget build(final BuildContext context) => ValueListenableBuilder<ThemeMode>(
        valueListenable: themeMode,
        builder: (final BuildContext context, final ThemeMode mode,
            final Widget? _) =>
            MaterialApp(
          title: 'Paylent',

          // Defines the light theme for the application.
          theme: AppTheme.light,

          // Defines the dark theme for the application.
          darkTheme: AppTheme.dark,

          // Sets the current theme mode based on the `themeMode` notifier.
          themeMode: mode,

          // Sets the initial route of the application.
          initialRoute: '/splash',

          // Defines the named routes for navigation.
          routes: {
            '/splash': (final BuildContext context) => const SplashScreen(),
            '/auth_entry': (final BuildContext context) =>
                const AuthEntryScreen(),
            '/email_login': (final BuildContext context) =>
                const EmailLoginScreen(),
            '/fingerprint_login': (final BuildContext context) =>
                const FingerprintLoginScreen(),
            '/google_login': (final BuildContext context) =>
                const GoogleLoginScreen(),
            '/home': (final BuildContext context) => const HomeScreen(),
            '/add_expense': (final BuildContext context) =>
                const AddExpenseScreen(),
            '/forgot_password': (final context) => const ForgotPasswordScreen(),
          },
        ),
      );
}
