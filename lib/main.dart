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
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.dashboard, // Bắt đầu với màn hình chính
      getPages: AppPages.routes,
    );
  }
}