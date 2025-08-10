// lib/controllers/profile_controller.dart

import 'package:get/get.dart';
import 'package:minishop/modules/dashboard/dashboard_controller.dart';
import 'package:minishop/routes.dart';

class ProfileController extends GetxController {

  /// Điều hướng người dùng đến tab "Đơn đặt hàng"
  void navigateToMyOrders() {
    // Tìm DashboardController đã được khởi tạo
    final dashboardController = Get.find<DashboardController>();
    // Thay đổi index của tab sang "Đơn đặt hàng" (vị trí thứ 4, index = 3)
    dashboardController.changeTabIndex(3);
  }

  /// Xử lý hành động chỉnh sửa thông tin (chức năng giả lập)
  void editProfile() {
    Get.toNamed(AppRoutes.editProfile);
  }

  /// Xử lý hành động vào Cài đặt (chức năng giả lập)
  void goToSettings() {
    Get.toNamed(AppRoutes.settings);
  }

  /// Xử lý hành động đăng xuất (chức năng giả lập)
  void logout() {
    // Trong ứng dụng thật, bạn sẽ gọi đến AuthController để xử lý đăng xuất
    Get.snackbar('Thông báo', 'Người dùng đã đăng xuất.');
  }
}