import 'package:flutter/material.dart';
import 'package:paylent/screens/login_screen.dart';
import 'package:paylent/screens/register_screen.dart';

/// Entry screen for authentication options
class AuthEntryScreen extends StatefulWidget {
  const AuthEntryScreen({super.key});

  @override
  State<AuthEntryScreen> createState() => _AuthEntryScreenState();
}

class _AuthEntryScreenState extends State<AuthEntryScreen> {
  bool showLogin = true;

  void toggleScreens() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            const Center(
              child: Icon(Icons.account_balance_wallet_rounded,
                  size: 80, color: Colors.blue),
            ),
            const SizedBox(height: 32),
            const Text(
              'Welcome to Paylent',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.blue),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your smart, simple finance manager.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: showLogin ? const LoginScreen() : const RegisterScreen(),
            ),
            TextButton(
              onPressed: toggleScreens,
              child: Text(
                showLogin
                    ? 'Don\'t have an account? Register here.'
                    : 'Already have an account? Login here.',
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.account_circle),
              label: const Text('Continue with Google'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/google_login');
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    ),
  );
}
