import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/widgets/welcome_banner.dart';
import 'package:minishop/modules/dashboard/controller/dashboard_controller.dart';
import 'package:minishop/modules/home/controller/home_controller.dart';

// Product & Cart
import 'package:minishop/modules/product/view/product_grid_view.dart';
import 'package:minishop/modules/product/controller/product_controller.dart';
import 'package:minishop/modules/cart/controller/cart_controller.dart';
import 'package:minishop/routes.dart';

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

    // Bảo đảm luôn có ProductController & CartController cho Home
    final productController = Get.isRegistered<ProductController>()
        ? Get.find<ProductController>()
        : Get.put(ProductController());
    final cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());

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

                  // ====== THAY "TẤT CẢ THỂ LOẠI" -> "TẤT CẢ SẢN PHẨM" ======
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tất cả sản phẩm', style: theme.textTheme.titleLarge),
                      TextButton(
                        onPressed: () {
                          // Mở ProductGridView: chỉ ảnh + tap => checkout
                          Get.to(
                                () => const ProductGridView(),
                            arguments: {
                              'imageOnly': true,
                              'tapToCheckout': true,
                            },
                            binding: BindingsBuilder(() {
                              if (!Get.isRegistered<ProductController>()) {
                                Get.put(ProductController());
                              }
                              if (!Get.isRegistered<CartController>()) {
                                Get.put(CartController());
                              }
                            }),
                          );
                        },
                        child: const Text('Xem tất cả'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Carousel sản phẩm ngang (ảnh + tên + giá). Tap => thêm vào giỏ & đi Checkout
                  SizedBox(
                    height: 180,
                    child: Obx(() {
                      if (productController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final products = productController.productList;
                      if (products.isEmpty) {
                        return Center(
                          child: Text(
                            'Chưa có sản phẩm',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        padding: const EdgeInsets.only(right: 4),
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (ctx, i) {
                          final p = products[i];
                          return GestureDetector(
                            onTap: () {
                              cartController.addToCart(p);
                              Get.toNamed(AppRoutes.checkout);
                            },
                            child: SizedBox(
                              width: 130,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: AspectRatio(
                                      aspectRatio: 1, // ô vuông
                                      child: Image.asset(
                                        p.imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    p.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    // Nếu có AppFormatters thì dùng; ở đây giữ đơn giản
                                    // AppFormatters.formatCurrency(p.price),
                                    '${p.price.toStringAsFixed(0)} đ',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                  // ====== HẾT PHẦN SẢN PHẨM ======
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
