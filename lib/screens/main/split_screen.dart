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
        {'title': 'Groceries', 'amount': 250.0, 'date': 'Nov 28', 'paidBy': 'Alex'},
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
        {'title': 'Rent a Car', 'amount': 2500.0, 'date': 'Nov 21', 'paidBy': 'Priya'},
        {'title': 'Food', 'amount': 1250.0, 'date': 'Nov 22', 'paidBy': 'Rahul'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    
    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      body: Column(
        children: [
          // Header with title and action buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Split Expenses',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.search, color: isDark ? Colors.white70 : Colors.grey[600]),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.notifications_none, color: isDark ? Colors.white70 : Colors.grey[600]),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Main Content
          Expanded(
            child: _buildGroupsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: _groups.length,
      itemBuilder: (context, index) {
        final group = _groups[index];
        final bool youOwe = group['youOwe'] > 0;
        final bool owesYou = group['owesYou'] > 0;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                // TODO: Navigate to group details
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Group Avatar
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.group,
                        color: Theme.of(context).primaryColor,
                        size: 28,
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Group Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            group['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${group['members']} members • ${group['transactions'].length} expenses',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Amount
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (youOwe)
                          Text(
                            '₹${group['youOwe'].toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        if (owesYou)
                          Text(
                            '₹${group['owesYou'].toStringAsFixed(0)}',
                            style: TextStyle(
                              color: Colors.green[600],
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        const SizedBox(height: 2),
                        Text(
                          youOwe ? 'You owe' : 'Owes you',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
