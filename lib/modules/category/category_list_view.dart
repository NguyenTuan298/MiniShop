// lib/views/category/category_list_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/modules/category/category_controller.dart';
import 'package:minishop/widgets/category_card.dart';

class CategoryListView extends StatelessWidget {
  const CategoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoryController>();

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: Text(
              "Minishop",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        leadingWidth: 100,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,          // 2 cột
            crossAxisSpacing: 16,       // Khoảng cách ngang
            mainAxisSpacing: 16,        // Khoảng cách dọc
            childAspectRatio: 0.85,      // Tỉ lệ chiều rộng/chiều cao của mỗi ô
          ),
          itemCount: controller.categoryList.length,
          itemBuilder: (context, index) {
            final category = controller.categoryList[index];
            return CategoryCard(category: category);
          },
        );
      }),
    );
  }
}