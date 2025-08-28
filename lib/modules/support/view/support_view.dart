import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/modules/support/controller/support_controller.dart';

// Dùng GetView để truy cập controller qua 'controller'
class SupportView extends GetView<SupportController> {
  const SupportView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // KHÔNG set màu nền cứng -> theo theme
      appBar: AppBar(
        // Không set background/icon màu cứng; để AppBarTheme quyết định
        elevation: theme.appBarTheme.elevation ?? 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: controller.subjectController,
                  label: 'Chủ đề',
                  hint: 'ví dụ: Sự cố với đơn hàng #111',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập chủ đề';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: controller.messageController,
                  label: 'tin nhắn của bạn ( kèm theo email liên hệ)',
                  hint: 'Hãy mô tả vấn đề của đơn hàng',
                  maxLines: 6,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tin nhắn';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: controller.orderIdController,
                  label: 'ID đơn hàng liên quan',
                  hint: 'ví dụ: #111',
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.submitSupportRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Gửi tin nhắn'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helpers ---

  // Dùng Get.theme để không phải truyền BuildContext
  Widget _buildHeader() {
    final theme = Get.theme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset('assets/images/logo1.png', height: 40),
        const SizedBox(height: 16),
        Text(
          'Liên hệ hỗ trợ',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final theme = Get.theme;
    final hintColor = theme.colorScheme.onSurface.withOpacity(0.5);
    final fill = theme.colorScheme.surfaceVariant.withOpacity(
      theme.brightness == Brightness.dark ? 0.35 : 1.0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(color: hintColor),
            filled: true,
            fillColor: fill,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ],
    );
  }
}
