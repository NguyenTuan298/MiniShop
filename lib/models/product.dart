// lib/models/product.dart

class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String categoryId; // Để lọc sản phẩm theo danh mục

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.categoryId,
  });
}