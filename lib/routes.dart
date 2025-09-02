import 'package:get/get.dart';
import 'package:minishop/modules/dashboard/binding/dashboard_binding.dart';
import 'package:minishop/modules/order/binding/order_binding.dart';
import 'package:minishop/modules/dashboard/view/dashboard_view.dart';
import 'package:minishop/modules/order/view/checkout_view.dart';
import 'package:minishop/modules/order/view/order_history_view.dart';
import 'package:minishop/modules/order/view/order_detail_view.dart';
import 'package:minishop/modules/order/view/order_success_view.dart';
import 'package:minishop/modules/product/fashion/view/fashion_view.dart';
import 'package:minishop/modules/support/view/support_view.dart';
import 'package:minishop/modules/support/binding/support_binding.dart';
import 'package:minishop/modules/support/view/support_sent_view.dart';
import 'package:minishop/modules/home/view/home_view.dart';
import 'package:minishop/modules/profile/view/settings_view.dart';
import 'package:minishop/modules/profile/binding/edit_profile_binding.dart';
import 'package:minishop/modules/profile/view/edit_profile_view.dart';
import 'modules/home/binding/home_binding.dart';
import 'modules/otp/binding/otp_binding.dart';
import 'modules/otp/view/otp_view.dart';
import 'modules/forgot_password/binding/forgot_password_binding.dart';
import 'modules/forgot_password/view/forgot_password_view.dart';
import 'modules/login/binding/login_binding.dart';
import 'modules/login/view/login_view.dart';
import 'modules/product/Electronics/binding/electronics_binding.dart';
import 'modules/product/Electronics/view/electronics_view.dart';
import 'modules/product/beverage/binding/beverage_binding.dart';
import 'modules/product/beverage/view/beverage_view.dart';
import 'modules/product/cosmetics - beauty/binding/cosmetics_beauty_binding.dart';
import 'modules/product/cosmetics - beauty/view/cosmetics_beauty_view.dart';
import 'modules/product/fashion/binding/fashion_binding.dart';
import 'modules/product/food/binding/food_binding.dart';
import 'modules/product/food/view/food_view.dart';
import 'modules/product/household/binding/household_binding.dart';
import 'modules/product/household/view/household_view.dart';
import 'modules/product/life - utilities/binding/life_utilities_binding.dart';
import 'modules/product/life - utilities/view/life_utilities_view.dart';
import 'modules/product/sports/binding/sports_binding.dart';
import 'modules/product/sports/view/sports_view.dart';
import 'modules/product/toys - entertainment/binding/toys_entertainment_binding.dart';
import 'modules/product/toys - entertainment/view/toys_entertainment_view.dart';
import 'modules/product/travel/binding/travel_binding.dart';
import 'modules/product/travel/view/travel_view.dart';
import 'modules/register/binding/register_binding.dart';
import 'modules/register/view/register_view.dart';
import 'modules/reset_password/binding/reset_password_binding.dart';
import 'modules/reset_password/view/reset_password_view.dart';
import 'modules/splash/binding/splash_binding.dart';
import 'modules/splash/view/splash_view.dart';
import 'package:minishop/modules/order_information/view/order_information_view.dart';
import 'package:minishop/modules/order_information/binding/order_information_binding.dart';

class AppRoutes {
  static const home = '/home';
  static const dashboard = '/dashboard';
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
  static const orderInformation = '/order-information';
  static const ELECTRONICS = '/electronics';
  static const COSMETICS_BEAUTY = '/cosmetics-beauty';
  static const FASHION = '/fashion';
  static const FOOD = '/food';
  static const BEVERAGE = '/beverage';
  static const HOUSEHOLD = '/household';
  static const LIFE_UTILITIES = '/life-utilities';
  static const SPORTS = '/sports';
  static const TRAVEL = '/travel';
  static const TOYS_ENTERTAINMENT = '/toys-entertainment';


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
      binding: HomeBinding(),
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
    GetPage(
      name: AppRoutes.orderInformation,
      page: () => const OrderInformationView(),
      binding: OrderInformationBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.ELECTRONICS,
      page: () => const ElectronicsView(),
      binding: ElectronicsBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.COSMETICS_BEAUTY,
      page: () => const CosmeticsBeautyView(),
      binding: CosmeticsBeautyBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.FASHION,
      page: () => const FashionView(),
      binding: FashionBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.FOOD,
      page: () => const FoodView(),
      binding: FoodBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.BEVERAGE,
      page: () => const BeverageView(),
      binding: BeverageBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.HOUSEHOLD,
      page: () => const HouseholdView(),
      binding: HouseholdBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.LIFE_UTILITIES,
      page: () => const LifeUtilitiesView(),
      binding: LifeUtilitiesBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.SPORTS,
      page: () => const SportsView(),
      binding: SportsBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.TRAVEL,
      page: () => const TravelView(),
      binding: TravelBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.TOYS_ENTERTAINMENT,
      page: () => const ToysEntertainmentView(),
      binding: ToysEntertainmentBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
  ];
}