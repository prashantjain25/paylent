import 'package:flutter/material.dart';
import 'package:paylent/models/Contact.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  int selectedTab = 0;
  final List<Contact> allContacts = [
    Contact(
      name: 'Alexia Hershey',
      email: 'alexia.hershey@gmail.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      isFavorite: true,
    ),
    Contact(
      name: 'Alfonzo Schuessler',
      email: 'alfonzo.schuessler@gmail.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=2',
    ),
    Contact(
      name: 'Augustina Midgett',
      email: 'augustina.midgett@gmail.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
    ),
    Contact(
      name: 'Charlotte Hanlin',
      email: 'charlotte.hanlin@gmail.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=4',
      isFavorite: true,
    ),
    Contact(
      name: 'Florencio Dorrance',
      email: 'florencio.dorrance@gmail.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      isFavorite: true,
    ),
  ];
  List<Contact> get filteredContacts {
    if (selectedTab == 1) {
      return allContacts.where((final c) => c.isFavorite).toList();
    }
    return allContacts;
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFF0F1115),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Contacts'),
          actions: const [
            Icon(Icons.more_vert),
            SizedBox(width: 8),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber,
          onPressed: () {
            // TODO: Add new contact
          },
          child: const Icon(Icons.add, color: Colors.black),
        ),
        body: Column(
          children: [
            _buildSearch(),
            _buildTabs(),
            Expanded(
              child: Stack(
                children: [
                  _buildContactList(),
                  _buildAlphabetIndex(),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildSearch() => Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
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

  Widget _buildTabs() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _tabButton('All Contacts', 0),
            const SizedBox(width: 12),
            _tabButton('Favorites', 1),
          ],
        ),
      );

  Widget _tabButton(final String text, final int index) {
    final isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.amber : const Color(0xFF1C1E22),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactList() => ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 48, 80),
        itemCount: filteredContacts.length,
        itemBuilder: (final context, final index) {
          final contact = filteredContacts[index];
          return _contactTile(contact);
        },
      );

  Widget _contactTile(final Contact contact) => ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 6),
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(contact.avatarUrl),
        ),
        title: Text(
          contact.name,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          contact.email,
          style: const TextStyle(color: Colors.white54),
        ),
        trailing: IconButton(
          icon: Icon(
            contact.isFavorite ? Icons.star : Icons.star_border,
            color: contact.isFavorite ? Colors.amber : Colors.white54,
          ),
          onPressed: () {
            setState(() {
              contact.isFavorite = !contact.isFavorite;
            });
          },
        ),
      );

  Widget _buildAlphabetIndex() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

    return Positioned(
      right: 6,
      top: 0,
      bottom: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: letters
            .split('')
            .map((final letter) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    letter,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white38,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
