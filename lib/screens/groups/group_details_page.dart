import 'package:flutter/material.dart';
import 'package:paylent/models/constants.dart';
import 'package:paylent/screens/groups/tabs/expenses_tab.dart';

class GroupDetailsPage extends StatefulWidget {
  final Map<String, dynamic> group;
  final String imageUrl;
  const GroupDetailsPage(
      {required this.group, required this.imageUrl, super.key});

  @override
  State<GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage>
    with SingleTickerProviderStateMixin {
  late List<Map<String, dynamic>> transactions;
  late String groupTitle;
  late String imageUrl;
  late TabController _tabController;
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    groupTitle = widget.group['name'] ?? 'Group';
    imageUrl = widget.imageUrl;
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

  @override
  Widget build(final BuildContext context) => DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  // open menu / settings
                },
              ),
            ],
            title: Text(groupTitle),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(170), // image + tabs
              child: Column(
                children: [
                  /// 🖼️ Image just below title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        height: 90,
                        width: double.infinity,
                        fit: BoxFit.fill,
                        errorBuilder: (final _, final __, final ___) =>
                            Image.asset(
                          'assets/images/default_group.png',
                          height: 90,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// 💊 Pill tab bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: _PillTabBar(controller: _tabController),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              ExpensesTab(transactions: transactions),
              const _PlaceholderTab(title: 'Balances'),
              const _PlaceholderTab(title: 'Totals'),
              const _PlaceholderTab(title: 'Group Info'),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async  {
              final result = await Navigator.pushNamed(
                context,
                AppRoutes.addExpense,
              );

              if (result is Map<String, dynamic>) {
              setState(() {
                //widget.transactions[i] = result;
                transactions.add(result);
              });
            }
            },
            backgroundColor: Colors.blue,
            icon: const Icon(Icons.add, color: Colors.black),
            label: const Text(
              AppStrings.addExpense,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      );
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
  Widget build(final BuildContext context) => Container(
        height: 48,
        decoration: BoxDecoration(
          // color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(30),
        ),
        child: AnimatedBuilder(
          animation: widget.controller.animation!,
          builder: (final context, final _) {
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
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .18),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Tabs
                Row(
                  children: List.generate(tabs.length, (final i) {
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
                              color: selected
                                  ? Colors.black
                                  : Colors.grey.shade600,
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
