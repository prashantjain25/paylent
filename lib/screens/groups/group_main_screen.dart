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
      GroupKeys.name: 'Roommates',
      GroupKeys.members: 4,
      GroupKeys.amount: 1250.0,
      GroupKeys.youOwe: 250.0,
      GroupKeys.owesYou: 0.0,
      GroupKeys.transactions: [
        {
          TransactionKeys.id: 1,
          TransactionKeys.title: 'Rent',
          TransactionKeys.amount: 1000.0,
          TransactionKeys.date: 'Nov 25',
          TransactionKeys.paidBy: 'You',
          TransactionKeys.code: 'USD'
        },
        {
          TransactionKeys.id: 2,
          TransactionKeys.title: 'Groceries',
          TransactionKeys.amount: 250.0,
          TransactionKeys.date: 'Nov 28',
          TransactionKeys.paidBy: 'Alex',
          TransactionKeys.code: 'USD'
        },
      ],
    },
    {
      GroupKeys.name: 'Trip to Goa',
      GroupKeys.members: 6,
      GroupKeys.amount: 8750.0,
      GroupKeys.youOwe: 0.0,
      GroupKeys.owesYou: 1250.0,
      GroupKeys.transactions: [
        {
          TransactionKeys.id: 1,
          TransactionKeys.title: 'Hotel',
          TransactionKeys.amount: 5000.0,
          TransactionKeys.date: 'Nov 20',
          TransactionKeys.paidBy: 'You',
          TransactionKeys.code: 'USD'
        },
        {
          TransactionKeys.id: 2,
          TransactionKeys.title: 'Rent a Car',
          TransactionKeys.amount: 2500.0,
          TransactionKeys.date: 'Nov 21',
          TransactionKeys.paidBy: 'Priya',
          TransactionKeys.code: 'USD'
        },
        {
          TransactionKeys.id: 3,
          TransactionKeys.title: 'Food',
          TransactionKeys.amount: 1250.0,
          TransactionKeys.date: 'Nov 22',
          TransactionKeys.paidBy: 'Rahul',
          TransactionKeys.code: 'USD'
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
                              GroupDetailsPage(group: group, imageUrl: url, members: group[GroupKeys.members] as int),
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
