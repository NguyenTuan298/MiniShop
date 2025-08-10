// lib/views/dashboard/dashboard_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/controllers/dashboard_controller.dart';
import 'package:minishop/views/cart/cart_view.dart';
import 'package:minishop/views/category/category_list_view.dart';
import 'package:minishop/views/home/home_view.dart';
import 'package:minishop/views/order/order_history_view.dart';
import 'package:minishop/views/profile/profile_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    final List<Widget> screens = [
      const HomeView(),
      const CategoryListView(),
      const CartView(),
      const OrderHistoryView(), // <-- Thay thế placeholder
      const ProfileView(),
    ];

    return Scaffold(
      // Body sẽ hiển thị màn hình tương ứng với tab được chọn
      // IndexedStack giữ state của các tab không bị mất khi chuyển đổi
      body: Obx(() => IndexedStack(
        index: controller.tabIndex.value,
        children: screens,
      )),

      // Thanh điều hướng dưới cùng
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          onTap: controller.changeTabIndex,
          currentIndex: controller.tabIndex.value,
          type: BottomNavigationBarType.fixed, // Để hiển thị tất cả label
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Trang chủ'),
            BottomNavigationBarItem(icon: Icon(Icons.apps_outlined), label: 'Thể Loại'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Giỏ hàng'),
            BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Đơn đặt hàng'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Hồ sơ'),
          ],
        ),
      ),
    );
  }
}