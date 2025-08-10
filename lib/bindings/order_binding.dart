// lib/bindings/order_binding.dart

import 'package:get/get.dart';
import 'package:minishop/controllers/order_controller.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderController>(() => OrderController());
  }
}