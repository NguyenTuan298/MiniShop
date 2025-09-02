import 'package:get/get.dart';
import '../controller/life_utilities_controller.dart';

class LifeUtilitiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LifeUtilitiesController>(() => LifeUtilitiesController());
  }
}
