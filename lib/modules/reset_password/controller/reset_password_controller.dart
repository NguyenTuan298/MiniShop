import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import '../../../data/services/auth_service.dart';  // Import AuthService

class ResetPasswordController extends GetxController {
  // Text editing controllers
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observables
  final isLoading = false.obs;
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisibility = false.obs;

  // Form key
  final formKey = GlobalKey<FormState>();

  late String phoneEmail;

  @override
  void onInit() {
    phoneEmail = Get.arguments as String;  // Get argument from previous screen
    super.onInit();
  }

  // Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    return null;
  }

  // Validate password confirmation
  String? validateConfirmPassword(String? value) {
    if (value != newPasswordController.text) {
      return 'Mật khẩu không khớp';
    }
    return null;
  }

  // Submit form
  Future<void> submitResetPassword() async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        isLoading.value = true;

        bool success = await Get.find<AuthService>().resetPassword(phoneEmail, newPasswordController.text);  // Call resetPassword
        if (success) {
          Get.offAllNamed('/login'); // Navigate to login after success
          Get.snackbar(
            'Thành công',
            'Đặt lại mật khẩu thành công',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Lỗi',
          'Đặt lại mật khẩu thất bại: ${e.toString()}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  // Toggle password visibility
  void toggleNewPasswordVisibility() => isNewPasswordVisible.toggle();
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisibility.toggle();

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}