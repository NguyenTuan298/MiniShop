import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final phoneOrEmailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  String? validatePhoneOrEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số điện thoại hoặc email';
    }
    if (!value.isEmail && !RegExp(r'^(?:[+0]9)?[0-9]{10}$').hasMatch(value)) {
      return 'Vui lòng nhập email hoặc số điện thoại hợp lệ';
    }
    return null;
  }

  Future<void> submit() async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        isLoading.value = true;
        // Gọi API khôi phục mật khẩu
        await Future.delayed(const Duration(seconds: 2)); // Giả lập gọi API

        Get.snackbar(
          'Thành công',
          'Hướng dẫn khôi phục đã được gửi đến ${phoneOrEmailController.text}',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar(
          'Lỗi',
          'Khôi phục mật khẩu thất bại: ${e.toString()}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    phoneOrEmailController.dispose();
    super.onClose();
  }
}