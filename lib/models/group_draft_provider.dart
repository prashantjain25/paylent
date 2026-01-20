import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/models/group_category.dart';
import 'package:paylent/models/group_draft_model.dart';

final groupDraftProvider =
    StateNotifierProvider<GroupDraftNotifier, GroupDraft?>(
  (final ref) => GroupDraftNotifier(),
);

class GroupDraftNotifier extends StateNotifier<GroupDraft?> {
  GroupDraftNotifier() : super(null);

  void start({
    required final String title,
    required final String description,
    required final GroupCategory category,
    final String? imagePath,
  }) {
    state = GroupDraft(
      name: title,
      description: description,
      category: category,
      imagePath: imagePath ?? 'assets/images/group-image.png',
      participantIds: const [],
    );
  }

  void setParticipants(final List<String> participantIds) {
    if (state == null) return;
    state = state!.copyWith(participantIds: participantIds);
  }

  void clear() => state = null;
}
