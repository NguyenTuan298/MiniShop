import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/modules/profile/controller/settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(theme),
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
                    _buildThemeSwitcher(theme, controller),

                    _buildMenuItem(
                      theme: theme,
                      title: 'Đổi mật khẩu',
                      onTap: controller.changePassword,
                    ),
                    _buildMenuItem(
                      theme: theme,
                      title: 'Xóa tài khoản',
                      onTap: controller.deleteAccount,
                    ),
                    _buildMenuItem(
                      theme: theme,
                      title: 'Log out',
                      onTap: controller.logout,
                      foregroundColor: theme.colorScheme.error,
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
              colors: [primary.withOpacity(0.65), primary],
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
          child: const Icon(Icons.settings_outlined, color: Colors.white, size: 48),
        ),
        const SizedBox(height: 16),
        Text(
          'Cài Đặt',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Công tắc bật/tắt theme theo đúng style light/dark
  Widget _buildThemeSwitcher(ThemeData theme, SettingsController controller) {
    return Obx(() {
      return Material(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () => controller.switchTheme(!controller.isDarkMode.value),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SizedBox(
              height: 44,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Chừa chỗ bên phải (≈ bề rộng Switch) để chữ thật sự ở giữa
                  Padding(
                    padding: const EdgeInsets.only(right: 64),
                    child: Text(
                      'Chế độ sáng/tối',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Switch(
                      value: controller.isDarkMode.value,
                      onChanged: controller.switchTheme,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildMenuItem({
    required ThemeData theme,
    required String title,
    required VoidCallback onTap,
    Color? foregroundColor,
    IconData? icon,
  }) {
    final baseFg = foregroundColor ?? theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: baseFg, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: baseFg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
