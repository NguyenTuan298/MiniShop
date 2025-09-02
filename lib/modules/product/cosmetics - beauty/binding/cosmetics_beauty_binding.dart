import 'package:get/get.dart';
import '../controller/cosmetics_beauty_controller.dart';

class CosmeticsBeautyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CosmeticsBeautyController>(() => CosmeticsBeautyController());
  }
}
