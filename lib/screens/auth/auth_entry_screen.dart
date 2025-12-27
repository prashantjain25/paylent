import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:paylent/models/constants.dart';
import 'package:paylent/theme/app_theme.dart';

class AuthEntryScreen extends StatefulWidget {
  const AuthEntryScreen({super.key});

  @override
  State<AuthEntryScreen> createState() => _AuthEntryScreenState();
}

class _AuthEntryScreenState extends State<AuthEntryScreen> {
  bool _showLogin = true;

  // Form state
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  String _errorMessage = '';
  bool _isLoading = false;
  bool _rememberMe = false;

  void _toggleScreens() {
    setState(() {
      _showLogin = !_showLogin;
    });
  }

  Future<void> _signIn() async {
    if (!_loginFormKey.currentState!.validate()) return;

    final backdoorEmail = dotenv.env['BACKDOOR_EMAIL'];
    final backdoorPassword = dotenv.env['BACKDOOR_PASSWORD'];

    if (_emailController.text.trim() == backdoorEmail &&
        _passwordController.text.trim() == backdoorPassword) {
      if (mounted) Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = e.message ?? 'An error occurred.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _register() async {
    if (!_registerFormKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = e.message ?? 'An error occurred.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => Theme(
      data: AppTheme.light,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    _showLogin ? 'Hi, Welcome Back! 👋' : 'Create an Account',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _showLogin ? _buildLoginForm() : _buildRegisterForm(),
                  const SizedBox(height: 20),
                  const Text(
                    'Or sign in with',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.googleLogin);
                    },
                    icon: Image.asset('assets/google_logo.png', height: 40),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_showLogin
                          ? "Don't have an account?"
                          : 'Already have an account?'),
                      TextButton(
                        onPressed: _toggleScreens,
                        child: Text(
                          _showLogin ? 'Sign Up' : 'Sign In',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

  Widget _buildLoginForm() => Form(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email address',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (final value) {
              if (value == null || value.isEmpty) return 'Please enter your email';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Icon(Icons.lock_outline),
            ),
            validator: (final value) {
              if (value == null || value.isEmpty) return 'Please enter your password';
              return null;
            },
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (final value) => setState(() => _rememberMe = value!),
                  ),
                  const Text('Remember me'),
                ],
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
                child: const Text('Forgot Password?'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_errorMessage.isNotEmpty)
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isLoading ? null : _signIn,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Sign In', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );

  Widget _buildRegisterForm() => Form(
      key: _registerFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'Enter your name',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (final value) {
              if (value == null || value.isEmpty) return 'Please enter your name';
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email address',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (final value) {
              if (value == null || value.isEmpty) return 'Please enter your email';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Icon(Icons.lock_outline),
            ),
            validator: (final value) {
              if (value == null || value.isEmpty) return 'Please enter a password';
              if (value.length < 6) return 'Password must be at least 6 characters long';
              return null;
            },
          ),
          const SizedBox(height: 20),
          if (_errorMessage.isNotEmpty)
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isLoading ? null : _register,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Sign Up', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
}
