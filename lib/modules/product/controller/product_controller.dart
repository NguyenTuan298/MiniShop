// lib/controllers/product_controller.dart

import 'package:get/get.dart';
import 'package:minishop/models/product.dart';

class ProductController extends GetxController {
  var isLoading = true.obs;
  var productList = <Product>[].obs;
  var categoryName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Lấy arguments được truyền từ màn hình trước
    if (Get.arguments != null) {
      final String categoryId = Get.arguments['categoryId'];
      categoryName.value = Get.arguments['categoryName'];
      fetchProductsByCategory(categoryId);
    }
  }

  /// Tải sản phẩm dựa trên ID của danh mục
  void fetchProductsByCategory(String categoryId) async {
    try {
      isLoading(true);
      await Future.delayed(const Duration(milliseconds: 500)); // Giả lập API call

      // Đây là nơi bạn sẽ gọi API thật.
      // Bây giờ chúng ta sẽ dùng dữ liệu giả lập (mock database).
      final allProducts = _getMockProducts();
      productList.value = allProducts.where((p) => p.categoryId == categoryId).toList();

    } finally {
      isLoading(false);
    }
  }

  // Cơ sở dữ liệu sản phẩm giả lập
  List<Product> _getMockProducts() {
    return [
      // Thời trang (categoryId: '2')
      Product(id: '101', name: 'áo thun vàng', imageUrl: 'assets/images/aothunvang.png', price: 70000, categoryId: '2'),
      Product(id: '102', name: 'váy đen', imageUrl: 'assets/images/vayden.png', price: 100000, categoryId: '2'),
      Product(id: '103', name: 'áo váy nữ đen', imageUrl: 'assets/images/aovaynu.png', price: 300000, categoryId: '2'),
      Product(id: '104', name: 'đồ học sinh nữ', imageUrl: 'assets/images/dohocsinh.png', price: 200000, categoryId: '2'),

      // Điện tử (categoryId: '1')
      Product(id: '201', name: 'Chip xử lý', imageUrl: 'assets/images/dientu.png', price: 5000000, categoryId: '1'),

      // Thêm các sản phẩm cho các danh mục khác ở đây...
    ];
  }
}