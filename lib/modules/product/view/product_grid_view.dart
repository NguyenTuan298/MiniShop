import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/modules/product/controller/product_controller.dart';
import 'package:minishop/widgets/product_card.dart';

class ProductGridView extends StatelessWidget {
  const ProductGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();
    final theme = Theme.of(context);

    return Scaffold(
      // KHÔNG set backgroundColor cứng -> theo theme
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, controller),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.productList.isEmpty) {
                  return Center(
                    child: Text(
                      'Chưa có sản phẩm trong danh mục này.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
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
                    childAspectRatio: 0.75,
                  ),
                  itemCount: controller.productList.length,
                  itemBuilder: (context, index) {
                    final product = controller.productList[index];
                    return ProductCard(product: product);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// Header tuỳ chỉnh tôn trọng theme (icon/text tự đổi màu theo light/dark)
  Widget _buildHeader(BuildContext context, ProductController controller) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo
          Image.asset('assets/images/logo1.png', height: 35),
          const SizedBox(height: 8),

          // Hàng chứa nút Back (trái) + Tiêu đề (giữa)
          SizedBox(
            height: 48,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Tiêu đề căn giữa
                Obx(() => Text(
                  controller.categoryName.value,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                )),
                // Nút back căn trái
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    tooltip: 'Quay lại',
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back),
                    color: theme.appBarTheme.iconTheme?.color ??
                        theme.iconTheme.color ??
                        theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
