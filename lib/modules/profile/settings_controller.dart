// lib/controllers/settings_controller.dart

import 'package:get/get.dart';
import 'package:minishop/utils/theme.dart';

class SettingsController extends GetxController {

  /// Chuyển đổi theme sáng/tối
  void switchTheme() {
    ThemeService().switchTheme();
  }

  /// Các hàm giả lập cho các chức năng khác
  void changePassword() {
    Get.snackbar('Thông báo', 'Chức năng Đổi mật khẩu đang được phát triển.');
  }

  void deleteAccount() {
    Get.snackbar('Thông báo', 'Chức năng Xóa tài khoản đang được phát triển.');
  }

  void logout() {
    Get.snackbar('Thông báo', 'Người dùng đã đăng xuất.');
  }
}