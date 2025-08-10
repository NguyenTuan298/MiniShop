// lib/bindings/dashboard_binding.dart

import 'package:get/get.dart';
import 'package:minishop/controllers/cart_controller.dart';
import 'package:minishop/controllers/category_controller.dart';
import 'package:minishop/controllers/dashboard_controller.dart';
import 'package:minishop/controllers/home_controller.dart';
import 'package:minishop/controllers/order_controller.dart';
import 'package:minishop/controllers/profile_controller.dart'; // Thêm import

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