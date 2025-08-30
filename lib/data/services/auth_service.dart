// lib/data/services/auth_service.dart
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  // final String _baseUrl = 'http://192.168.1.46:3000/api/auth'; // sử dụng IP này trên máy để chạy ứng dụng
  final String _baseUrl = 'https://minishop-kto7.onrender.com/api/auth';

// Login
  Future<Map<String, dynamic>> login(String phoneEmail, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneEmail': phoneEmail, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      // Lưu token vào SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      return data;
    } else {
      // throw Exception('Đăng nhập thất bại: ${response.body}');
      return {
        'success': false,
        'message': 'Đăng nhập thất bại'
      };
    }
  }

  // Kiểm tra trạng thái đăng nhập
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) return false;

    // Kiểm tra token với backend
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/check-token'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(Duration(seconds: 5));
      if (response.statusCode == 200) {
        return true;
      } else {
        await logout(); // Xóa token nếu không hợp lệ
        return false;
      }
    } catch (e) {
      await logout(); // Xóa token nếu có lỗi kết nối
      return false;
    }
  }

  // Đăng xuất (xóa token)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<bool> register(
      String phone, String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        body: jsonEncode({
          'phone': phone,
          'name': name,
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return true;
      } else {
        Get.snackbar("Lỗi", responseData['error'] ?? 'Đăng ký thất bại');
        return false;
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Kết nối đến server thất bại");
      return false;
    }
  }

// Forgot Password
  Future<bool> forgotPassword(String phoneEmail) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneEmail': phoneEmail}),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Khôi phục mật khẩu thất bại');
    }
  }

// Verify OTP
  Future<bool> verifyOTP(String phoneEmail, String otp) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneEmail': phoneEmail, 'otp': otp}),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Xác thực OTP thất bại: ${jsonDecode(response.body)['error']}');
    }
  }

  Future<bool> resetPassword(String phoneEmail, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/reset-password'),
        body: jsonEncode({'phoneEmail': phoneEmail, 'newPassword': newPassword}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        Get.snackbar("Lỗi", jsonDecode(response.body)['error'] ?? 'Reset thất bại');
        return false;
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Kết nối đến server thất bại");
      return false;
    }
  }
}