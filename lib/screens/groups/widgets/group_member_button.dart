import 'package:flutter/material.dart';
import 'package:paylent/screens/contacts/participants_selection_screen.dart';
import 'package:paylent/screens/groups/group_details_page.dart';


class GroupMemberButton extends StatelessWidget {
  const GroupMemberButton({
    required this.widget, super.key,
  });

  final GroupDetailsPage widget;

  @override
  Widget build(final BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () async {
            await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (final context) => ParticipantsScreen(),
                          ),
                        );
          },
          child: Opacity(
            opacity: .5,
            child: Container(
              width: 80,
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              //margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .18),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child:  Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(widget.members == 1
                        ? '1 Member'
                        : '${widget.members} Members',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                      fontSize: 12
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}