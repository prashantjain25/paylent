enum TransactionCategory {
  food,
  transport,
  shopping,
  entertainment,
  bills,
  others;

  static TransactionCategory fromString(final String value) => TransactionCategory.values.firstWhere(
      (final e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => TransactionCategory.others,
    );
  // Optional: Helper to get a capitalized string for the UI
  String get name {
    switch (this) {
      case TransactionCategory.food: return 'Food';
      case TransactionCategory.transport: return 'Transport';
      case TransactionCategory.shopping: return 'Shopping';
      case TransactionCategory.entertainment: return 'Entertainment';
      case TransactionCategory.bills: return 'Bills';
      case TransactionCategory.others: return 'Others';
    }
  }

  static List<String> get allCategories => TransactionCategory.values.map((final e) => e.name).toList();
}