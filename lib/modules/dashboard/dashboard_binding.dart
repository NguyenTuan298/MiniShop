// lib/bindings/dashboard_binding.dart

import 'package:get/get.dart';
import 'package:minishop/modules/cart/cart_controller.dart';
import 'package:minishop/modules/category/category_controller.dart';
import 'package:minishop/modules/dashboard/dashboard_controller.dart';
import 'package:minishop/modules/home/home_controller.dart';
import 'package:minishop/modules/order/order_controller.dart';
import 'package:minishop/modules/profile/profile_controller.dart'; // Thêm import

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CategoryController>(() => CategoryController());
    Get.put(CartController(), permanent: true);
    Get.put(OrderController(), permanent: true);
    Get.lazyPut<ProfileController>(() => ProfileController()); // <-- Thêm dòng này
  }
}