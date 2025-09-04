// lib/modules/home/view/home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../cart/controller/cart_controller.dart';
import '../controller/home_controller.dart';

// NEW: dùng model + service + formatter
import 'package:minishop/data/models/product_model.dart';
import 'package:minishop/data/services/product_service.dart';
import 'package:minishop/utils/format.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = Get.find<HomeController>();
  final CartController cartController = Get.find<CartController>();

  // Giữ nguyên ProductService (KHÔNG sửa file service)
  final ProductService _productService = Get.put(ProductService());

  // ================== CẤU HÌNH GỢI Ý (đa danh mục) ==================
  // Chọn nhiều danh mục để gợi ý (đổi theo DB của bạn)
  static const List<String> _recommendedCategories = [
    'dien_tu',
    'thoi_trang',
    'thuc_pham',
  ];

  // Giới hạn hiển thị tổng & số lượng mỗi danh mục
  static const int _maxRecommended = 12;
  static const int _perCategory = 6;

  // Future danh sách gợi ý đã trộn
  late Future<List<Map<String, dynamic>>> _recFuture;

  @override
  void initState() {
    super.initState();
    // Lấy gợi ý đa danh mục ngay khi mở trang
    _recFuture = _fetchRecommendedMulti();
    // Khởi động tải promotions nếu controller chưa có
    if (controller.promotions.isEmpty && !controller.isLoadingPromos.value) {
      controller.loadPromotions();
    }
  }

  // Gọi API cho nhiều danh mục (không sửa ProductService),
  // gom theo round-robin, khử trùng lặp theo id, cắt theo _maxRecommended.
  Future<List<Map<String, dynamic>>> _fetchRecommendedMulti() async {
    Future<List<dynamic>> _safeFetch(String cat) async {
      try {
        return await _productService.fetchProductsByCategory(cat);
      } catch (_) {
        return <dynamic>[]; // Nếu 1 danh mục lỗi vẫn trả về rỗng để không “đổ bể” cả trang
      }
    }

    // Gọi song song các danh mục
    final rawLists = await Future.wait(
      _recommendedCategories.map(_safeFetch),
    );

    // Chuẩn hóa từng danh mục: giữ Map và cắt theo _perCategory
    final perCat = rawLists
        .map((lst) => lst.whereType<Map<String, dynamic>>().take(_perCategory).toList())
        .toList();

    // Trộn vòng-tròn (round-robin) để xen kẽ danh mục
    final merged = <Map<String, dynamic>>[];
    for (int i = 0;; i++) {
      bool added = false;
      for (final l in perCat) {
        if (i < l.length) {
          merged.add(l[i]);
          added = true;
        }
      }
      if (!added) break;
    }

    // Khử trùng lặp theo id (nếu API trả trùng giữa các danh mục)
    final seen = <int>{};
    final unique = <Map<String, dynamic>>[];
    for (final m in merged) {
      final id = m['id'];
      if (id is int) {
        if (!seen.contains(id)) {
          seen.add(id);
          unique.add(m);
        }
      } else {
        // Không có id chuẩn -> vẫn thêm để tránh mất dữ liệu
        unique.add(m);
      }
    }

    // Giới hạn tổng số item hiển thị
    return unique.take(_maxRecommended).toList();
  }

  @override
  Widget build(BuildContext context) {
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
        onRefresh: () async {
          // Làm mới cả promotions và gợi ý đa danh mục
          await controller.loadPromotions();
          setState(() {
            _recFuture = _fetchRecommendedMulti();
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================== Tin nổi bật ==================
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
                                          // Hiển thị phần trăm giảm nếu có
                                          Text(
                                            'Giảm ${p.discountPercent ?? 0}%',
                                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                                          ),
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

              // ================== Danh mục nổi bật ==================
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

              // ================== Sản phẩm gợi ý (LIÊN KẾT API) ==================
              const Text(
                'Sản phẩm gợi ý',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              FutureBuilder<List<Map<String, dynamic>>>(
                future: _recFuture,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return _recSkeletonGrid(context);
                  }
                  if (snap.hasError) {
                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Không tải được sản phẩm gợi ý: ${snap.error}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _recFuture = _fetchRecommendedMulti();
                            });
                          },
                          child: const Text('Thử lại'),
                        ),
                      ],
                    );
                  }

                  final data = snap.data ?? <Map<String, dynamic>>[];
                  final items = data.map(Product.fromJson).toList();

                  if (items.isEmpty) {
                    return const Text('Hiện chưa có sản phẩm gợi ý.');
                  }

                  return GridView.builder(
                    itemCount: items.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (ctx, i) {
                      final p = items[i];
                      final outOfStock = p.stock <= 0;

                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Ảnh: tự nhận URL/asset
                            Expanded(
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: _SmartImage(p.imageUrl),
                                  ),
                                  if (outOfStock)
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.6),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'Hết hàng',
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppFormatters.formatCurrency(p.price),
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Material(
                                        color: outOfStock
                                            ? Theme.of(context).colorScheme.primary.withOpacity(0.4)
                                            : Theme.of(context).colorScheme.primary,
                                        shape: const CircleBorder(),
                                        child: InkWell(
                                          customBorder: const CircleBorder(),
                                          onTap: outOfStock ? null : () => cartController.addToCart(p),
                                          child: const SizedBox(
                                            width: 32,
                                            height: 32,
                                            child: Icon(Icons.add, size: 16, color: Colors.white),
                                          ),
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
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== Widgets phụ =====

  static String _fmtDate(DateTime d) {
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
}

// Skeleton cho grid “Sản phẩm gợi ý”
Widget _recSkeletonGrid(BuildContext context) {
  return GridView.builder(
    itemCount: 4,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.7,
    ),
    itemBuilder: (ctx, i) => Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}

/// Ảnh thông minh: URL -> network, còn lại -> asset. Có fallback icon khi lỗi.
class _SmartImage extends StatelessWidget {
  final String src;
  const _SmartImage(this.src);

  bool get _isUrl => src.startsWith('http://') || src.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    if (_isUrl) {
      return Image.network(
        src,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => _err(),
      );
    }
    return Image.asset(
      src,
      fit: BoxFit.cover,
      errorBuilder: (c, e, s) => _err(),
    );
  }

  Widget _err() => Container(
    color: const Color(0xFFF2F2F2),
    alignment: Alignment.center,
    child: const Icon(Icons.image_not_supported),
  );
}
