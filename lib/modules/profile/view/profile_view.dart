import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/modules/profile/controller/profile_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Cho title ở giữa
        title: Image.asset(
          'assets/images/logo1.png',
          height: 30, // Chiều cao logo
          fit: BoxFit.contain,
        ),
        backgroundColor: Colors.white70,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Column(
                  children: [
                    _buildAvatarSection(theme),
                    const SizedBox(height: 12),
                    Divider(
                      height: 40,
                      thickness: 1,
                      color: theme.dividerColor.withOpacity(0.4),
                    ),
                    _buildProfileMenuItem(
                      theme: theme,
                      icon: Icons.receipt_long_outlined,
                      title: 'Đơn hàng của tôi',
                      onTap: controller.navigateToMyOrders,
                    ),
                    _buildProfileMenuItem(
                      theme: theme,
                      icon: Icons.info_outline,
                      title: 'Chỉnh sửa thông tin',
                      onTap: controller.editProfile,
                    ),
                    _buildProfileMenuItem(
                      theme: theme,
                      icon: Icons.settings_outlined,
                      title: 'Cài Đặt',
                      onTap: controller.goToSettings,
                    ),
                    _buildProfileMenuItem(
                      theme: theme,
                      icon: Icons.logout,
                      title: 'Log out',
                      onTap: controller.logout,
                      // dùng màu lỗi của theme thay vì Colors.red
                      foregroundColor: theme.colorScheme.error,
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

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Image.asset('assets/images/logo1.png', height: 40),
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
              colors: [
                primary.withOpacity(0.65),
                primary,
              ],
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
          'User 1',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildProfileMenuItem({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? foregroundColor,
  }) {
    // Nền thẻ phù hợp light/dark
    final tileColor = theme.cardColor;
    // Màu chữ/icon mặc định dựa trên onSurface
    final baseFg = foregroundColor ?? theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        color: tileColor,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: baseFg),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: baseFg,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: baseFg.withOpacity(0.7)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
