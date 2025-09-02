// lib/controller/fashion_controller.dart
import 'package:get/get.dart';

import '../../../../data/models/product_model.dart';
import '../../../../data/services/auth_service.dart';

class FashionController extends GetxController {
  final AuthService _authService = AuthService();
  var products = <Product>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final productList = await _authService.fetchProductsByCategory('thoi_trang');
      products.assignAll(productList.map((json) => Product.fromJson(json)).toList());
      isLoading.value = false;
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải sản phẩm: $e');
      isLoading.value = false;
    }
  }
}