import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/modules/support/controller/support_controller.dart';
// import 'package:minishop/utils/theme.dart'; // Giả sử AppTheme nằm ở đây

// FIX: Chuyển sang GetView để tuân thủ best practice của GetX
class SupportView extends GetView<SupportController> {
  const SupportView({super.key});

  @override
  Widget build(BuildContext context) {
    // FIX: Dòng này đã được loại bỏ. Controller giờ đây được truy cập trực tiếp
    // thông qua 'controller' property của GetView.
    // final controller = Get.put(SupportController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Thêm AppBar để người dùng có thể quay lại màn hình trước đó
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
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
                  child: ElevatedButton( // Thay bằng ElevatedButton cho nổi bật
                    onPressed: controller.submitSupportRequest,
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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

  //... các hàm helper _buildHeader và _buildTextField giữ nguyên ...
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset('assets/images/logo1.png', height: 40),
        const SizedBox(height: 16),
        const Text('Liên hệ hỗ trợ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[200],
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