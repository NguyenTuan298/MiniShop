// lib/views/dashboard/dashboard_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/controllers/dashboard_controller.dart';
import 'package:minishop/views/category/category_list_view.dart'; // Thêm import
import 'package:minishop/views/home/home_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    final List<Widget> screens = [
      const HomeView(),
      const CategoryListView(), // <-- Thay thế widget placeholder
      const Center(child: Text("Giỏ Hàng")),
      const Center(child: Text("Đơn Đặt Hàng")),
      const Center(child: Text("Hồ Sơ")),
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.tabIndex.value,
        children: screens,
      )),
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          onTap: controller.changeTabIndex,
          currentIndex: controller.tabIndex.value,
          // Giữ nguyên các items
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