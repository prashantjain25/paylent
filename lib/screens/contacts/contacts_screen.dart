import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/models/contact_info.dart';
import 'package:paylent/providers/contacts_provider.dart';
import 'package:paylent/screens/contacts/contact_detail_screen.dart';
import 'package:paylent/screens/contacts/contact_search_bar.dart';
import 'package:paylent/screens/contacts/contact_tile.dart';
import 'package:paylent/screens/contacts/tab_button.dart';
import 'package:paylent/screens/contacts/widgets/contacts_tabs.dart';

class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  int _selectedTab = 0; // 0 = All, 1 = Favorites
  String _searchQuery = '';

  List<Contact> get filteredContacts {
    final allContacts = ref.watch(contactsProvider);
    return Contact.filter(
      allContacts: allContacts,
      searchQuery: _searchQuery,
      selectedTab: _selectedTab,
    );
  }

  Future<void> _openDetail(final String contactId) async {
    await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (final _) => ContactDetailScreen(contactId: contactId),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Contacts')),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {
                // Handle add contact action
              },
            )
          ],
        ),
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
            ContactsTabs(
              selectedTab: _selectedTab,
              onTabChanged: (tab) {
                setState(() {
                  _selectedTab = tab;
                });
              },
            ),
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
              onTap: () => _openDetail(filteredContacts[index].id)),
        ),
      );
}
