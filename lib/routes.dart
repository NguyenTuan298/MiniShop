// lib/routes.dart

import 'package:get/get.dart';
import 'package:minishop/modules/dashboard/dashboard_binding.dart';
import 'package:minishop/modules/order/order_binding.dart';
import 'package:minishop/modules/product/product_binding.dart';
import 'package:minishop/modules/dashboard/dashboard_view.dart';
import 'package:minishop/modules/product/product_grid_view.dart';
import 'package:minishop/modules/order/checkout_view.dart';
// Sửa lại import, trỏ đến file mới và không cần bí danh 'as' nữa
import 'package:minishop/modules/order/order_history_view.dart';
import 'package:minishop/modules/order/order_detail_view.dart';
import 'package:minishop/modules/order/order_success_view.dart';
import 'package:minishop/modules/order/order_history_view.dart';
import 'package:minishop/modules/support/support_view.dart';
import 'package:minishop/modules/support/support_sent_view.dart';
import 'package:minishop/modules/home/home_view.dart';
import 'package:minishop/modules/profile/settings_view.dart';
import 'package:minishop/modules/profile/edit_profile_binding.dart';
import 'package:minishop/modules/profile/edit_profile_view.dart';


class AppRoutes {
  static const home = '/home';
  static const dashboard = '/dashboard';
  static const productGrid = '/product-grid';
  static const checkout = '/checkout';
  static const orderSuccess = '/order-success';
  static const orderHistory = '/order-history';
  static const orderDetail = '/order-detail';
  static const support = '/support';
  static const supportSent = '/support-sent';
  static const settings = '/settings';
  static const editProfile = '/edit-profile';
}

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
    ),
    GetPage(
      name: AppRoutes.productGrid,
      page: () => const ProductGridView(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutView(),
      binding: OrderBinding(),
    ),
    // Sửa lại định nghĩa trang này
    GetPage(
      name: AppRoutes.orderHistory,
      // Trỏ đến đúng class OrderHistoryView từ file mới
      page: () => const OrderHistoryView(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: AppRoutes.orderSuccess,
      page: () => const OrderSuccessView(),
      binding: OrderBinding(),
    ),
    // Thêm trang mới
    GetPage(
      name: AppRoutes.orderDetail,
      page: () => const OrderDetailView(),
    ),
    GetPage(
      name: AppRoutes.support,
      page: () => const SupportView(),
    ),
    GetPage(
      name: AppRoutes.supportSent,
      page: () => const SupportSentView(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(), // <-- Sử dụng binding mới
    ),
  ];
}