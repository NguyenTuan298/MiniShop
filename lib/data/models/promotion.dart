// lib/data/models/promotion.dart
class Promotion {
  final int id;
  final String title;
  final String? subtitle;
  final String? description;
  final String imageUrl;
  final int discountPercent;
  final DateTime startAt;
  final DateTime endAt;

  Promotion({
    required this.id,
    required this.title,
    this.subtitle,
    this.description,
    required this.imageUrl,
    required this.discountPercent,
    required this.startAt,
    required this.endAt,
  });

  factory Promotion.fromJson(Map<String, dynamic> j) => Promotion(
    id: j['id'] as int,
    title: j['title'] as String,
    subtitle: j['subtitle'] as String?,
    description: j['description'] as String?,
    imageUrl: j['image_url'] as String,
    discountPercent: (j['discount_percent'] as num).toInt(),
    startAt: DateTime.parse(j['start_at'] as String),
    endAt: DateTime.parse(j['end_at'] as String),
  );
}
