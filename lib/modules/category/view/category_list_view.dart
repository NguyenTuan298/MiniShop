import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/modules/category/controller/category_controller.dart';
import 'package:minishop/widgets/category_card.dart';

class CategoryListView extends GetView<CategoryController> {
  const CategoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Nền cho ô search: dùng surfaceVariant để hợp cả light/dark
    final Color searchBg = theme.colorScheme.surfaceVariant.withOpacity(
      theme.brightness == Brightness.dark ? 0.35 : 1.0,
    );
    final Color hintColor =
    theme.colorScheme.onSurface.withOpacity(0.6);
    final Color iconColor =
        theme.iconTheme.color ?? theme.colorScheme.onSurface.withOpacity(0.8);

    return Scaffold(
      // KHÔNG set backgroundColor cứng -> theo theme
      appBar: AppBar(
        // KHÔNG set backgroundColor cứng -> theo theme.appBarTheme
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: Text(
              "Minishop",
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        leadingWidth: 100,
        titleSpacing: 0,
        title: SizedBox(
          height: 40,
          child: TextField(
            onChanged: controller.updateSearchQuery,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(color: hintColor),
              prefixIcon: Icon(Icons.search, color: iconColor),
              filled: true,
              fillColor: searchBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0, horizontal: 12,
              ),
            ),
          ),
        ),
        elevation: theme.appBarTheme.elevation ?? 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.filteredCategories.isEmpty) {
          return Center(
            child: Text(
              'Không tìm thấy danh mục nào',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemCount: controller.filteredCategories.length,
          itemBuilder: (context, index) {
            final category = controller.filteredCategories[index];
            return CategoryCard(category: category);
          },
        );
      }),
    );
  }
}
