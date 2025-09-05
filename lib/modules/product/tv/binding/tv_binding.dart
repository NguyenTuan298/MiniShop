import 'package:get/get.dart';

import '../controller/tv_controller.dart';

class TvBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TvController>(() => TvController());
  }
}
