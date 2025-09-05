import 'package:get/get.dart';

import '../controller/watches_controller.dart';

class WatchesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WatchesController>(() => WatchesController());
  }
}
