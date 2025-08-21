import 'package:get/get.dart';
import '../controller/reset_password_controller.dart';
import '../../../data/services/auth_service.dart';  // Add AuthService

class ResetPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthService>(() => AuthService());  // Put AuthService
    Get.lazyPut<ResetPasswordController>(
          () => ResetPasswordController(),
      fenix: true,
    );
  }
}