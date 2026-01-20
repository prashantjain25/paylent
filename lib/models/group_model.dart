import 'package:paylent/models/group_category.dart';

class Group {
  final String id;
  final String name;
  final String? description;
  final GroupCategory category;
  final String? imagePath;
  final List<String> participantIds;
  final List<String> transactionIds;

  const Group({
    required this.id,
    required this.name,
    required this.participantIds, required this.transactionIds, this.imagePath, this.description,
    this.category = GroupCategory.other,
  });

  String get imageUrl =>
      'https://picsum.photos/seed/${Uri.encodeComponent(name)}/120/80';
}
