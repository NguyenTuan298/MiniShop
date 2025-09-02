import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/modules/home/view/home_view.dart';
import '../../cart/view/cart_view.dart';
import '../../order/view/order_history_view.dart';
import '../../profile/view/profile_view.dart';
import '../controller/dashboard_controller.dart';
import '../../category/view/category_list_view.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeView(), // Tab 0
      const CategoryListView(), // Tab 1 (Thể loại)
      const CartView(), // Tab 2
      const OrderHistoryView(), // Tab 3
      const ProfileView(),   // Tab 4
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.currentIndex.value,
        children: pages,
      )),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
            BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Thể loại'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Giỏ hàng'),
            BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Đơn đặt hàng'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Hồ sơ'),
          ],
        );
      }),
    );
  }
}
