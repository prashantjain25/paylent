enum GroupCategory {
  trip,
  family,
  couple,
  event,
  project,
  other;

   static GroupCategory fromString(final String value) => GroupCategory.values.firstWhere(
      (final e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => GroupCategory.other,
    );
}

extension GroupCategoryX on GroupCategory {
  String get label {
    switch (this) {
      case GroupCategory.trip:
        return 'Trip';
      case GroupCategory.family:
        return 'Family';
      case GroupCategory.couple:
        return 'Couple';
      case GroupCategory.event:
        return 'Event';
      case GroupCategory.project:
        return 'Project';
      case GroupCategory.other:
        return 'Other';
    }
  }

  String get emoji {
    switch (this) {
      case GroupCategory.trip:
        return '✈️';
      case GroupCategory.family:
        return '👨‍👩‍👧‍👦';
      case GroupCategory.couple:
        return '💑';
      case GroupCategory.event:
        return '📅';
      case GroupCategory.project:
        return '💼';
      case GroupCategory.other:
        return '⋯';
    }
  }
}
