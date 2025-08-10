// lib/bindings/product_binding.dart

import 'package:get/get.dart';
import 'package:minishop/modules/product/product_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductController>(() => ProductController());
  }
}