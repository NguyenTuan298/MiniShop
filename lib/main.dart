import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/routes.dart';
import 'package:minishop/utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Minishop',
      // Cập nhật theme để nó có thể thay đổi
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeService().theme, // Lấy theme từ service
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.dashboard,
      getPages: AppPages.routes,
    );
  }
}