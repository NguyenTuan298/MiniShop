// lib/widgets/category_card.dart

import 'package:flutter/material.dart';
import 'package:minishop/models/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ảnh nền
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              category.imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Lớp phủ màu tối để làm nổi bật chữ
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.black.withOpacity(0.25),
            ),
          ),
          // Tên danh mục
          Positioned(
            bottom: 12,
            left: 8,
            right: 8,
            child: Text(
              category.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: [
                    Shadow(blurRadius: 2.0, color: Colors.black, offset: Offset(1.0, 1.0)),
                  ]
              ),
            ),
          ),
        ],
      ),
    );
  }
}