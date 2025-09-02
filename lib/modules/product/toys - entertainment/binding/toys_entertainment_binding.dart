import 'package:get/get.dart';

import '../controller/toys_entertainment_controller.dart';

class ToysEntertainmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ToysEntertainmentController>(() => ToysEntertainmentController());
  }
}
