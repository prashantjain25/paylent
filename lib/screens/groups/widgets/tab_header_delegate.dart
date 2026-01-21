import 'package:flutter/material.dart';
import 'package:paylent/screens/groups/widgets/pill_tab_bar.dart';

class TabHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final TabController tabController;
  final double scrollOffset;
  final double collapseExtent;

  TabHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.tabController,
    required this.scrollOffset,
    required this.collapseExtent,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    final BuildContext context,
    final double shrinkOffset,
    final bool overlapsContent,
  ) {
    final t = (shrinkOffset / (maxExtent - minHeight)).clamp(0.0, 1.0);

    // fade only in last 30% of collapse
    const fadeStart = 0.7;
    final opacity = t < fadeStart
        ? 1.0
        : (1 - (t - fadeStart) / (1 - fadeStart)).clamp(0.0, 1.0);

    if (opacity == 0) return const SizedBox.shrink();

    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: PillTabBar(controller: tabController),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant final SliverPersistentHeaderDelegate oldDelegate) => true;
}
