import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/routes.dart';
import 'package:minishop/utils/theme.dart';
import 'package:minishop/data/services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthService());     // Khởi tạo AuthService toàn cục
    return GetMaterialApp(
      title: 'Minishop',
      // Cập nhật theme để nó có thể thay đổi
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeService().theme, // Lấy theme từ service
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
    );
  }
}