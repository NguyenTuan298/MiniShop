// lib/views/profile/profile_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/controllers/profile_controller.dart';
import 'package:minishop/utils/theme.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Khởi tạo và tìm controller cho màn hình này
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Column(
                  children: [
                    _buildAvatarSection(),
                    const Divider(height: 40, thickness: 1),
                    _buildProfileMenuItem(
                      icon: Icons.receipt_long_outlined,
                      title: 'Đơn hàng của tôi',
                      onTap: controller.navigateToMyOrders,
                    ),
                    _buildProfileMenuItem(
                      icon: Icons.info_outline,
                      title: 'Chỉnh sửa thông tin',
                      onTap: controller.editProfile,
                    ),
                    _buildProfileMenuItem(
                      icon: Icons.settings_outlined,
                      title: 'Cài Đặt',
                      onTap: controller.goToSettings,
                    ),
                    _buildProfileMenuItem(
                      icon: Icons.logout,
                      title: 'Log out',
                      onTap: controller.logout,
                      color: Colors.red, // Màu đặc biệt cho nút logout
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Image.asset('assets/images/logo1.png', height: 40),
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
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
          ),
          child: const Icon(Icons.person_outline, color: Colors.white, size: 48),
        ),
        const SizedBox(height: 16),
        const Text(
          'User 1',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}