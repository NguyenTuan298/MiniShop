// lib/bindings/register_binding.dart
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../controller/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthService());
    Get.lazyPut(() => RegisterController());
  }
}