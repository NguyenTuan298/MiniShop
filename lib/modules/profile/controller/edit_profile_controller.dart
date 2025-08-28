// lib/controllers/edit_profile_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  // Dùng TextEditingController để quản lý các ô nhập liệu
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController genderController;
  late TextEditingController addressController;

  // Dùng GlobalKey để quản lý Form và validate (nếu cần)
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();

    // Khởi tạo các controller với dữ liệu người dùng hiện tại (giả lập)
    nameController = TextEditingController(text: 'User 1');
    phoneController = TextEditingController(text: '0123456789');
    emailController = TextEditingController(text: 'user1@email.com');
    genderController = TextEditingController(text: 'Nam');
    addressController = TextEditingController(text: 'Quận 12, Tân Chánh HIệp');
  }

  /// Xử lý khi người dùng nhấn nút "Lưu thay đổi"
  void saveProfile() {
    // Trong ứng dụng thật, bạn sẽ lấy dữ liệu và gửi lên API để cập nhật
    final name = nameController.text;
    final phone = phoneController.text;
    // ...

    debugPrint('Đã lưu thông tin mới: $name, $phone');

    // Sau khi lưu thành công, quay lại màn hình trước đó
    Get.back();
    Get.snackbar(
      'Thành công',
      'Thông tin cá nhân của bạn đã được cập nhật.',
      snackPosition: SnackPosition.TOP,
    );
  }

  /// Xử lý đăng xuất
  void logout() {
    Get.snackbar('Thông báo', 'Người dùng đã đăng xuất.');
  }

  @override
  void onClose() {
    // Dọn dẹp các controller để tránh rò rỉ bộ nhớ
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    genderController.dispose();
    addressController.dispose();
    super.onClose();
  }
}