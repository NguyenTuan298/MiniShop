// lib/data/models/product_model.dart
class Product {
  final int id;
  final String name;
  final String category;
  final String description;
  final double price; // Thay đổi từ int thành double
  final String imageUrl;
  final int stock;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.stock,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] as String? ?? 'Không có tên',
      category: json['category'] as String? ?? 'Không có danh mục',
      description: json['description'] as String? ?? 'Không có mô tả',
      price: double.tryParse(json['price'].toString()) ?? 0.0, // Chuyển đổi từ String hoặc DECIMAL sang double
      imageUrl: json['image_url'] as String? ?? '',
      stock: int.tryParse(json['stock'].toString()) ?? 0,
      createdAt: DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now(),
    );
  }
}