// lib/modules/product/controller/product_controller.dart
import 'package:get/get.dart';
import '../../../data/models/product.dart';

class ProductController extends GetxController {
  var isLoading = true.obs;
  var productList = <Product>[].obs;
  var categoryName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Nhận args từ màn trước (nếu có)
    if (Get.arguments is Map && Get.arguments['categoryId'] != null) {
      final String categoryId = Get.arguments['categoryId'];
      categoryName.value = (Get.arguments['categoryName'] ?? '').toString();
      fetchProductsByCategory(categoryId);
    } else {
      // Không có args -> hiển thị tất cả sản phẩm
      _fetchAllProducts();
    }
  }

  void _fetchAllProducts() async {
    try {
      isLoading(true);
      await Future.delayed(const Duration(milliseconds: 300));
      final all = _getMockProducts();
      productList.value = all;
      categoryName.value = 'Tất cả sản phẩm';
    } finally {
      isLoading(false);
    }
  }

  /// Tải sản phẩm theo ID danh mục
  void fetchProductsByCategory(String categoryId) async {
    try {
      isLoading(true);
      await Future.delayed(const Duration(milliseconds: 500)); // Giả lập API
      final allProducts = _getMockProducts();
      productList.value = allProducts.where((p) => p.categoryId == categoryId).toList();
    } finally {
      isLoading(false);
    }
  }

  // Mock data
  List<Product> _getMockProducts() {
    return [
      // Thời trang (categoryId: '2')
      Product(id: '101', name: 'áo thun vàng', imageUrl: 'assets/images/aothunvang.png', price: 70000, categoryId: '2'),
      Product(id: '102', name: 'váy đen', imageUrl: 'assets/images/vayden.png', price: 100000, categoryId: '2'),
      Product(id: '103', name: 'áo váy nữ đen', imageUrl: 'assets/images/aovaynu.png', price: 300000, categoryId: '2'),
      Product(id: '104', name: 'đồ học sinh nữ', imageUrl: 'assets/images/dohocsinh.png', price: 200000, categoryId: '2'),

      // Điện tử (categoryId: '1')
      Product(id: '201', name: 'Chip xử lý', imageUrl: 'assets/images/dientu.png', price: 5000000, categoryId: '1'),

      // Bạn có thể bổ sung thêm sản phẩm cho các category khác...
    ];
  }
}
