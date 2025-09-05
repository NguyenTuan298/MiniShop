import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

  Future<void> changePassword() async {
    // Lấy phone hoặc email từ profile đã lưu trong GetStorage
    final phone = GetStorage().read('profile_phone') ?? '';
    final email = GetStorage().read('profile_email') ?? '';
    final phoneEmail = phone.isNotEmpty ? phone : email;

    if (phoneEmail.isEmpty) {
      Get.snackbar('Lỗi', 'Không thể xác định tài khoản hiện tại');
      return;
    }

    // Hiển thị dialog để nhập mật khẩu mới
    String? newPassword = await _showChangePasswordDialog();
    if (newPassword == null || newPassword.isEmpty) {
      return; // Người dùng hủy hoặc không nhập
    }

    // Gọi resetPassword từ AuthService
    final success = await _authService.resetPassword(phoneEmail, newPassword);
    if (success) {
      Get.snackbar('Thành công', 'Mật khẩu đã được đặt lại thành công');
    } else {
      Get.snackbar('Lỗi', 'Đặt lại mật khẩu thất bại');
    }
  }

  Future<String?> _showChangePasswordDialog() async {
    String newPassword = '';
    return await Get.defaultDialog(
      title: 'Đặt lại mật khẩu',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Mật khẩu mới'),
            obscureText: true,
            onChanged: (value) => newPassword = value,
          ),
        ],
      ),
      textConfirm: 'Xác nhận',
      textCancel: 'Hủy',
      onConfirm: () {
        if (newPassword.length < 6) {
          Get.snackbar('Lỗi', 'Mật khẩu phải có ít nhất 6 ký tự');
          return;
        }
        Get.back(result: newPassword);
      },
      onCancel: () => Get.back(result: null),
    );
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