import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedParticipantsProvider =
    StateNotifierProvider<SelectedParticipantsNotifier, Set<String>>(
  (final ref) => SelectedParticipantsNotifier(),
);

class SelectedParticipantsNotifier extends StateNotifier<Set<String>> {
  SelectedParticipantsNotifier() : super({});

  void toggle(final String contactId) {
    if (state.contains(contactId)) {
      state = {...state}..remove(contactId);
    } else {
      state = {...state, contactId};
    }
  }

  void clear() => state = {};
}
