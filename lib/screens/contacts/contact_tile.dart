import 'package:flutter/material.dart';
import 'package:paylent/models/Contact.dart';

class ContactTile extends StatelessWidget {
  final Contact contact;
  final VoidCallback onTap;

  const ContactTile({required this.onTap, required this.contact, super.key});

  @override
  Widget build(final BuildContext context) => ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(contact.avatarUrl),
      ),
      title: Text(contact.name),
      subtitle: Text(contact.email),
      trailing: contact.isFavorite
          ? const Icon(Icons.star, color: Colors.amber)
          : null,
          onTap: () => onTap(),
    );
}
