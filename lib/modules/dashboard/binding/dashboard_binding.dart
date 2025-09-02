import 'package:get/get.dart';

import '../../cart/controller/cart_controller.dart';
import '../../category/controller/category_controller.dart';
import '../../home/controller/home_controller.dart';
import '../../order/controller/order_controller.dart';
import '../controller/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut(()=>CategoryController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<OrderController>(() => OrderController());
  }
}
