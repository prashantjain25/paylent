class Contact {
  final String name;
  final String email;
  final String avatarUrl;
  bool isFavorite;

  Contact({
    required this.name,
    required this.email,
    required this.avatarUrl,
    this.isFavorite = false,
  });

  String get firstLetter => name[0].toUpperCase();
}