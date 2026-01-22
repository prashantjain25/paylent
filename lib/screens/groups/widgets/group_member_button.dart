import 'package:flutter/material.dart';
import 'package:paylent/models/group_model.dart';

class GroupMemberButton extends StatelessWidget {
  const GroupMemberButton({
    required this.group,
    super.key,
  });

  final Group group;

  @override
  Widget build(final BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(1.4), // ← border thickness
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              gradient: LinearGradient(
                colors: [
                  Colors.grey.shade400.withValues(alpha: .45),
                  Colors.grey.shade600.withValues(alpha: .35),
                  Colors.grey.shade300.withValues(alpha: .45),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              width: 80,
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              //margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade900.withValues(alpha: .62),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .18),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    group.participantIds.length == 1
                        ? '1 Member'
                        : '${group.participantIds.length} Members',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                        fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
