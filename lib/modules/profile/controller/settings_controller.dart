import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/utils/theme.dart';

import '../../../data/services/auth_service.dart';

class SettingsController extends GetxController {
  final AuthService _authService = Get.find();
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Khởi tạo trạng thái ban đầu dựa trên theme hiện tại của ứng dụng.
    // ThemeService().theme sẽ trả về ThemeMode.dark hoặc ThemeMode.light
    isDarkMode.value = ThemeService().theme == ThemeMode.dark;
  }

  void switchTheme(bool newValue) {
    isDarkMode.value = newValue;
    ThemeService().switchTheme();
  }

  void changePassword() {
    Get.snackbar('Thông báo', 'Chức năng Đổi mật khẩu đang được phát triển.');
  }

  void deleteAccount() {
    Get.snackbar('Thông báo', 'Chức năng Xóa tài khoản đang được phát triển.');
  }

  Future<void> logout() async {
    await _authService.logout();
  }
}