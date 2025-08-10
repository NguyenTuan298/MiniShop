// lib/views/profile/settings_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/controllers/settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    return Scaffold(
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
                    _buildMenuItem(
                      title: 'Chế độ sáng/ tối',
                      onTap: controller.switchTheme,
                    ),
                    _buildMenuItem(
                      title: 'Đổi mật khẩu',
                      onTap: controller.changePassword,
                    ),
                    _buildMenuItem(
                      title: 'Xóa tài khoản',
                      onTap: controller.deleteAccount,
                    ),
                    _buildMenuItem(
                      title: 'Log out',
                      onTap: controller.logout,
                      color: Colors.red,
                      icon: Icons.logout,
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
          ),
          child: const Icon(Icons.person_outline, color: Colors.white, size: 48),
        ),
        const SizedBox(height: 16),
        const Text(
          'Cài Đặt',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}