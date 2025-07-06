import 'package:flutter/material.dart';
import 'package:paylent/screens/auth_entry_screen.dart';
import 'package:paylent/screens/email_login_screen.dart';
import 'package:paylent/screens/fingerprint_login_screen.dart';
import 'package:paylent/screens/google_login_screen.dart';
import 'package:paylent/screens/home_screen.dart';
import 'package:paylent/screens/add_expense_screen.dart';

// Theme mode notifier for switching themes globally
ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.dark);

void main() => runApp(const PaylentApp());

class PaylentApp extends StatelessWidget {
  const PaylentApp({super.key});

  @override
  Widget build(final BuildContext context) => ValueListenableBuilder<ThemeMode>(
        valueListenable: themeMode,
        builder: (final BuildContext context, final ThemeMode mode, final Widget? _) => MaterialApp(
          title: 'Paylent',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            primaryColor: Colors.blue,
            scaffoldBackgroundColor: const Color(0xFFF7F6FB),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              secondary: Colors.blueAccent,
              background: Color(0xFFF7F6FB),
              surface: Colors.white,
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: Colors.blue),
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: Colors.black),
              bodyMedium: TextStyle(color: Colors.black87),
              titleLarge: TextStyle(color: Colors.black),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
            primaryColor: Colors.blue,
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            colorScheme: ColorScheme.dark(
              primary: Colors.blue,
              secondary: Colors.blueAccent,
              background: Colors.black,
              surface: Colors.black87,
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.black,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.black,
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: Colors.blue),
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white70),
              titleLarge: TextStyle(color: Colors.white),
            ),
          ),
          themeMode: mode,
          initialRoute: '/home',
          routes: {
            '/auth_entry': (final BuildContext context) => const AuthEntryScreen(),
            '/email_login': (final BuildContext context) => const EmailLoginScreen(),
            '/fingerprint_login': (final BuildContext context) => const FingerprintLoginScreen(),
            '/google_login': (final BuildContext context) => const GoogleLoginScreen(),
            '/home': (final BuildContext context) => const HomeScreen(),
            '/add_expense': (final BuildContext context) => const AddExpenseScreen(),
          },
        ),
      );
}
