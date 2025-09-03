// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minishop/routes.dart';
import 'package:minishop/utils/theme.dart';
import 'package:minishop/data/services/auth_service.dart';
import 'package:minishop/modules/cart/controller/cart_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // init storage trước khi runApp
  Get.put(CartController(), permanent: true);
  Get.put(AuthService());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Minishop',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeService().theme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
    );
  }
}
