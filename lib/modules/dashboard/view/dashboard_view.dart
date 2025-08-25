import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/modules/cart/view/cart_view.dart';
// FIX: Sửa "package." thành "package:"
import 'package:minishop/modules/category/view/category_list_view.dart';
// FIX: Sửa "package." thành "package:"
import 'package:minishop/modules/dashboard/controller/dashboard_controller.dart';
import 'package:minishop/modules/home/view/home_view.dart';
import 'package:minishop/modules/order/view/order_history_view.dart';
import 'package:minishop/modules/profile/view/profile_view.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  // =======================================================================
  // ĐÂY LÀ APPBAR VỚI LOGO MÀ BẠN ĐÃ XÓA TỪ HOMEVIEW
  // Nó sẽ được hiển thị khi tab Trang chủ (index 0) được chọn.
  // =======================================================================
  AppBar _buildHomeAppBar() {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/images/logo1.png'),
      ),
      leadingWidth: 200,
      centerTitle: false,
      // Bạn có thể thêm các thuộc tính khác cho AppBar ở đây nếu cần
    );
  }

  // Đây là AppBar cho màn hình Thể loại
  AppBar _buildCategoryAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Thể Loại'),
      // Tùy chỉnh thêm nếu cần
    );
  }

  // Đây là AppBar chung cho các màn hình còn lại
  AppBar _buildGenericAppBar(String title) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
    );
  }


  @override
  Widget build(BuildContext context) {
    // Danh sách các màn hình tương ứng với mỗi tab
    final List<Widget> screens = [
      const HomeView(),
      const CategoryListView(),
      const CartView(),
      const OrderHistoryView(),
      const ProfileView(),
    ];

    // =======================================================================
    // SCAFFOLD CHUNG ĐƯỢC ĐẶT TẠI ĐÂY
    // =======================================================================
    return Scaffold(
      // FIX: Bọc Obx bằng một PreferredSize widget
      appBar: PreferredSize(
        // Cung cấp chiều cao tiêu chuẩn của một AppBar
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(() {
          int currentIndex = controller.tabIndex.value;
          switch (currentIndex) {
            case 0: // Tab Trang chủ
              return _buildHomeAppBar();
            case 1: // Tab Thể Loại
              return _buildCategoryAppBar(context);
            case 2: // Tab Giỏ hàng
              return _buildGenericAppBar('Giỏ Hàng');
            case 3: // Tab Đơn hàng
              return _buildGenericAppBar('Đơn Hàng Của Bạn');
            case 4: // Tab Hồ sơ
              return _buildGenericAppBar('Hồ Sơ');
            default:
              return _buildHomeAppBar();
          }
        }),
      ),

      // Body sẽ hiển thị màn hình tương ứng với tab được chọn
      body: Obx(() => IndexedStack(
        index: controller.tabIndex.value,
        children: screens,
      )),

      // Thanh điều hướng dưới cùng cố định
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          onTap: controller.changeTabIndex,
          currentIndex: controller.tabIndex.value,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Trang chủ'),
            BottomNavigationBarItem(icon: Icon(Icons.apps_outlined), label: 'Thể Loại'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Giỏ hàng'),
            BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Đơn hàng'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Hồ sơ'),
          ],
        ),
      ),
    );
  }
}