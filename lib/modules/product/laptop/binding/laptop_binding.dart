import 'package:get/get.dart';

import '../controller/laptop_controller.dart';

class LaptopBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LaptopController>(() => LaptopController());
  }
}
