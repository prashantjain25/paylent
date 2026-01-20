import 'package:paylent/models/group_category.dart';

class GroupDraft {
  final String name;
  final String description;
  final GroupCategory category;
  final String imagePath;
  final List<String> participantIds;

  const GroupDraft({
    required this.name,
    required this.description,
    required this.category,
    required this.imagePath,
    required this.participantIds,
  });

  GroupDraft copyWith({
    final String? name,
    final String? description,
    final GroupCategory? category,
    final String? imagePath,
    final List<String>? participantIds,
  }) => GroupDraft(
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      participantIds: participantIds ?? this.participantIds,
    );
}
