class Contact {
  final String id;
  String name;
  String email;
  final String avatarUrl;
  final bool isFavorite;

  Contact({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    this.isFavorite = false,
  });

  Contact copy() => Contact(
  id: id,
  name: name,
  email: email,
  avatarUrl: avatarUrl,
  isFavorite: isFavorite,
);

  String get firstLetter => name[0].toUpperCase();
}