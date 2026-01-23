import 'package:flutter/material.dart';

class SplitBySelectionScreen extends StatelessWidget {
  final String selectedValue;

  const SplitBySelectionScreen({
    required this.selectedValue,
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    final options = ['Equally', 'Unequally', 'By percentage'];

    return Scaffold(
      appBar: AppBar(title: const Text('Split by')),
      body: ListView(
        children: options.map((final option) {
          final isSelected = option == selectedValue;

          return ListTile(
            title: Text(option),
            trailing: isSelected
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () {
              Navigator.pop(context, option);
            },
          );
        }).toList(),
      ),
    );
  }
}
