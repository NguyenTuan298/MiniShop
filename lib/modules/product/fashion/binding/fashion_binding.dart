import 'package:get/get.dart';

import '../controller/fashion_controller.dart';

class FashionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FashionController>(() => FashionController());
  }
}
