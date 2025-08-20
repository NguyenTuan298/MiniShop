// lib/controller/register_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/auth_service.dart';

class RegisterController extends GetxController {
  final AuthService _authService = Get.find();

  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> register() async {
    String phone = phoneController.text.trim();
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (phone.isEmpty || name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng nhập đầy đủ thông tin",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (!GetUtils.isEmail(email)) {
      Get.snackbar("Lỗi", "Email không hợp lệ");
      return;
    }
    if (password.length < 6) {
      Get.snackbar("Lỗi", "Mật khẩu phải có ít nhất 6 ký tự");
      return;
    }

    try {
      isLoading.value = true;
      final success = await _authService.register(phone, name, email, password);

      if (success) {
        Get.snackbar("Thành công", "Đăng ký thành công!",
            snackPosition: SnackPosition.TOP);
        Get.offNamed('/login');
      } else {
        Get.snackbar("Lỗi", "Đăng ký thất bại",
            snackPosition: SnackPosition.TOP);
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}