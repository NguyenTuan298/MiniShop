// lib/bindings/order_binding.dart

import 'package:get/get.dart';
import 'package:minishop/modules/order/controller/order_controller.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderController>(() => OrderController());
  }
}