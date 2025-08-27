import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/utils/theme.dart'; // Giả sử ThemeService của bạn ở đây

class SettingsController extends GetxController {
  // Biến reactive để lưu trạng thái của theme (tối/sáng).
  // .obs sẽ giúp UI tự động cập nhật khi giá trị này thay đổi.
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Khởi tạo trạng thái ban đầu dựa trên theme hiện tại của ứng dụng.
    // ThemeService().theme sẽ trả về ThemeMode.dark hoặc ThemeMode.light
    isDarkMode.value = ThemeService().theme == ThemeMode.dark;
  }

  /// CẬP NHẬT: Hàm này giờ nhận một giá trị bool từ công tắc (Switch)
  void switchTheme(bool newValue) {
    // 1. Cập nhật trạng thái trong controller để UI thay đổi ngay lập tức
    isDarkMode.value = newValue;

    // 2. Gọi ThemeService để thực hiện việc thay đổi và lưu theme
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