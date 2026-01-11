import 'package:flutter/material.dart';
import 'package:paylent/screens/contacts/widgets/tab_button.dart';

class ContactsTabs extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  const ContactsTabs({
    required this.selectedTab, required this.onTabChanged, super.key,
  });

  @override
  Widget build(final BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TabButton(
              label: 'All Contacts',
              active: selectedTab == 0,
              onTap: () => onTabChanged(0),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TabButton(
              label: 'Favorites',
              active: selectedTab == 1,
              onTap: () => onTabChanged(1),
            ),
          ),
        ],
      ),
    );
}
