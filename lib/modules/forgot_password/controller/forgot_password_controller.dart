import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import '../../../data/services/auth_service.dart';  // Import AuthService

class ForgotPasswordController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();  // Get AuthService
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
        print('Submitting with phone/email: ${phoneOrEmailController.text}');
        bool success = await _authService.forgotPassword(phoneOrEmailController.text);
        print('API forgotPassword response: $success');
        if (success) {
          // Get.snackbar('Thành công', 'OTP mặc định là 111111');
          print('Navigating to /otp with argument: ${phoneOrEmailController.text}');
          Get.toNamed('/otp', arguments: phoneOrEmailController.text);
        } else {
          print('Navigation failed due to API response: $success');
        }
      } catch (e) {
        print('Error in submit: $e');
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