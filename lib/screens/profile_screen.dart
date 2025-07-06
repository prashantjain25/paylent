import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(final BuildContext context) => const Scaffold(
        body: Center(
          child: Text(
            'Profile Screen',
            style: TextStyle(fontSize: 24),
          ),
        ),
      );
}
