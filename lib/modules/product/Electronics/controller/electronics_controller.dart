// lib/controller/electronics_controller.dart
import 'package:get/get.dart';

import '../../../../data/models/product_model.dart';
import '../../../../data/services/product_service.dart';

class ElectronicsController extends GetxController {
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
      final productList = await _productService.fetchProductsByCategory('dien_tu');
      products.assignAll(productList.map((json) => Product.fromJson(json)).toList());
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải sản phẩm: $e');
    } finally {
      isLoading.value = false;
    }
  }
}