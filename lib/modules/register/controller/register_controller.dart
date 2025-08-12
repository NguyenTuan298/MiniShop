import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void register() {
    String phone = phoneController.text.trim();
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (phone.isEmpty || name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng nhập đầy đủ thông tin",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // TODO: Gọi API đăng ký
    Get.snackbar("Thành công", "Đăng ký thành công!",
        snackPosition: SnackPosition.BOTTOM);
  }
}
