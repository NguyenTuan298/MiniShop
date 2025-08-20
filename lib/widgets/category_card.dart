// lib/widgets/category_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Thêm import
import 'package:minishop/routes.dart';

import '../data/models/category.dart'; // Thêm import

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Bọc trong GestureDetector
      onTap: () {
        // Điều hướng đến màn hình product grid
        Get.toNamed(
          AppRoutes.productGrid,
          arguments: {
            'categoryId': category.id,
            // Xóa ký tự xuống dòng khỏi tên để hiển thị trên AppBar
            'categoryName': category.name.replaceAll('\n', ' '),
          },
        );
      },
      child: Container(
        // ... giữ nguyên phần còn lại của widget
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                category.imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.black.withOpacity(0.25),
              ),
            ),
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
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}