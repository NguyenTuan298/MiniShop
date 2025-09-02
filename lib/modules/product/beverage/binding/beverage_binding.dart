import 'package:get/get.dart';

import '../controller/beverage_controller.dart';

class BeverageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BeverageController>(() => BeverageController());
  }
}
