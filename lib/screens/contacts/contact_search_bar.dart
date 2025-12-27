import 'package:flutter/material.dart';

class ContactSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const ContactSearchBar({
    required this.onChanged, super.key,
  });

  @override
  Widget build(final BuildContext context) => Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search contact',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: const Color(0xFF1C1E22),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
}
