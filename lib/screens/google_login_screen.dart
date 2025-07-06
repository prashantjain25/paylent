import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Import for Google Sign-In

class GoogleLoginScreen extends StatefulWidget {
  const GoogleLoginScreen({super.key});

  @override
  State<GoogleLoginScreen> createState() => _GoogleLoginScreenState();
}

class _GoogleLoginScreenState extends State<GoogleLoginScreen> {
  bool _isLoading = false;
  String _status = '';
  // Initialize Google Sign-In
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );
  
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _handleSignIn() async {
    setState(() {
      _isLoading = true;
      _status = 'Signing in...';
    });

    try {
      // Begin the sign-in flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        setState(() {
          _status = 'Sign in was canceled';
          _isLoading = false;
        });
        return;
      }
      
      // Get the authentication details
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;
      
      // Create a credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Sign in to Firebase
      final UserCredential userCredential = 
          await _auth.signInWithCredential(credential);
      
      // Get the signed-in user
      final User? user = userCredential.user;
      
      if (user != null) {
        setState(() {
          _status = 'Signed in as: ${user.email ?? 'Unknown user'}';
        });
        
        // Navigate to home screen after successful sign-in
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        setState(() {
          _status = 'Failed to sign in: No user returned';
          _isLoading = false;
        });
      }
    } on PlatformException catch (error) {
      setState(() {
        _status = 'Error signing in: ${error.message}';
      });
      debugPrint('PlatformException: $error');
    } on FirebaseAuthException catch (error) {
      setState(() {
        _status = 'Authentication failed: ${error.message}';
      });
      debugPrint('FirebaseAuthException: $error');
    } on Exception catch (error) {
      setState(() {
        _status = 'Error signing in: $error';
      });
      debugPrint('Exception: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Google Sign In'),
      backgroundColor: Colors.red,
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.g_mobiledata,
            size: 100,
            color: Colors.red,
          ),
          const SizedBox(height: 32),
          const Text(
            'Sign in with Google',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            _status,
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _handleSignIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.g_mobiledata, size: 24),
                      SizedBox(width: 12),
                      Text('Sign in with Google'),
                    ],
                  ),
                ),
        ],
      ),
    ),
  );
}
