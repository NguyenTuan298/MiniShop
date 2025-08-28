import 'package:get/get.dart';
import 'package:minishop/modules/order_information/controller/order_information_controller.dart';

class OrderInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderInformationController>(() => OrderInformationController());
  }
}
