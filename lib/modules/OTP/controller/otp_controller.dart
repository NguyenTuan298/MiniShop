import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  // Controllers
  final otpController = TextEditingController();

  // States
  final isLoading = false.obs;
  final countdown = 60.obs;
  final canResend = false.obs;

  @override
  void onInit() {
    startCountdown();
    super.onInit();
  }

  void startCountdown() {
    canResend.value = false;
    countdown.value = 60;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      countdown.value--;
      if (countdown.value == 0) {
        canResend.value = true;
        return false;
      }
      return true;
    });
  }

  Future<void> verifyOtp() async {
    if (otpController.text.length != 6) return;

    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      Get.offAllNamed('/home'); // Navigate after success
      Get.snackbar(
        'Thành công',
        'Xác thực OTP thành công',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Xác thực OTP thất bại: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1)); // Simulate resend

      startCountdown();
      Get.snackbar(
        'Thành công',
        'Đã gửi lại mã OTP',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Gửi lại OTP thất bại',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}