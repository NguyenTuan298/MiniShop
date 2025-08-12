import 'package:get/get.dart';
import 'package:minishop/routes.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 6), () {
      Get.offNamed(AppRoutes.login);
    });
  }
}
