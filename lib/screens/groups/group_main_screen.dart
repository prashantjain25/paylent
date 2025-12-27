import 'package:flutter/material.dart';
import 'package:paylent/models/constants.dart';
import 'package:paylent/screens/groups/group_details_page.dart';
import 'package:paylent/screens/groups/group_tile.dart';
import 'package:paylent/screens/groups/new_group_screen.dart';

class SplitScreen extends StatefulWidget {
  const SplitScreen({super.key});

  @override
  State<SplitScreen> createState() => _SplitScreenState();
}

class _SplitScreenState extends State<SplitScreen> {
  final List<Map<String, dynamic>> _groups = [
    {
      'name': 'Roommates',
      'members': 4,
      'amount': 1250.0,
      'youOwe': 250.0,
      'owesYou': 0.0,
      'transactions': [
        {'title': 'Rent', 'amount': 1000.0, 'date': 'Nov 25', 'paidBy': 'You'},
        {
          'title': 'Groceries',
          'amount': 250.0,
          'date': 'Nov 28',
          'paidBy': 'Alex'
        },
      ],
    },
    {
      'name': 'Trip to Goa',
      'members': 6,
      'amount': 8750.0,
      'youOwe': 0.0,
      'owesYou': 1250.0,
      'transactions': [
        {'title': 'Hotel', 'amount': 5000.0, 'date': 'Nov 20', 'paidBy': 'You'},
        {
          'title': 'Rent a Car',
          'amount': 2500.0,
          'date': 'Nov 21',
          'paidBy': 'Priya'
        },
        {
          'title': 'Food',
          'amount': 1250.0,
          'date': 'Nov 22',
          'paidBy': 'Rahul'
        },
      ],
    },
  ];

  String _imageUrlFor(final Map<String, dynamic> group) =>
      'https://picsum.photos/seed/${Uri.encodeComponent(group['name'])}/120/80';

  @override
  Widget build(final BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
        backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (final _) => const NewGroupScreen(),
              ),
            );
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add, color: Colors.black),
        ),
        body: CustomScrollView(
          slivers: [
            // SliverAppBar behaves like the "Groups" heading in screenshot.
            const SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              // make the header float (reappear when scrolling up)
              floating: true,
              // snap makes it pop into view immediately when scrolling up
              snap: true,
              // pinned: false so it scrolls away when scrolled down
              // You can adjust toolbar height to match your design
              toolbarHeight: 80,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                title: Text(
                  'Groups',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                centerTitle: true,
              ),
            ),

            // The scrolling list of group items
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (final context, final index) {
                  final group = _groups[index];
                  final url = _imageUrlFor(group);
                  return GroupTile(
                    group: group,
                    // use seed from name to create stable placeholder image
                    imageUrl: url,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (final _) =>
                              GroupDetailsPage(group: group, imageUrl: url),
                        ),
                      );
                    },
                  );
                },
                childCount: _groups.length,
              ),
            ),

            // optional padded space at bottom so FAB doesn't overlap last item
            const SliverPadding(
              padding: EdgeInsets.only(bottom: 80),
            ),
          ],
        ));
  }
}
