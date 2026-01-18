import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/models/contact_info.dart';
import 'package:paylent/providers/selected_participants_provider.dart';

class ParticipantContactTile extends ConsumerWidget {
  final Contact contact;

  const ParticipantContactTile({required this.contact, super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final selectedIds = ref.watch(selectedParticipantsProvider);
    final isSelected = selectedIds.contains(contact.id);

    return InkWell(
      onTap: () {
        ref
            .read(selectedParticipantsProvider.notifier)
            .toggle(contact.id);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(contact.avatarUrl),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    contact.email,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
