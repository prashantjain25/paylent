import 'package:flutter/material.dart';
import 'package:paylent/models/Contact.dart';
import 'package:paylent/screens/contacts/contact_detail_screen.dart';
import 'package:paylent/screens/contacts/contact_search_bar.dart';
import 'package:paylent/screens/contacts/contact_tile.dart';
import 'package:paylent/screens/contacts/tab_button.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  int _selectedTab = 0; // 0 = All, 1 = Favorites
  String _searchQuery = '';

  // 🔹 Source of truth
  final List<Contact> allContacts = [
    Contact(
      id: '1',
      name: 'Alexia Hershey',
      email: 'alexia.hershey@gmail.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      isFavorite: true,
    ),
    Contact(
      id: '2',
      name: 'Alfonzo Schuessler',
      email: 'alfonzo.schuessler@gmail.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=2',
    ),
    Contact(
      id: '3',
      name: 'Augustina Midgett',
      email: 'augustina.midgett@gmail.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
    ),
    Contact(
      id: '4',
      name: 'Charlotte Hanlin',
      email: 'charlotte.hanlin@gmail.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=4',
      isFavorite: true,
    ),
    Contact(
      id: '5',
      name: 'Florencio Dorrance',
      email: 'florencio.dorrance@gmail.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      isFavorite: true,
    ),
  ];

  List<Contact> get filteredContacts => allContacts.where((final contact) {
        final matchesSearch =
            contact.name.toLowerCase().contains(_searchQuery) ||
                contact.email.toLowerCase().contains(_searchQuery);

        final matchesTab = _selectedTab == 0 || contact.isFavorite;

        return matchesSearch && matchesTab;
      }).toList();

  Future<void> _openDetail(Contact contact) async {
    final deletedId = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => ContactDetailScreen(contact: contact),
      ),
    );

    if (deletedId != null) {
      setState(() {
        allContacts.removeWhere((c) => c.id == deletedId);
      });
    }
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Contacts')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            ContactSearchBar(
              onChanged: (final value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
            _buildTabs(),
            const SizedBox(height: 12),
            Expanded(
              child: filteredContacts.isEmpty
                  ? const Center(child: Text('No contacts found'))
                  : Stack(
                      children: [
                        _buildContactList(),
                        _buildAlphabetIndex(),
                      ],
                    ),
            ),
          ],
        ),
      );

  Widget _buildTabs() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: TabButton(
                label: 'All Contacts',
                active: _selectedTab == 0,
                onTap: () => setState(() => _selectedTab = 0),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TabButton(
                label: 'Favorites',
                active: _selectedTab == 1,
                onTap: () => setState(() => _selectedTab = 1),
              ),
            ),
          ],
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

  Widget _buildContactList() => Scrollbar(
        thumbVisibility: true,
        child: ListView.builder(
          itemCount: filteredContacts.length,
          itemBuilder: (final _, final index) => ContactTile(
              contact: filteredContacts[index],
              onTap: () => _openDetail(filteredContacts[index])),
        ),
      );
}
