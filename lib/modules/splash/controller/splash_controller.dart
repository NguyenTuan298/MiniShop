  import 'package:get/get.dart';
  import 'package:minishop/data/services/auth_service.dart';
  import 'package:minishop/routes.dart';

  class SplashController extends GetxController {
    final AuthService _authService = Get.find();

    @override
    void onReady() {
      super.onReady();
      Future.delayed(const Duration(seconds: 6), () async {
        try {
          final isLoggedIn = await _authService.isLoggedIn();
          Get.offAllNamed(isLoggedIn ? AppRoutes.dashboard : AppRoutes.login);
        } catch (e) {
          // Xử lý lỗi (nếu có), chuyển về login mặc định
          Get.offAllNamed(AppRoutes.login);
          print('Splash error: $e');
        }
      });
    }
  }