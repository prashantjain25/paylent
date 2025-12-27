import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GroupTile extends StatelessWidget {
  final Map<String, dynamic> group;
  final String imageUrl;
  final VoidCallback? onTap;

  const GroupTile({
    required this.group,
    required this.imageUrl,
    this.onTap,
    super.key,
  });

  // Build a stack of simple avatars based on member count.
  // Because your data provides only a count, we use numbers (1,2,3...) as placeholders.
  Widget _buildAvatarStack(final int membersCount) {
    const double radius = 14;
    const double overlap = 8;
    final int shown = membersCount.clamp(0, 6);
    final List<Widget> avatars = [];

    for (var i = 0; i < shown; i++) {
      avatars.add(Positioned(
        left: i * (radius * 2 - overlap),
        child: CircleAvatar(
          radius: radius,
          // minimal placeholder: show 1..6 numbers
          child: Text(
            '${i + 1}',
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ));
    }

    // width calculation: same as before but using shown
    final double width =
        (shown * (radius * 2)) - (overlap * (shown - 1).clamp(0, shown));
    return SizedBox(
      width: width,
      height: radius * 2,
      child: Stack(children: avatars),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final String title = group['name'] as String? ?? 'Group';
    final int membersCount = group['members'] as int? ?? 0;
    final double amount = (group['amount'] as num?)?.toDouble() ?? 0.0;
    final double youOwe = (group['youOwe'] as num?)?.toDouble() ?? 0.0;
    final double owesYou = (group['owesYou'] as num?)?.toDouble() ?? 0.0;

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
            imageUrl,
            width: 72,
            height: 72,
            fit: BoxFit.cover,
            // loadingBuilder:
            //     (final context, final child, final loadingProgress) {
            //   if (loadingProgress == null) return child;

            //   return Center(
            //     child: LoadingAnimationWidget.threeArchedCircle(
            //       color: const Color.fromARGB(255, 241, 242, 243),
            //       size: 26,
            //     ),
            //   );
            // },
            errorBuilder: (final _, final __, final ___) =>
                Container(width: 72, height: 72, color: Colors.grey),
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Row(
            children: [
              _buildAvatarStack(membersCount),
              const SizedBox(width: 8),

              // Make text area flexible so it can shrink when space is tight.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // the "x members" line
                    Text(
                      '$membersCount members',
                      style: const TextStyle(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // optional second line for amount (small)
                    const SizedBox(height: 4),
                    Text(
                      '• \$${amount.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
