import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const TabButton({required this.label, required this.active, required this.onTap, super.key,
  });

  @override
  Widget build(final BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: active ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
}
