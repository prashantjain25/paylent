 import 'package:flutter/material.dart';
// import 'screens/splash_screen.dart';
import 'screens/auth_entry_screen.dart';
import 'screens/email_login_screen.dart';
import 'screens/fingerprint_login_screen.dart';
import 'screens/google_login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_expense_screen.dart';

void main() => runApp(PaylentApp());

class PaylentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paylent',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Color(0xFFF7F6FB),
      ),
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
  }
}
