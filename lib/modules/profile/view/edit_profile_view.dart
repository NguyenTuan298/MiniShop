// lib/modules/profile/view/edit_profile_view.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/modules/profile/controller/edit_profile_controller.dart';
import 'package:minishop/modules/profile/controller/profile_controller.dart' show AvatarCore;

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EditProfileController>(); // dùng binding sẵn có
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Image.asset('assets/images/logo1.png', height: 35),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              _buildAvatarSection(theme, controller),
              const SizedBox(height: 12),
              Divider(
                height: 40,
                thickness: 1,
                color: theme.dividerColor.withOpacity(0.4),
              ),
              _buildTextField(
                theme: theme,
                controller: controller.nameController,
                label: 'Họ tên:',
              ),
              _buildTextField(
                theme: theme,
                controller: controller.phoneController,
                label: 'SĐT:',
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                theme: theme,
                controller: controller.emailController,
                label: 'Email:',
                keyboardType: TextInputType.emailAddress,
              ),
              _buildTextField(
                theme: theme,
                controller: controller.genderController,
                label: 'Giới tính:',
              ),
              _buildAddressField(
                theme: theme,
                controller: controller.addressController,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Lưu thay đổi'),
                ),
              ),
              // ⛔ ĐÃ BỎ nút Log out
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(ThemeData theme, EditProfileController controller) {
    return Obx(() {
      final path = AvatarCore.avatarPath.value;
      final primary = theme.colorScheme.primary;

      return Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: path == null
                      ? LinearGradient(
                    colors: [primary.withOpacity(0.6), primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.25),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: path == null
                    ? const Icon(Icons.person_outline, color: Colors.white, size: 48)
                    : Image.file(File(path), fit: BoxFit.cover),
              ),
              Material(
                color: theme.colorScheme.surface,
                shape: const CircleBorder(),
                child: IconButton(
                  onPressed: controller.changeAvatar,
                  icon: const Icon(Icons.edit, size: 18),
                  tooltip: 'Đổi ảnh',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Chỉnh sửa thông tin',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          // (tuỳ chọn) nút xoá ảnh
          if (AvatarCore.avatarPath.value != null) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: AvatarCore.clear,
              child: const Text('Gỡ ảnh'),
            ),
          ],
        ],
      );
    });
  }

  Widget _buildTextField({
    required ThemeData theme,
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
  }) {
    final fill = theme.colorScheme.surfaceVariant.withOpacity(
      theme.brightness == Brightness.dark ? 0.35 : 1.0,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: true,
          filled: true,
          fillColor: fill,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildAddressField({
    required ThemeData theme,
    required TextEditingController controller,
  }) {
    final fill = theme.colorScheme.surfaceVariant.withOpacity(
      theme.brightness == Brightness.dark ? 0.35 : 1.0,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.streetAddress,
        textInputAction: TextInputAction.newline,
        minLines: 2,
        maxLines: 4,
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          labelText: 'Địa chỉ:',
          alignLabelWithHint: true,
          filled: true,
          fillColor: fill,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        validator: (v) {
          if (v == null || v.trim().isEmpty) return 'Vui lòng nhập địa chỉ';
          if (v.trim().length < 5) return 'Địa chỉ quá ngắn';
          return null;
        },
      ),
    );
  }
}
