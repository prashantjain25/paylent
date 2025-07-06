 import 'package:flutter/material.dart';
// import 'screens/splash_screen.dart';
import 'screens/auth_entry_screen.dart';
import 'screens/email_login_screen.dart';
import 'screens/fingerprint_login_screen.dart';
import 'screens/google_login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_expense_screen.dart';

// Theme mode notifier for switching themes globally
ValueNotifier<ThemeMode> appThemeMode = ValueNotifier(ThemeMode.dark);

void main() => runApp(PaylentApp());

class PaylentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appThemeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Paylent',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            primaryColor: Colors.blue,
            scaffoldBackgroundColor: Color(0xFFF7F6FB),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
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
            ),
            colorScheme: ColorScheme.dark(
              primary: Colors.blue,
              secondary: Colors.blueAccent,
              background: Colors.black,
              surface: Colors.black,
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
            // '/splash': (context) => SplashScreen(),
            '/auth_entry': (context) => AuthEntryScreen(),
            '/email_login': (context) => EmailLoginScreen(),
            '/fingerprint_login': (context) => FingerprintLoginScreen(),
            '/google_login': (context) => GoogleLoginScreen(),
            '/home': (context) => HomeScreen(),
            '/add_expense': (context) => AddExpenseScreen(),
          },
        );
      },
    );
  }
}
