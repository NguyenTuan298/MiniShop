// lib/modules/home/view/home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../cart/controller/cart_controller.dart';
import '../controller/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final CartController cartController = Get.find<CartController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo1.png',
          height: 30,
          fit: BoxFit.contain,
        ),
        backgroundColor: Colors.white70,
      ),
      body: RefreshIndicator(
        onRefresh: controller.loadPromotions,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tin nổi bật (lấy từ API promotions/active)
              Text(
                'Tin nổi bật',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 16),

              Obx(() {
                if (controller.isLoadingPromos.value) {
                  return _buildPromoSkeleton(context);
                }
                if (controller.promoError.value != null) {
                  return _buildPromoError(controller.promoError.value!, controller);
                }
                if (controller.promotions.isEmpty) {
                  return const Text('Hiện chưa có khuyến mãi đang hiệu lực.');
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: controller.promotions.map((p) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            elevation: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Ảnh banner từ API (absolute URL)
                                AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Image.network(
                                    p.imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (c, e, s) => Container(
                                      color: Colors.grey[200],
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.image_not_supported),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.title,
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      if ((p.subtitle ?? '').isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          p.subtitle!,
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: theme.colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Giảm ${p.discountPercent}%'
                                              , style: const TextStyle(color: Colors.red)),
                                          Text(
                                            '${_fmtDate(p.startAt)} → ${_fmtDate(p.endAt)}',
                                            style: theme.textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }),

              const SizedBox(height: 16),

              // Danh mục nổi bật
              const Text(
                'Danh mục nổi bật',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCategoryItem(Icons.phone_android, 'Điện thoại'),
                    _buildCategoryItem(Icons.computer, 'Laptop'),
                    _buildCategoryItem(Icons.watch, 'Đồng hồ'),
                    _buildCategoryItem(Icons.tv, 'Tivi'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Sản phẩm gợi ý (tạm thời như cũ)
              const Text(
                'Sản phẩm gợi ý',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.7,
                children: [
                  _buildProductCard(
                    name: 'Điện thoại iPhone',
                    image: 'assets/images/iphone.png',
                    price: '20.000.000đ',
                    cartController: cartController,
                  ),
                  _buildProductCard(
                    name: 'Laptop Dell',
                    image: 'assets/images/laptop_dell.png',
                    price: '18.000.000đ',
                    cartController: cartController,
                  ),
                  _buildProductCard(
                    name: 'Đồng hồ Casio',
                    image: 'assets/images/dongho.png',
                    price: '2.000.000đ',
                    cartController: cartController,
                  ),
                  _buildProductCard(
                    name: 'Tivi Samsung',
                    image: 'assets/images/tivisamsung.png',
                    price: '15.000.000đ',
                    cartController: cartController,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== Widgets phụ =====

  static String _fmtDate(DateTime d) {
    // dd/MM/yyyy
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd/$mm/$yyyy';
  }

  Widget _buildPromoSkeleton(BuildContext context) {
    final w = MediaQuery.of(context).size.width * 0.8;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(2, (i) {
          return Container(
            width: w,
            height: w * 9 / 16 + 110,
            margin: EdgeInsets.only(right: i == 1 ? 0 : 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPromoError(String msg, HomeController controller) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Không tải được khuyến mãi: $msg',
            style: const TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: controller.loadPromotions,
          child: const Text('Thử lại'),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: Colors.blue),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildProductCard({
    required String name,
    required String image,
    required String price,
    required CartController cartController,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(image, fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(price, style: const TextStyle(color: Colors.red)),
                    GestureDetector(
                      onTap: () {
                        Get.snackbar(
                          'Thông báo',
                          '$name đã được thêm vào giỏ hàng',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.green.withOpacity(0.8),
                          colorText: Colors.white,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
