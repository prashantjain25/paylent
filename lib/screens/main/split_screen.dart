import 'package:flutter/material.dart';
import 'package:paylent/constants.dart';
import 'package:paylent/glassmorphism_widgets.dart';

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
        backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
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
                (context, index) {
                  final group = _groups[index];
                  return _GroupTile(
                    group: group,
                    // use seed from name to create stable placeholder image
                    imageUrl:
                        'https://picsum.photos/seed/${Uri.encodeComponent(group['name'])}/120/80',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => GroupDetailsPage(group: group),
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

class _GroupTile extends StatelessWidget {
  final Map<String, dynamic> group;
  final String imageUrl;
  final VoidCallback? onTap;

  const _GroupTile({
    required this.group,
    required this.imageUrl,
    this.onTap,
  });

  // Build a stack of simple avatars based on member count.
  // Because your data provides only a count, we use numbers (1,2,3...) as placeholders.
  Widget _buildAvatarStack(int membersCount) {
    const double radius = 14;
    const double overlap = 8;
    final int shown = membersCount.clamp(0, 6);
    final List<Widget> avatars = [];

    for (var i = 0; i < shown; i++) {
      avatars.add(Positioned(
        left: i * (radius * 2 - overlap),
        child: CircleAvatar(
          radius: radius,
          // minimal placeholder: show 1..6 numbers
          child: Text(
            '${i + 1}',
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ));
    }

    // width calculation: same as before but using shown
    final double width =
        (shown * (radius * 2)) - (overlap * (shown - 1).clamp(0, shown));
    return SizedBox(
      width: width,
      height: radius * 2,
      child: Stack(children: avatars),
    );
  }

  Widget _buildOweBadge(BuildContext context, double youOwe, double owesYou) {
    if (youOwe > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('\$${youOwe.toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('You owe', style: Theme.of(context).textTheme.bodySmall),
        ],
      );
    } else if (owesYou > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('\$${owesYou.toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('Owes you', style: Theme.of(context).textTheme.bodySmall),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String title = group['name'] as String? ?? 'Group';
    final int membersCount = group['members'] as int? ?? 0;
    final double amount = (group['amount'] as num?)?.toDouble() ?? 0.0;
    final double youOwe = (group['youOwe'] as num?)?.toDouble() ?? 0.0;
    final double owesYou = (group['owesYou'] as num?)?.toDouble() ?? 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF16171A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(6),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            width: 72,
            height: 72,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(width: 72, height: 72, color: Colors.grey),
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAvatarStack(membersCount),
              const SizedBox(width: 8),

              // Make text area flexible so it can shrink when space is tight.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // the "x members" line
                    Text(
                      '$membersCount members',
                      style: const TextStyle(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // optional second line for amount (small)
                    const SizedBox(height: 4),
                    Text(
                      '• \$${amount.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        trailing: Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class GroupDetailsPage extends StatelessWidget {
  final Map<String, dynamic> group;
  const GroupDetailsPage({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final String title = group['name'] as String? ?? 'Group';
    final List transactions = group['transactions'] as List? ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: transactions.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, i) {
          final tx = transactions[i] as Map<String, dynamic>;
          final txTitle = tx['title'] ?? '';
          final txAmount = (tx['amount'] as num?)?.toDouble() ?? 0.0;
          final txDate = tx['date'] ?? '';
          final paidBy = tx['paidBy'] ?? '';

          return ListTile(
            leading: CircleAvatar(
                child: Text(txTitle.isNotEmpty ? txTitle[0] : '?')),
            title: Text(txTitle),
            subtitle: Text('$txDate • paid by $paidBy'),
            trailing: Text('\$${txAmount.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          );
        },
      ),
    );
  }
}
