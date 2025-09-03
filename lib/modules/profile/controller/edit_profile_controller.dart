// lib/controllers/edit_profile_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minishop/modules/profile/service/profile_service.dart';

class EditProfileController extends GetxController {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController genderController;
  late TextEditingController addressController;

  final formKey = GlobalKey<FormState>();
  final _box = GetStorage();

  static const _kName = 'profile_name';
  static const _kPhone = 'profile_phone';
  static const _kEmail = 'profile_email';
  static const _kGender = 'profile_gender';
  static const _kAddress = 'profile_address';

  @override
  void onInit() {
    super.onInit();

    // 1) Khởi tạo theo GetStorage (fallback an toàn)
    nameController    = TextEditingController(text: _box.read<String>(_kName)    ?? 'User 1');
    phoneController   = TextEditingController(text: _box.read<String>(_kPhone)   ?? '0123456789');
    emailController   = TextEditingController(text: _box.read<String>(_kEmail)   ?? 'user1@email.com');
    genderController  = TextEditingController(text: _box.read<String>(_kGender)  ?? 'Nam');
    addressController = TextEditingController(text: _box.read<String>(_kAddress) ?? 'Quận 12, Tân Chánh HIệp');

    // 2) 👉 Ghi đè bằng snapshot MỚI NHẤT từ ProfileService (đã được AuthService cập nhật sau đăng ký/đăng nhập)
    _hydrateFromProfile();
  }

  void _hydrateFromProfile() {
    if (!Get.isRegistered<ProfileService>()) return;
    final p = Get.find<ProfileService>();

    nameController.text    = p.name.value;
    phoneController.text   = p.phone.value;
    emailController.text   = p.email.value;
    genderController.text  = p.gender.value;
    addressController.text = p.address.value;
  }

  void saveProfile() {
    _box.write(_kName,    nameController.text.trim());
    _box.write(_kPhone,   phoneController.text.trim());
    _box.write(_kEmail,   emailController.text.trim());
    _box.write(_kGender,  genderController.text.trim());
    _box.write(_kAddress, addressController.text.trim());

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
