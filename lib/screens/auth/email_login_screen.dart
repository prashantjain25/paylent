import 'package:flutter/material.dart';

/// A screen for users to log in or sign up using their email and password.
///
/// This screen contains a form that adapts for both login and registration.
/// It includes validation for the email and password fields and provides
/// clear user feedback during the authentication process.
class EmailLoginScreen extends StatefulWidget {
  /// Creates a new instance of the EmailLoginScreen.
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  // A global key for the form to manage its state and perform validation.
  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields to manage their content.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Booleans to manage the UI state.
  bool _isLogin = true; // Toggles between login and sign-up mode.
  bool _loading = false; // Shows a loading indicator during auth.

  // Holds any error messages from the authentication process.
  String? _error;

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(_isLogin ? 'Login with Email' : 'Sign Up'),
          backgroundColor: Colors.deepPurple,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Email input field.
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (final value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your email';
                    }
                    // A simple email validation.
                    if (!value.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Password input field.
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true, // Hides the password text.
                  validator: (final value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Displays any authentication errors.
                if (_error != null)
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                // The main action button (Login or Sign Up).
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    // The button is disabled while loading.
                    onPressed: _loading
                        ? null
                        : () async {
                            // Validates the form before proceeding.
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _loading = true;
                                _error = null;
                              });
                              // TODO: Implement Firebase Auth or another backend service for login/signup.
                              // The following is a simulation of a network request.
                              await Future.delayed(
                                  const Duration(seconds: 1));
                              setState(() {
                                _loading = false;
                                // Placeholder error message.
                                _error = 'Auth not implemented.';
                              });
                            }
                          },
                    child: Text(_isLogin ? 'Login' : 'Sign Up'),
                  ),
                ),
                // Button to toggle between login and sign-up modes.
                TextButton(
                  onPressed: _loading
                      ? null
                      : () {
                          setState(() {
                            _isLogin = !_isLogin;
                            _error = null;
                          });
                        },
                  child: Text(_isLogin
                      ? 'Don\'t have an account? Sign Up'
                      : 'Already have an account? Login'),
                ),
              ],
            ),
          ),
        ),
      );
}
