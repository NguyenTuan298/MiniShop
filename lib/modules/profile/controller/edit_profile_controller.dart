// lib/controllers/edit_profile_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minishop/modules/profile/service/profile_service.dart';

class EditProfileController extends GetxController {
  // TextEditingControllers
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController genderController;
  late TextEditingController addressController;

  // Form key
  final formKey = GlobalKey<FormState>();

  // Storage
  final _box = GetStorage();

  // Keys lưu trữ
  static const _kName = 'profile_name';
  static const _kPhone = 'profile_phone';
  static const _kEmail = 'profile_email';
  static const _kGender = 'profile_gender';
  static const _kAddress = 'profile_address';

  @override
  void onInit() {
    super.onInit();
    // Đọc dữ liệu đã lưu (nếu có), nếu chưa có dùng giá trị mặc định một lần duy nhất
    nameController    = TextEditingController(text: _box.read<String>(_kName)    ?? 'User 1');
    phoneController   = TextEditingController(text: _box.read<String>(_kPhone)   ?? '0123456789');
    emailController   = TextEditingController(text: _box.read<String>(_kEmail)   ?? 'user1@email.com');
    genderController  = TextEditingController(text: _box.read<String>(_kGender)  ?? 'Nam');
    addressController = TextEditingController(text: _box.read<String>(_kAddress) ?? 'Quận 12, Tân Chánh HIệp');
  }

  /// Lưu hồ sơ vào GetStorage rồi quay lại
  void saveProfile() {
    // Nếu có validate: if (!(formKey.currentState?.validate() ?? true)) return;

    // Lưu vào GetStorage như bạn đã làm
    _box.write(_kName,    nameController.text.trim());
    _box.write(_kPhone,   phoneController.text.trim());
    _box.write(_kEmail,   emailController.text.trim());
    _box.write(_kGender,  genderController.text.trim());
    _box.write(_kAddress, addressController.text.trim());

    // Đồng thời cập nhật ProfileService để UI các màn khác phản ứng tức thì
    final profile = Get.find<ProfileService>();
    profile.saveAll(
      name: nameController.text,
      phone: phoneController.text,
      email: emailController.text,
      gender: genderController.text,
      address: addressController.text,
    );

    Get.back();
    Get.snackbar(
      'Thành công',
      'Thông tin cá nhân của bạn đã được cập nhật.',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  void logout() {
    Get.snackbar('Thông báo', 'Người dùng đã đăng xuất.');
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    genderController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
