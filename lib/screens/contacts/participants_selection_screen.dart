import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/models/contact_info.dart';
import 'package:paylent/providers/contacts_provider.dart';
import 'package:paylent/screens/contacts/contact_search_bar.dart';
import 'package:paylent/screens/contacts/widgets/contact_tile.dart';
import 'package:paylent/screens/contacts/participant_add_detail_screen.dart';
import 'package:paylent/screens/contacts/widgets/contacts_tabs.dart';

class ParticipantsScreen extends ConsumerStatefulWidget {
  //final String contactId;
  const ParticipantsScreen({super.key});

  @override
  ConsumerState<ParticipantsScreen> createState() => _ParticipantsScreenState();
}

class _ParticipantsScreenState extends ConsumerState<ParticipantsScreen> {
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

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Select Participants'),
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
              onTabChanged: (final tab) {
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
                        Scrollbar(
                          thumbVisibility: true,
                          child: ListView.builder(
                            itemCount: filteredContacts.length,
                            itemBuilder: (final _, final index) => ContactTile(
                              contact: filteredContacts[index],
                              onTap: () async {
                                await Navigator.push<String>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (final _) =>
                                        ParticipantDetailScreen(
                                            contactId:
                                                filteredContacts[index].id),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        _buildAlphabetIndex(),
                      ],
                    ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Handle save action
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    ),
  ),
      );
}
