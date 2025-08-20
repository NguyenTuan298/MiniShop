// lib/controller/login_controller.dart
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/services/auth_service.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find();

  // Text controllers
  final phoneEmailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observables
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  // Handle login
  Future<void> login() async {
    try {
      print('Phone/Email: ${phoneEmailController.text.trim()}'); // Debug
      print('Password: ${passwordController.text.trim()}'); // Debug
      isLoading.value = true;
      final success = await _authService.login(
        phoneEmailController.text.trim(),
        passwordController.text.trim(),
      );

      if (success) {
        Get.offNamed('/dashboard');
      } else {
        // Get.snackbar('Lỗi', 'Đăng nhập thất bại');
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    phoneEmailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}