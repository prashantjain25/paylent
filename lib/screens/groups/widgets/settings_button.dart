import 'package:flutter/material.dart';
import 'package:paylent/models/group_model.dart';
import 'package:paylent/models/participants_screen_mode.dart';
import 'package:paylent/screens/contacts/participants_selection_screen.dart';

class SettingsButton extends StatelessWidget {
  final Group group;
  final BuildContext context;
  const SettingsButton({
    required this.group,
    required this.context,
    super.key,
  });

  @override
  Widget build(final BuildContext context) => Builder(
      builder: (final buttonContext) => IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () async {
              final RenderBox button =
                  buttonContext.findRenderObject() as RenderBox;
              final RenderBox overlay = Overlay.of(buttonContext)
                  .context
                  .findRenderObject() as RenderBox;

              final Offset buttonTopLeft =
                  button.localToGlobal(Offset.zero, ancestor: overlay);

              const double menuWidth = 180;

              await showMenu<void>(
                context: buttonContext,
                position: RelativeRect.fromLTRB(
                  buttonTopLeft.dx - menuWidth,
                  buttonTopLeft.dy,
                  overlay.size.width - buttonTopLeft.dx,
                  overlay.size.height - buttonTopLeft.dy,
                ),
                items: [
                  PopupMenuItem(
                    enabled: false,
                    child: ListTile(
                      leading: const Icon(Icons.person_add),
                      title: const Text('Add members'),
                      onTap: () async {
                        Navigator.pop(buttonContext);
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (final context) => ParticipantsScreen(
                              mode: ParticipantsScreenMode.editGroup,
                              groupId: group.id,
                            ),
                          ),
                        );
                        // Add members logic
                      },
                    ),
                  ),
                  PopupMenuItem(
                    enabled: false,
                    child: ListTile(
                      leading: const Icon(Icons.exit_to_app),
                      title: const Text('Exit group'),
                      onTap: () {
                        Navigator.pop(buttonContext);
                        // Exit group logic
                      },
                    ),
                  ),
                  PopupMenuItem(
                    enabled: false,
                    child: ListTile(
                      leading: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      title: const Text(
                        'Delete group',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () async {
                        Navigator.pop(buttonContext);
                        // Show confirmation dialog before delete
                        final bool? confirmed = await showDialog<bool>(
                          context: buttonContext,
                          barrierDismissible: false, // user must choose
                          builder: (final dialogContext) => AlertDialog(
                            title: const Text('Delete group?'),
                            content: const Text(
                              'This action cannot be undone. '
                              'All expenses and balances will be permanently removed.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext, false);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext, true);
                                },
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          // Delete group logic
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          ));
}
