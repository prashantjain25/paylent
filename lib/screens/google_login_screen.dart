import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginScreen extends StatefulWidget {
  const GoogleLoginScreen({Key? key}) : super(key: key);

  @override
  State<GoogleLoginScreen> createState() => _GoogleLoginScreenState();
}

class _GoogleLoginScreenState extends State<GoogleLoginScreen> {
  bool _loading = false;
  String? _error;

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final account = await _googleSignIn.signIn();
      if (account != null) {
        // TODO: Use account info for backend auth or navigation
        setState(() {
          _error = 'Google sign-in successful: ${account.email}';
        });
        // Example: Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _error = 'Google sign-in cancelled.';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Google sign-in failed: ${e.toString()}';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Login'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_circle, size: 80, color: Colors.redAccent),
            SizedBox(height: 32),
            Text('Sign in with your Google account', style: TextStyle(fontSize: 18)),
            SizedBox(height: 24),
            if (_loading) CircularProgressIndicator(),
            if (!_loading)
              ElevatedButton.icon(
                icon: Icon(Icons.account_circle),
                label: Text('Sign in with Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                ),
                onPressed: _handleGoogleSignIn,
              ),
            SizedBox(height: 24),
            if (_error != null)
              Text(_error!, style: TextStyle(color: _error!.contains('successful') ? Colors.green : Colors.red)),
          ],
        ),
      ),
    );
  }
}
