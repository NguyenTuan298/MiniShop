// lib/controllers/support_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/controllers/dashboard_controller.dart';
import 'package:minishop/routes.dart';

class SupportController extends GetxController {
  // Dùng TextEditingController để quản lý các ô nhập liệu
  late TextEditingController subjectController;
  late TextEditingController messageController;
  late TextEditingController orderIdController;

  // Dùng GlobalKey để quản lý Form và validate
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();

    // Khởi tạo các controller
    subjectController = TextEditingController();
    messageController = TextEditingController();
    orderIdController = TextEditingController();

    // Lấy ID đơn hàng được truyền từ màn hình trước và tự động điền
    if (Get.arguments is String) {
      final orderId = Get.arguments as String;
      orderIdController.text = orderId;
    }
  }

  /// CẬP NHẬT: Xử lý khi người dùng nhấn nút "Gửi tin nhắn"
  void submitSupportRequest() {
    if (formKey.currentState!.validate()) {
      // Trong ứng dụng thật, bạn sẽ gửi dữ liệu lên API ở đây.

      // Sau khi gửi thành công, điều hướng đến màn hình xác nhận.
      // Dùng offNamed để thay thế màn hình form hiện tại.
      Get.offNamed(AppRoutes.supportSent);
    }
  }

  /// HÀM MỚI: Điều hướng về tab Trang chủ
  void goToHome() {
    Get.until((route) => Get.currentRoute == AppRoutes.dashboard);
    Get.find<DashboardController>().changeTabIndex(0);
  }

  /// HÀM MỚI: Điều hướng về tab Đơn đặt hàng
  void goToOrders() {
    Get.until((route) => Get.currentRoute == AppRoutes.dashboard);
    Get.find<DashboardController>().changeTabIndex(3);
  }

  @override
  void onClose() {
    subjectController.dispose();
    messageController.dispose();
    orderIdController.dispose();
    super.onClose();
  }
}
