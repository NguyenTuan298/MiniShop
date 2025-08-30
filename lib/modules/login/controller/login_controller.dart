import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      final response = await _authService.login(
        phoneEmailController.text.trim(),
        passwordController.text.trim(),
      );

      if (response['message'] == 'Đăng nhập thành công') {
        Get.offAllNamed('/dashboard'); // Chuyển đến dashboard sau khi đăng nhập thành công
        Get.snackbar('Thành công', 'Đăng nhập thành công', backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Lỗi', 'Đăng nhập thất bại', backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Đăng nhập thất bại: ${e.toString()}', backgroundColor: Colors.red, colorText: Colors.white);
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