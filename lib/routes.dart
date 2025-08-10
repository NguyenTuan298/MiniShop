import 'package:get/get.dart';
import 'package:minishop/bindings/dashboard_binding.dart';
import 'package:minishop/views/dashboard/dashboard_view.dart';

class AppRoutes {
  static const dashboard = '/';
// Thêm các routes khác ở đây
}

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
  ];
}