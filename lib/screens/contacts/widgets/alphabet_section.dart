import 'package:flutter/material.dart';
import 'package:paylent/models/contact_info.dart';

class AlphabetSection extends StatelessWidget {
  final String letter;
  final List<Contact> contacts;

  /// 👇 Inject how each contact should be rendered
  final Widget Function(Contact contact) itemBuilder;

  const AlphabetSection({
    required this.letter, required this.contacts, required this.itemBuilder, super.key,
  });

  /// Factory that creates sections from contacts
  static List<AlphabetSection> fromContacts({
    required final List<Contact> contacts,
    required final Widget Function(Contact contact) itemBuilder,
  }) {
    final Map<String, List<Contact>> grouped = {};

    for (final contact in contacts) {
      if (contact.name.isEmpty) continue;
      final letter = contact.name[0].toUpperCase();
      grouped.putIfAbsent(letter, () => []).add(contact);
    }

    final sortedKeys = grouped.keys.toList()..sort();

    return [
      for (final key in sortedKeys)
        AlphabetSection(
          letter: key,
          contacts: grouped[key]!,
          itemBuilder: itemBuilder,
        ),
    ];
  }

  @override
  Widget build(final BuildContext context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔤 Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.black.withAlpha(51),
          child: Text(
            letter,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
        ),

        /// 👥 Contacts under this letter
        ...contacts.map(itemBuilder),
      ],
    );
}