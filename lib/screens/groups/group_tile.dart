import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/models/group_model.dart';
import 'package:paylent/providers/transaction_derived_providers.dart';

class GroupTile extends ConsumerWidget {
  final Group group;
  final VoidCallback? onTap;

  const GroupTile({
    required this.group, super.key,
    this.onTap,
  });

  /// Build stacked avatars based on participant count
  // Widget _buildAvatarStack(final int membersCount) {
  //   const double radius = 14;
  //   const double overlap = 8;

  //   final int shown = membersCount.clamp(0, 6);
  //   final List<Widget> avatars = [];

  //   for (var i = 0; i < shown; i++) {
  //     avatars.add(
  //       Positioned(
  //         left: i * (radius * 2 - overlap),
  //         child: CircleAvatar(
  //           radius: radius,
  //           child: Text(
  //             '${i + 1}',
  //             style: const TextStyle(fontSize: 12),
  //           ),
  //         ),
  //       ),
  //     );
  //   }

  //   final double width =
  //       (shown * (radius * 2)) - (overlap * (shown - 1).clamp(0, shown));

  //   return SizedBox(
  //     width: width,
  //     height: radius * 2,
  //     child: Stack(children: avatars),
  //   );
  // }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final int membersCount = group.participantIds.length;
    final totalAmount = ref.watch(groupTotalAmountProvider(group.id));

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
            group.imageUrl, 
            width: 72,
            height: 72,
            fit: BoxFit.cover,
            errorBuilder: (final _, final __, final ___) => Container(
              width: 72,
              height: 72,
              color: Colors.grey,
            ),
          ),
        ),
        title: Text(
          group.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Row(
            children: [
              Text(
                '$membersCount Participants',
                style: const TextStyle(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 8),
                Text(
                       '• \$${totalAmount.toStringAsFixed(0)}',
                       style: const TextStyle(fontSize: 12),
                       maxLines: 1,
                       overflow: TextOverflow.ellipsis,
                   ),
            ],
              //_buildAvatarStack(membersCount),
            //],
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
