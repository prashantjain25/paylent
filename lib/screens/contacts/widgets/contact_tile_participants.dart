
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/models/contact_info.dart';
import 'package:paylent/providers/selected_participants_provider.dart';

class ContactParticipantTile extends ConsumerWidget {
  final Contact contact;
  final VoidCallback onTap;

  const ContactParticipantTile({
    required this.contact, required this.onTap, super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final selectedIds = ref.watch(allContactsListProvider);
    final isSelected = selectedIds.contains(contact.id);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(contact.avatarUrl),
      ),
      title: Text(contact.name),
      subtitle: Text(contact.email),
      trailing: isSelected
          ? const Icon(Icons.check, color: Colors.green)
          : null,
      onTap: onTap,
    );
  }
}
