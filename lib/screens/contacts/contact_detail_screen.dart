import 'package:flutter/material.dart';
import 'package:paylent/models/Contact.dart';

class ContactDetailScreen extends StatefulWidget {
  final Contact contact;

  const ContactDetailScreen({required this.contact, super.key});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  late Contact _editedContact;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _editedContact = widget.contact.copy(); // IMPORTANT
  }

  bool get _hasChanges =>
      _editedContact.name != widget.contact.name ||
      _editedContact.email != widget.contact.email;

  Future<bool> _showConfirmDialog() async {
    if (!_hasChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm update'),
        content: const Text(
            'Are you sure you want to update the contact details?'),
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

    Navigator.pop(context, _editedContact);
  }

  Future<bool> _handleBack() async {
    final confirmed = await _showConfirmDialog();
    return confirmed;
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: _handleBack,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Contact'),
            leading: BackButton(
              onPressed: () async {
                final canPop = await _handleBack();
                if (canPop) Navigator.pop(context);
              },
            ),
            actions: [
              Icon(
                Icons.star,
                color: _editedContact.isFavorite
                    ? Colors.amber
                    : Colors.grey,
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
                  backgroundImage:
                      NetworkImage(_editedContact.avatarUrl),
                ),
              ),

              const SizedBox(height: 16),

              /// NAME
              GestureDetector(
                onDoubleTap: () => setState(() => _isEditing = true),
                child: _isEditing
                    ? TextField(
                        controller: TextEditingController(
                            text: _editedContact.name),
                        onChanged: (v) => _editedContact.name = v,
                      )
                    : Text(
                        _editedContact.name,
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
                        controller: TextEditingController(
                            text: _editedContact.email),
                        onChanged: (v) => _editedContact.email = v,
                      )
                    : Text(
                        _editedContact.email,
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
                onPressed: () {
                  Navigator.pop(context, widget.contact.id);
                },
                child: const Text('Delete Contact'),
              ),
            ],
          ),
        ),
      );
}
