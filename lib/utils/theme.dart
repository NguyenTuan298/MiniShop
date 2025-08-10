import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color(0xFF0D47A1); // Màu xanh đậm
  static const lightBlue = Color(0xFF1976D2);   // Màu xanh của banner
  static const textColor = Color(0xFF333333);
  static const whiteColor = Colors.white;

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.grey[100],
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: textColor),
      titleTextStyle: TextStyle(
        color: primaryColor,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
  );
}