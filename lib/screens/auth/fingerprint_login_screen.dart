import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class FingerprintLoginScreen extends StatefulWidget {
  const FingerprintLoginScreen({super.key});

  @override
  State<FingerprintLoginScreen> createState() => _FingerprintLoginScreenState();
}

class _FingerprintLoginScreenState extends State<FingerprintLoginScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isLoading = false;
  String _status = '';

  Future<void> _authenticate() async {
    setState(() {
      _isLoading = true;
      _status = 'Authenticating...';
    });

    try {
      final bool authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to login',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );

      setState(() {
        _status = authenticated
            ? 'Authentication successful!'
            : 'Authentication failed or was canceled.';
      });

      if (authenticated) {
        // TODO: Navigate to home or main app screen
      }
    } on PlatformException catch (e) {
      setState(() {
        _status = 'Error: ${e.message}';
      });
    } on Exception catch (e) {
      setState(() {
        _status = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Fingerprint Login'),
      backgroundColor: Colors.deepPurple,
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.fingerprint,
            size: 80,
            color: Colors.deepPurple,
          ),
          const SizedBox(height: 32),
          const Text(
            'Authenticate with Fingerprint',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            _status,
            style: TextStyle(
                color: _status.contains('successful')
                    ? Colors.green
                    : (_status.contains('Error') ? Colors.red : Colors.grey)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton.icon(
                  icon: const Icon(Icons.fingerprint),
                  label: const Text('Authenticate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  onPressed: _authenticate,
                ),
        ],
      ),
    ),
  );
}
