import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/models/contact_info.dart';
import 'package:paylent/providers/contacts_provider.dart';

class ParticipantDetailScreen extends ConsumerStatefulWidget {
  final String contactId;

  const ParticipantDetailScreen({required this.contactId, super.key});

  @override
  ConsumerState<ParticipantDetailScreen> createState() =>
      _ContactDetailScreenState();
}

class _ContactDetailScreenState extends ConsumerState<ParticipantDetailScreen> {
  late Contact _edited;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final contact =
        ref.read(contactsProvider.notifier).getById(widget.contactId);

    _edited = contact.copy();
  }

  bool get _hasChanges {
    final byId = ref.read(contactsProvider.notifier).getById(widget.contactId);
    return _edited.name != byId.name || _edited.email != byId.email;
  }

  Future<bool> _showConfirmDialog() async {
    if (!_hasChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (final _) => AlertDialog(
        title: const Text('Confirm update'),
        content:
            const Text('Are you sure you want to update the contact details?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<void> _handleSave() async {
    final confirmed = await _showConfirmDialog();
    if (!confirmed) return;

    ref.read(contactsProvider.notifier).update(_edited);
    Navigator.pop(context, _edited);
  }


  Future<void> _delete() async {
    ref.read(contactsProvider.notifier).delete(widget.contactId);
    Navigator.pop(context, widget.contactId);
  }

  Future<bool> _confirmLeave() async {
    if (!_hasChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (final _) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('You have unsaved changes. Do you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(final BuildContext context) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (final didPop, final _) async {
          if (didPop) return;

          final canLeave = await _confirmLeave();
          if (!mounted) return;

          if (canLeave) {
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Contact'),
            leading: const BackButton(),
            actions: [
              Icon(
                Icons.star,
                color: _edited.isFavorite ? Colors.amber : Colors.grey,
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: Column(
            children: [
              const SizedBox(height: 40),

              /// DOUBLE TAP IMAGE
              GestureDetector(
                onDoubleTap: () => setState(() => _isEditing = true),
                child: CircleAvatar(
                  radius: 48,
                  backgroundImage: NetworkImage(_edited.avatarUrl),
                ),
              ),

              const SizedBox(height: 16),

              /// NAME
              GestureDetector(
                onDoubleTap: () => setState(() => _isEditing = true),
                child: _isEditing
                    ? TextField(
                        controller: TextEditingController(text: _edited.name),
                        onChanged: (final v) => _edited.name = v,
                      )
                    : Text(
                        _edited.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
              ),

              const SizedBox(height: 8),

              /// EMAIL
              GestureDetector(
                onDoubleTap: () => setState(() => _isEditing = true),
                child: _isEditing
                    ? TextField(
                        controller: TextEditingController(text: _edited.email),
                        onChanged: (final v) => _edited.email = v,
                      )
                    : Text(
                        _edited.email,
                        style: const TextStyle(color: Colors.grey),
                      ),
              ),

              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 32),

              /// SAVE BUTTON
              if (_isEditing)
                ElevatedButton(
                  onPressed: _handleSave,
                  child: const Text('Save Changes'),
                ),

              const SizedBox(height: 12),

              /// DELETE BUTTON
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
                onPressed: _delete,
                child: const Text('Delete Contact'),
              ),
            ],
          ),
        ),
      );
}
