import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/models/contact_info.dart';
import 'package:paylent/providers/contacts_provider.dart';
import 'package:paylent/providers/groups_provider.dart';

final groupParticipantsProvider =
    Provider.family<List<Contact>, String>((final ref, final groupId) {
  final group =
      ref.watch(groupsProvider).firstWhere((final g) => g.id == groupId);

  final contacts = ref.watch(contactsProvider);

  return contacts
      .where((final c) => group.participantIds.contains(c.id))
      .toList();
});
