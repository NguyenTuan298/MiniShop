import 'package:get/get.dart';
import 'package:minishop/modules/dashboard/binding/dashboard_binding.dart';
import 'package:minishop/modules/order/binding/order_binding.dart';
import 'package:minishop/modules/product/binding/product_binding.dart';
import 'package:minishop/modules/dashboard/view/dashboard_view.dart';
import 'package:minishop/modules/product/view/product_grid_view.dart';
import 'package:minishop/modules/order/view/checkout_view.dart';
import 'package:minishop/modules/order/view/order_history_view.dart';
import 'package:minishop/modules/order/view/order_detail_view.dart';
import 'package:minishop/modules/order/view/order_success_view.dart';
import 'package:minishop/modules/support/view/support_view.dart';
import 'package:minishop/modules/support/binding/support_binding.dart';
import 'package:minishop/modules/support/view/support_sent_view.dart';
import 'package:minishop/modules/home/view/home_view.dart';
import 'package:minishop/modules/profile/view/settings_view.dart';
import 'package:minishop/modules/profile/binding/edit_profile_binding.dart';
import 'package:minishop/modules/profile/view/edit_profile_view.dart';
import 'modules/otp/binding/otp_binding.dart';
import 'modules/otp/view/otp_view.dart';
import 'modules/forgot_password/binding/forgot_password_binding.dart';
import 'modules/forgot_password/view/forgot_password_view.dart';
import 'modules/login/binding/login_binding.dart';
import 'modules/login/view/login_view.dart';
import 'modules/register/binding/register_binding.dart';
import 'modules/register/view/register_view.dart';
import 'modules/reset_password/binding/reset_password_binding.dart';
import 'modules/reset_password/view/reset_password_view.dart';
import 'modules/splash/binding/splash_binding.dart';
import 'modules/splash/view/splash_view.dart';

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
  static const splash = '/splash';
  static const register = '/register';
  static const login = '/login';
  static const forgotPassword = '/forgot-password';
  static const otp = '/otp';
  static const resetPassword = '/reset-password';
}

class AppPages {
  static const INITIAL = '/splash';

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.productGrid,
      page: () => const ProductGridView(),
      binding: ProductBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutView(),
      binding: OrderBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.orderHistory,
      page: () => const OrderHistoryView(),
      binding: OrderBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.orderSuccess,
      page: () => const OrderSuccessView(),
      binding: OrderBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.orderDetail,
      page: () => const OrderDetailView(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.support,
      page: () => const SupportView(),
      binding: SupportBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.supportSent,
      page: () => const SupportSentView(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.otp,
      page: () => const OtpView(),
      binding: OtpBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => const ResetPasswordView(),
      binding: ResetPasswordBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}