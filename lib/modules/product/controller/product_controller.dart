// lib/modules/product/controller/product_controller.dart
import 'package:get/get.dart';
import '../../../data/models/product.dart';

class ProductController extends GetxController {
  /// state
  final isLoading = false.obs;
  final productList = <Product>[].obs;
  final categoryName = 'Danh mục'.obs;

  /// lưu category hiện tại (để tránh refetch thừa)
  String? _currentCategoryId;

  @override
  void onInit() {
    super.onInit();
    refreshFromArgs(); // đọc Get.arguments lần đầu
  }

  /// Đọc arguments (hoặc truyền map thủ công) rồi load đúng danh mục
  void refreshFromArgs({Map? args}) {
    final data = args ?? Get.arguments;

    // Lấy id & name an toàn
    final String? id = (data is Map && data['categoryId'] != null)
        ? data['categoryId'].toString().trim()
        : null;
    final String? name = (data is Map && data['categoryName'] != null)
        ? data['categoryName'].toString()
        : null;

    // Cập nhật tiêu đề
    categoryName.value = (name != null && name.trim().isNotEmpty)
        ? name
        : 'Danh mục';

    // Không có categoryId -> không load gì, để View hiển thị "Chưa có sản phẩm..."
    if (id == null || id.isEmpty) {
      _currentCategoryId = null;
      productList.clear();
      isLoading.value = false;
      return;
    }

    // Nếu đã load đúng danh mục hiện tại rồi thì bỏ qua
    if (_currentCategoryId == id && productList.isNotEmpty) {
      isLoading.value = false;
      return;
    }

    _currentCategoryId = id;
    fetchProductsByCategory(id);
  }

  /// Tải sản phẩm theo ID danh mục (so khớp sau khi trim)
  Future<void> fetchProductsByCategory(String categoryId) async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(milliseconds: 300)); // giả lập API
      final all = _getMockProducts();
      final id = categoryId.trim();
      productList.assignAll(
        all.where((p) => p.categoryId.trim() == id),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Mock data: bổ sung đủ cho các category id 1..8
  List<Product> _getMockProducts() {
    return [
      // 1) Điện tử ('1')
      Product(id: '201', name: 'Chip xử lý', imageUrl: 'assets/images/dientu.png', price: 5000000, categoryId: '1'),

      // 2) Thời trang ('2')
      Product(id: '101', name: 'áo thun vàng', imageUrl: 'assets/images/aothunvang.png', price: 70000, categoryId: '2'),
      Product(id: '102', name: 'váy đen', imageUrl: 'assets/images/vayden.png', price: 100000, categoryId: '2'),
      Product(id: '103', name: 'áo váy nữ đen', imageUrl: 'assets/images/aovaynu.png', price: 300000, categoryId: '2'),
      Product(id: '104', name: 'đồ học sinh nữ', imageUrl: 'assets/images/dohocsinh.png', price: 200000, categoryId: '2'),

      // 3) Mỹ phẩm – Làm đẹp ('3')
      Product(id: '301', name: 'Bộ mỹ phẩm', imageUrl: 'assets/images/mypham.png', price: 250000, categoryId: '3'),

      // 4) Gia dụng ('4')
      Product(id: '401', name: 'Bộ gia dụng', imageUrl: 'assets/images/giadung.png', price: 180000, categoryId: '4'),

      // 5) Đời sống – Tiện ích ('5')
      Product(id: '501', name: 'Tiện ích gia đình', imageUrl: 'assets/images/doisong.png', price: 120000, categoryId: '5'),

      // 6) Đồ chơi – Giải trí ('6')
      Product(id: '601', name: 'Đồ chơi trẻ em', imageUrl: 'assets/images/dochoi.png', price: 90000, categoryId: '6'),

      // 7) Thể thao – Du lịch ('7')
      Product(id: '701', name: 'Phụ kiện thể thao', imageUrl: 'assets/images/thethao.png', price: 150000, categoryId: '7'),

      // 8) Thực phẩm – Đồ uống ('8')
      Product(id: '801', name: 'Thực phẩm đóng gói', imageUrl: 'assets/images/thucpham.png', price: 60000, categoryId: '8'),
    ];
  }
}
