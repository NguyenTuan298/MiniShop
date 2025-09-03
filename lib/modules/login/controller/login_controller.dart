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
  final errorMessage = RxString(''); // Thêm biến observable cho thông báo lỗi

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  // Handle login
  Future<void> login() async {
    // Reset error message
    errorMessage.value = '';

    // Trim input
    final phoneEmail = phoneEmailController.text.trim();
    final password = passwordController.text.trim();

    // Kiểm tra đầu vào
    if (phoneEmail.isEmpty && password.isEmpty) {
      errorMessage.value = 'Bạn cần nhập số điện thoại, email hoặc mật khẩu';
      return;
    } else if (phoneEmail.isEmpty) {
      errorMessage.value = 'Bạn cần nhập số điện thoại hoặc email';
      return;
    } else if (password.isEmpty) {
      errorMessage.value = 'Bạn cần nhập mật khẩu';
      return;
    }

    try {
      print('Phone/Email: $phoneEmail'); // Debug
      print('Password: $password'); // Debug
      isLoading.value = true;
      final response = await _authService.login(phoneEmail, password);

      if (response['message'] == 'Đăng nhập thành công') {
        Get.offAllNamed('/dashboard'); // Chuyển đến dashboard sau khi đăng nhập thành công
        Get.snackbar('Thành công', 'Đăng nhập thành công',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Lỗi', 'Đăng nhập thất bại',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Đăng nhập thất bại: ${e.toString()}',
          backgroundColor: Colors.red, colorText: Colors.white);
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