// widgets/selected_participants_row.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/providers/contacts_provider.dart';
import 'package:paylent/providers/selected_participants_provider.dart';

class SelectedParticipantsRow extends ConsumerWidget {
  const SelectedParticipantsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIds = ref.watch(selectedParticipantsProvider);
    final contacts = ref.watch(contactsProvider);

    if (selectedIds.isEmpty) return const SizedBox.shrink();

    final selectedContacts =
        contacts.where((c) => selectedIds.contains(c.id)).toList();

    return SizedBox(
      height: 64,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: selectedContacts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final contact = selectedContacts[index];

          return Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundImage: NetworkImage(contact.avatarUrl),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.check,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
