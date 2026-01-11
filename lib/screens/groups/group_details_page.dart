import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:paylent/models/constants.dart';
import 'package:paylent/screens/groups/tabs/expenses_tab.dart';
import 'package:paylent/screens/groups/widgets/group_member_button.dart';
import 'package:paylent/screens/groups/widgets/pill_tab_bar.dart';

class GroupDetailsPage extends StatefulWidget {
  final Map<String, dynamic> group;
  final String imageUrl;
  final int members;
  const GroupDetailsPage(
      {required this.group,
      required this.imageUrl,
      required this.members,
      super.key});

  @override
  State<GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage>
    with SingleTickerProviderStateMixin {
  late List<Map<String, dynamic>> transactions;
  late String groupTitle;
  late String imageUrl;
  late TabController _tabController;
  late final ScrollController _scrollController;
  final TextEditingController _amountController = TextEditingController();

  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
        });
      });

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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    const double maxExtent = 120.0;
    final double t = (_scrollOffset / maxExtent).clamp(0.0, 1.0);

    final double titleOpacity = t;
    final double expandedTitleOpacity = 1 - t;
    final double blurSigma = 12 * t;
    final double tabOpacity = 1 - (t * 1.9).clamp(0.0, 1.0);

    print(
        'Scroll offset: $_scrollOffset, t: $t, titleOpacity: $titleOpacity, expandedTitleOpacity: $expandedTitleOpacity, blurSigma: $blurSigma, tabOpacityabOpacity');
    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (final context, final innerBoxIsScrolled) => [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                pinned: true,
                expandedHeight: maxExtent,
                // backgroundColor: Colors.amber,
                elevation: 0,

                /// Collapsed toolbar title
                title: Text(
                  groupTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                actions: [
                  Opacity(
                    opacity: tabOpacity,
                    child: GroupMemberButton(widget: widget),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () {
                      // Handle more options action
                    },
                  ),
                ],
                flexibleSpace: Stack(
                  fit: StackFit.expand,
                  children: [
                    /// Background image
                    ClipRRect(
                      // borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (final a, final b, final c) {
                          print('Error loading image: $b');
                          print('Stack trace: $c');
                          return Image.asset(
                            'assets/images/group-image.png',
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                   

                    if (blurSigma > 0)

                      /// Smooth blur layer
                      ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: blurSigma,
                            sigmaY: blurSigma,
                          ),
                          child: Container(
                            color: Colors.black.withOpacity(0.25 * t),
                          ),
                        ),
                      ), 
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Opacity(
                        opacity: tabOpacity, // Hide when title appears
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: PillTabBar(controller: _tabController),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: [
              ExpensesTab(transactions: transactions),
              const _PlaceholderTab(title: 'Balances'),
              const _PlaceholderTab(title: 'Totals'),
              const _PlaceholderTab(title: 'Group Info'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
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
