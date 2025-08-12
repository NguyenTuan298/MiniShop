import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final phoneEmailController = TextEditingController();
  final passwordController = TextEditingController();
  var isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void login() {
    // TODO: Thêm logic đăng nhập
    print("Login với: ${phoneEmailController.text}");
  }

  @override
  void onClose() {
    phoneEmailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
