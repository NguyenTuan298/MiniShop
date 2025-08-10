// lib/bindings/product_binding.dart

import 'package:get/get.dart';
import 'package:minishop/controllers/product_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductController>(() => ProductController());
  }
}