import 'package:get/get.dart';

import '../controller/food_controller.dart';

class FoodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FoodController>(() => FoodController());
  }
}
