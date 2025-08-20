// lib/bindings/login_binding.dart
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../controller/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
  }
}

