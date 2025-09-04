import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/utils/theme.dart';

import '../../../data/services/auth_service.dart';
import 'package:minishop/modules/profile/controller/profile_controller.dart' show AvatarCore;

class SettingsController extends GetxController {
  final AuthService _authService = Get.find();
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Khởi tạo trạng thái ban đầu dựa trên theme hiện tại của ứng dụng.
    // ThemeService().theme sẽ trả về ThemeMode.dark hoặc ThemeMode.light
    isDarkMode.value = ThemeService().theme == ThemeMode.dark;
    AvatarCore.ensureLoaded(); // ⬅️ load avatar
  }

  void switchTheme(bool newValue) {
    isDarkMode.value = newValue;
    ThemeService().switchTheme();
  }

  void changePassword() {
    Get.snackbar('Thông báo', 'Chức năng Đổi mật khẩu đang được phát triển.');
  }

  Future<void> deleteAccount() async {
    await _authService.deleteAccount();
  }

  Future<void> logout() async {
    await _authService.logout();
    await AvatarCore.clear();
  }
  Future<void> changeAvatar() async {
    await AvatarCore.pickFromGallery();
  }
}