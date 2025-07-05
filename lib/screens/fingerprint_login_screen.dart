import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class FingerprintLoginScreen extends StatefulWidget {
  const FingerprintLoginScreen({Key? key}) : super(key: key);

  @override
  State<FingerprintLoginScreen> createState() => _FingerprintLoginScreenState();
}

class _FingerprintLoginScreenState extends State<FingerprintLoginScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  String _authStatus = '';
  bool _loading = false;

  Future<void> _authenticate() async {
    setState(() {
      _loading = true;
      _authStatus = '';
    });
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to login',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      setState(() {
        _authStatus = authenticated ? 'Authentication successful!' : 'Authentication failed.';
      });
      if (authenticated) {
        // TODO: Navigate to home or main app screen
      }
    } catch (e) {
      setState(() {
        _authStatus = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fingerprint Login'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fingerprint, size: 80, color: Colors.indigo),
            SizedBox(height: 32),
            Text('Use your fingerprint to login', style: TextStyle(fontSize: 18)),
            SizedBox(height: 24),
            if (_loading) CircularProgressIndicator(),
            if (!_loading)
              ElevatedButton.icon(
                icon: Icon(Icons.fingerprint),
                label: Text('Authenticate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                ),
                onPressed: _authenticate,
              ),
            SizedBox(height: 24),
            Text(_authStatus, style: TextStyle(color: _authStatus.contains('successful') ? Colors.green : Colors.red)),
          ],
        ),
      ),
    );
  }
}
