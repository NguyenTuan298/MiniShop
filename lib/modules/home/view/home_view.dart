import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/widgets/welcome_banner.dart';
import 'package:minishop/modules/dashboard/controller/dashboard_controller.dart';
import 'package:minishop/modules/home/controller/home_controller.dart';

// +++ thêm import để mở trang xem tất cả thể loại
import 'package:minishop/modules/category/controller/category_controller.dart';
import 'package:minishop/modules/category/view/category_list_view.dart';
import 'package:minishop/modules/product/view/product_grid_view.dart';
import 'package:minishop/modules/product/controller/product_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  Widget _buildCategoryButton(BuildContext context, {required String label, VoidCallback? onPressed}) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.find<DashboardController>();
    final theme = Theme.of(context);

    // Bảo đảm luôn có CategoryController cho Home
    final categoryController = Get.isRegistered<CategoryController>()
        ? Get.find<CategoryController>()
        : Get.put(CategoryController());

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WelcomeBanner(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text('Tin nổi bật', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                if (controller.newsImageUrl.value.isNotEmpty)
                                  Image.asset(controller.newsImageUrl.value),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    controller.newsDescription.value,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                if (controller.newsImageUrl.value.isNotEmpty)
                                  Image.asset(controller.newsImageUrl.value),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    controller.newsDescription.value,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  Text('Danh mục nổi bật', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12.0,
                    runSpacing: 12.0,
                    children: [
                      _buildCategoryButton(context, label: 'Mua Lại', onPressed: () => dashboardController.changeTabIndex(2)),
                      _buildCategoryButton(context, label: 'Xem Đơn', onPressed: () => dashboardController.changeTabIndex(3)),
                      _buildCategoryButton(context, label: 'Hỗ trợ', onPressed: () => Get.toNamed('/support')),
                      _buildCategoryButton(context, label: 'Hồ sơ', onPressed: () => dashboardController.changeTabIndex(4)),
                    ],
                  ),

                  // ====== MỤC MỚI: TẤT CẢ THỂ LOẠI (kéo ngang) ======
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tất cả thể loại', style: theme.textTheme.titleLarge),
                      TextButton(
                        onPressed: () => Get.to(() => const CategoryListView()),
                        child: const Text('Xem tất cả'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 118, // đủ chỗ cho avatar + 2 dòng tên
                    child: Obx(() {
                      if (categoryController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final cats = categoryController.categoryList;
                      if (cats.isEmpty) {
                        return Center(
                          child: Text(
                            'Chưa có thể loại',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: cats.length,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (ctx, i) {
                          final c = cats[i];
                          return GestureDetector(
                            onTap: () {
                              Get.to(
                                    () => const ProductGridView(),
                                arguments: {'categoryId': c.id, 'categoryName': c.name},
                                binding: BindingsBuilder(() {
                                  if (!Get.isRegistered<ProductController>()) {
                                    Get.put(ProductController());
                                  }
                                }),
                              );
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surfaceVariant.withOpacity(
                                      theme.brightness == Brightness.dark ? 0.35 : 1.0,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.asset(c.imageUrl, fit: BoxFit.cover),
                                ),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: 88,
                                  child: Text(
                                    c.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  ),
                  // ====== HẾT MỤC MỚI ======
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
