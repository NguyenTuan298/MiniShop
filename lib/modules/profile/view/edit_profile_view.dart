// lib/views/profile/edit_profile_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/modules/profile/controller/edit_profile_controller.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Image.asset('assets/images/logo1.png', height: 35),
        centerTitle: true,
        // không set màu cứng -> theo appBarTheme của theme
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              _buildAvatarSection(theme),
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
              const SizedBox(height: 12),
              _buildLogoutButton(theme, controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(ThemeData theme) {
    final primary = theme.colorScheme.primary;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [primary.withOpacity(0.6), primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.25),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
          ),
          child: const Icon(Icons.person_outline, color: Colors.white, size: 48),
        ),
        const SizedBox(height: 16),
        Text(
          'Chỉnh sửa thông tin',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
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

  Widget _buildLogoutButton(ThemeData theme, EditProfileController controller) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.logout,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.error,
          foregroundColor: theme.colorScheme.onError,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, size: 20),
            const SizedBox(width: 8),
            Text(
              'Log out',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onError,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
