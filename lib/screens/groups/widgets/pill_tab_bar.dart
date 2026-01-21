import 'package:flutter/material.dart';

class PillTabBar extends StatefulWidget {
  final TabController controller;

  const PillTabBar({required this.controller, super.key});

  @override
  State<PillTabBar> createState() => _PillTabBarState();
}

class _PillTabBarState extends State<PillTabBar> {
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
                              color: selected ? Colors.black : Colors.white70,
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