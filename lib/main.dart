import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // <-- THÊM DÒNG NÀY
import 'package:minishop/routes.dart';
import 'package:minishop/utils/theme.dart';
import 'package:minishop/data/services/auth_service.dart';
import 'package:minishop/modules/profile/service/profile_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();// init storage trước khi runApp
  Get.put(ProfileService(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthService());     // Khởi tạo AuthService toàn cục
    return GetMaterialApp(
      title: 'Minishop',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeService().theme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.dashboard,
      getPages: AppPages.routes,
    );
  }
}
