// lib/views/profile/edit_profile_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/controllers/edit_profile_controller.dart';
import 'package:minishop/utils/theme.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());
    final theme = Theme.of(context);

    return Scaffold(
      // Thêm AppBar để có nút quay lại
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Image.asset('assets/images/logo.png', height: 35),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              _buildAvatarSection(),
              const Divider(height: 40, thickness: 1),
              _buildTextField(
                controller: controller.nameController,
                label: 'Họ tên:',
              ),
              _buildTextField(
                controller: controller.phoneController,
                label: 'SĐT:',
              ),
              _buildTextField(
                controller: controller.emailController,
                label: 'Email:',
              ),
              _buildTextField(
                controller: controller.genderController,
                label: 'Giới tính:',
              ),
              const SizedBox(height: 32),
              // Thêm nút Lưu thay đổi để người dùng có thể lưu thông tin
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Lưu thay đổi'),
                ),
              ),
              const SizedBox(height: 12),
              // Nút Log out
              _buildLogoutButton(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.orange.shade300, Colors.orange.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(Icons.person_outline, color: Colors.white, size: 48),
        ),
        const SizedBox(height: 16),
        const Text(
          'Chỉnh sửa thông tin',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(EditProfileController controller) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.logout,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          foregroundColor: Colors.red,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.logout, size: 20),
            SizedBox(width: 8),
            Text('Log out', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}