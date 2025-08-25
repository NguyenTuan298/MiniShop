import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/widgets/welcome_banner.dart';
import 'package:minishop/modules/dashboard/controller/dashboard_controller.dart';
import 'package:minishop/modules/home/controller/home_controller.dart';
import 'package:minishop/modules/category/controller/category_controller.dart';

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
    // final categoryController = Get.find<CategoryController>(); // Không còn cần thiết nếu không dùng nút Thời Trang
    final theme = Theme.of(context);

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
                  // ... phần Tin nổi bật giữ nguyên ...
                  const SizedBox(height: 24),
                  Text('Tin nổi bật', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      // ... các Card tin tức (bạn cần thêm lại nội dung này nếu nó bị xóa) ...
                      children: [
                        // Card tin tức 1
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
                        // Card tin tức 2 (giả lập)
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

                      _buildCategoryButton(
                        context,
                        label: 'Hỗ trợ',
                        // Điều hướng đến trang hỗ trợ bằng route đã đăng ký
                        onPressed: () => Get.toNamed('/support'),
                      ),

                      _buildCategoryButton(context, label: 'Hồ sơ', onPressed: () => dashboardController.changeTabIndex(4)),

                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}