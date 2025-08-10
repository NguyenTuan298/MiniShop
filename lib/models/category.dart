// lib/models/category.dart

class Category {
  final String id;
  final String name;
  final String imageUrl; // Sẽ là đường dẫn trong assets

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}