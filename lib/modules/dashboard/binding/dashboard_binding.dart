// lib/binding/dashboard_binding.dart

import 'package:get/get.dart';
import 'package:minishop/modules/cart/controller/cart_controller.dart';
import 'package:minishop/modules/category/controller/category_controller.dart';
import 'package:minishop/modules/dashboard/controller/dashboard_controller.dart';
import 'package:minishop/modules/home/controller/home_controller.dart';
import 'package:minishop/modules/order/controller/order_controller.dart';
import 'package:minishop/modules/profile/controller/profile_controller.dart'; // Thêm import

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