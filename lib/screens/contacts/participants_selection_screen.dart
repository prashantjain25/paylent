import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/models/contact_info.dart';
import 'package:paylent/providers/contacts_provider.dart';
import 'package:paylent/providers/selected_participants_provider.dart';
import 'package:paylent/screens/contacts/contact_search_bar.dart';
import 'package:paylent/screens/contacts/widgets/contacts_tabs.dart';
import 'package:paylent/screens/contacts/widgets/participant_contact_tile.dart';
import 'package:paylent/screens/contacts/widgets/selected_participants_row.dart';

class ParticipantsScreen extends ConsumerStatefulWidget {
  const ParticipantsScreen({super.key});

  @override
  ConsumerState<ParticipantsScreen> createState() => _ParticipantsScreenState();
}

class _ParticipantsScreenState extends ConsumerState<ParticipantsScreen> {
  int _selectedTab = 0;
  String _searchQuery = '';

    List<Contact> get filteredContacts {
    final allContacts = ref.watch(contactsProvider);
    return Contact.filter(
      allContacts: allContacts,
      searchQuery: _searchQuery,
      selectedTab: _selectedTab,
    );
  }
  
  @override
  Widget build(final BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Select Participants'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ContactSearchBar(
            onChanged: (final value) {
              setState(() => _searchQuery = value);
            },
          ),
          const SelectedParticipantsRow(),
          const SizedBox(height: 8),
          ContactsTabs(
            selectedTab: _selectedTab,
            onTabChanged: (final tab) {
              setState(() => _selectedTab = tab);
            },
          ),

          const SizedBox(height: 8),

          Expanded(
            child: ListView.builder(
              itemCount: filteredContacts.length,
              itemBuilder: (final _, final index) => ParticipantContactTile(
                contact: filteredContacts[index],
              ),
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
                  onPressed: () {
                    ref.read(selectedParticipantsProvider.notifier).clear();
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(selectedParticipantsProvider);
                    // handle save
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
