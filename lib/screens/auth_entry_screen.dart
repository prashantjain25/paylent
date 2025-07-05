import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';

class AuthEntryScreen extends StatelessWidget {
  const AuthEntryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(),
              // App Logo or Illustration
              Center(
                child: Icon(Icons.account_balance_wallet_rounded, size: 80, color: Colors.deepPurple),
              ),
              SizedBox(height: 32),
              Text(
                'Welcome to Paylent',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                'Split expenses easily with friends.',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton.icon(
                icon: Icon(Icons.email),
                label: Text('Continue with Email'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/email_login');
                },
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.fingerprint),
                label: Text('Continue with Fingerprint'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/fingerprint_login');
                },
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.account_circle),
                label: Text('Continue with Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/google_login');
                },
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
