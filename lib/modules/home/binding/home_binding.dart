import 'package:get/get.dart';
import '../../cart/controller/cart_controller.dart';
import '../controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.put(CartController());
  }
}
