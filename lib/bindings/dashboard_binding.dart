// lib/bindings/dashboard_binding.dart

import 'package:get/get.dart';
import 'package:minishop/controllers/category_controller.dart'; // Thêm import
import 'package:minishop/controllers/dashboard_controller.dart';
import 'package:minishop/controllers/home_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CategoryController>(() => CategoryController()); // <-- Thêm dòng này
    // Các controller khác cho giỏ hàng, hồ sơ... sẽ được put ở đây
  }
}