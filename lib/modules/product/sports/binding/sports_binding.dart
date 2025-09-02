import 'package:get/get.dart';
import '../controller/sports_controller.dart';

class SportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SportsController>(() => SportsController());
  }
}
