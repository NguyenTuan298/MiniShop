import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  /// Lưu theme
  void _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  /// Đọc theme từ bộ nhớ, mặc định là false (light mode)
  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  /// Lấy ThemeMode hiện tại
  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  /// Chuyển đổi theme
  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }
}

class AppTheme {
  // --- BẢNG MÀU ---
  static const primaryColor = Color(0xFF0D47A1); // Màu xanh đậm cho Light Mode
  static const lightBlue = Color(0xFF42A5F5);   // Màu xanh sáng hơn cho Dark Mode
  static const textColorLight = Color(0xFF333333); // Màu chữ cho Light Mode
  static final textColorDark = Colors.white.withOpacity(0.87); // Màu chữ chính cho Dark Mode
  static const backgroundColor = Color(0xFFF5F5F5); // Màu nền cho Light Mode

  // =======================================================================
  // LIGHT THEME
  // =======================================================================
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: textColorLight),
      titleTextStyle: TextStyle(
        color: primaryColor,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
  );

  // =======================================================================
  // DARK THEME (TƯƠNG TỰ LIGHT THEME)
  // =======================================================================
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: lightBlue, // Dùng màu sáng hơn làm màu nhấn
    scaffoldBackgroundColor: const Color(0xFF121212), // Nền chính theo chuẩn Material Design
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E1E1E), // Nền AppBar/Card để tạo độ sâu
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white70), // Icon màu sáng
      titleTextStyle: const TextStyle(
        color: lightBlue, // Tiêu đề dùng màu nhấn của dark mode
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF1E1E1E), // Nền cho bottom bar
      selectedItemColor: lightBlue, // Item được chọn có màu nhấn
      unselectedItemColor: Colors.grey[700], // Item không được chọn có màu tối hơn
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
  );
}