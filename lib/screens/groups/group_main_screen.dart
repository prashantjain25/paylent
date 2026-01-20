import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/models/group_model.dart';
import 'package:paylent/providers/groups_provider.dart';
import 'package:paylent/screens/groups/group_details_page.dart';
import 'package:paylent/screens/groups/group_tile.dart';
import 'package:paylent/screens/groups/new_group_screen.dart';

class SplitScreen extends ConsumerWidget {
  const SplitScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final groups = ref.watch(groupsProvider);

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
          const SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            floating: true,
            snap: true,
            toolbarHeight: 80,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
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

          /// ✅ Groups list from provider
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (final context, final index) {
                final Group group = groups[index];

                return GroupTile(
                  group: group,
                  //imageUrl: group.imageUrl, // 👈 computed in model
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (final _) => GroupDetailsPage(
                          group: group,
                        ),
                      ),
                    );
                  },
                );
              },
              childCount: groups.length,
            ),
          ),

          const SliverPadding(
            padding: EdgeInsets.only(bottom: 80),
          ),
        ],
      ),
    );
  }
}
