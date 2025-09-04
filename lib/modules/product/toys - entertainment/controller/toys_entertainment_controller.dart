// lib/controller/cosmetics_beauty_controller.dart
import 'package:get/get.dart';

import '../../../../data/models/product_model.dart';
import '../../../../data/services/auth_service.dart';
import '../../../../data/services/product_service.dart';

class ToysEntertainmentController extends GetxController {
  final ProductService _productService = ProductService();
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
      final productList = await _productService.fetchProductsByCategory('do_choi');
      products.assignAll(productList.map((json) => Product.fromJson(json)).toList());
      isLoading.value = false;
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải sản phẩm: $e');
      isLoading.value = false;
    }
  }
}