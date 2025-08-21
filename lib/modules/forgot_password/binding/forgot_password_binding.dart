import 'package:get/get.dart';

import '../controller/forgot_password_controller.dart';
import '../../../data/services/auth_service.dart';  // Add AuthService

class ForgotPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthService>(() => AuthService());  // Put AuthService
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController(),
    );
  }
}