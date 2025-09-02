import 'package:get/get.dart';
import '../controller/electronics_controller.dart';

class ElectronicsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ElectronicsController>(() => ElectronicsController());
  }
}
