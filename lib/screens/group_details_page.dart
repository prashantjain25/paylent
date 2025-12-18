import 'package:flutter/material.dart';

class GroupDetailsPage extends StatefulWidget {
  final Map<String, dynamic> group;
  const GroupDetailsPage({super.key, required this.group});

  @override
  State<GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage>
    with SingleTickerProviderStateMixin {
  late List<Map<String, dynamic>> transactions;
  late String groupTitle;
  late TabController _tabController;
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    groupTitle = widget.group['name'] ?? 'Group';

    transactions = List<Map<String, dynamic>>.from(
      widget.group['transactions'] ?? [],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (final _) => AlertDialog(
        title: const Text('Add Expense'),
        content: TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Amount',
            prefixText: '\$ ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(_amountController.text);
              if (amount == null) return;

              setState(() {
                transactions.add({
                  'title': 'New Expense',
                  'amount': amount,
                  'paidBy': 'You',
                  'date': 'Today',
                });
              });

              _amountController.clear();
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(final BuildContext context) => DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text(groupTitle),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: _PillTabBar(controller: _tabController),
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _ExpensesTab(transactions: transactions),
              const _PlaceholderTab(title: 'Balances'),
              const _PlaceholderTab(title: 'Totals'),
              const _PlaceholderTab(title: 'Group Info'),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _showAddExpenseDialog,
            backgroundColor: Colors.amber,
            icon: const Icon(Icons.add, color: Colors.black),
            label: const Text(
              'Add Expense',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      );
}

class _ExpensesTab extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;

  const _ExpensesTab({required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(
        child: Text(
          'No expenses yet',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: transactions.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, i) {
        final tx = transactions[i];

        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.orange,
            child: Icon(Icons.receipt, color: Colors.white),
          ),
          title: Text(tx['title']),
          subtitle: Text('Paid by ${tx['paidBy']}'),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${tx['amount'].toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Today',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String title;

  const _PlaceholderTab({required this.title});

  @override
  Widget build(final BuildContext context) => Center(
      child: Text(
        '$title coming soon',
        style: const TextStyle(color: Colors.grey),
      ),
    );
}

class _PillTabBar extends StatefulWidget {
  final TabController controller;

  const _PillTabBar({required this.controller});

  @override
  State<_PillTabBar> createState() => _PillTabBarState();
}

class _PillTabBarState extends State<_PillTabBar> {
  final tabs = const ['Expenses', 'Balances', 'Totals', 'Group'];

  @override
  Widget build(final BuildContext context) =>
     Container(
      height: 48,
      decoration: BoxDecoration(
       // color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: AnimatedBuilder(
        animation: widget.controller.animation!,
        builder: (context, _) {
          final index = widget.controller.index;
          final tabWidth =
              (MediaQuery.of(context).size.width - 24) / tabs.length;

          return Stack(
            children: [
              /// 🔥 Moving pill with shadow
              AnimatedPositioned(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                left: index * tabWidth,
                top: 0,
                bottom: 0,
                width: tabWidth,
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),

              /// Tabs
              Row(
                children: List.generate(tabs.length, (i) {
                  final selected = widget.controller.index == i;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        widget.controller.animateTo(i);
                      },
                      child: Center(
                        child: Text(
                          tabs[i],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color:
                                selected ? Colors.black : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  
}
