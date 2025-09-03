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
  final errorMessage_phone = RxString('');
  final errorMessage_username = RxString('');
  final errorMessage_email = RxString('');
  final errorMessage_password = RxString('');


  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> register() async {
    String phone = phoneController.text.trim();
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (phone.isEmpty && name.isEmpty && email.isEmpty && password.isEmpty) {
      if (phone.isEmpty) {
        errorMessage_phone.value = 'Bạn cần nhập số điện thoại';
      }
      if (name.isEmpty) {
        errorMessage_username.value = 'Bạn cần nhập tên';
      }
      if (email.isEmpty) {
        errorMessage_email.value = 'Bạn cần nhập email';
      }
      if (password.isEmpty) {
        errorMessage_password.value = 'Bạn cần nhập mật khẩu';
      }
      return;
    }
    if (phone.length != 10) {
      errorMessage_phone.value = 'Số điện thoại phải có 10 chữ số';
      return;
    }
    if (name.length < 3) {
      errorMessage_username.value = 'Tên phải có ít nhất 3 ký tự';
      return;
    }
    if (!GetUtils.isEmail(email)) {
      errorMessage_email.value = 'Email không hợp lệ';
      return;
    }
    if (password.length < 6) {
      errorMessage_password.value = 'Mật khẩu phải có ít nhất 6 ký tự';
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