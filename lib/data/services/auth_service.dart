// lib/data/services/auth_service.dart
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService extends GetxService {
  final String _baseUrl = 'http://192.168.1.46:3000/api/auth'; // sử dụng IP này trên máy để chạy ứng dụng
  // final String _baseUrl = 'https://456a47d7e538.ngrok-free.app/api/auth';

  Future<bool> login(String phoneEmail, String password) async {
    try {
      final url = Uri.parse('$_baseUrl/login');
      // print('Sending request to: $url'); // Debug
      // print('Body: {"phoneEmail": "$phoneEmail", "password": "$password"}'); // Debug

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phoneEmail': phoneEmail, 'password': password}),
      );

      // print('Response status: ${response.statusCode}'); // Debug
      // print('Response body: ${response.body}'); // Debug

      if (response.statusCode == 200) {
        return true;
      } else {
        Get.snackbar('Lỗi', jsonDecode(response.body)['error'] ?? 'Đăng nhập thất bại');
        return false;
      }
    } catch (e) {
      print('Error: $e'); // Debug
      Get.snackbar('Lỗi', 'Kết nối đến server thất bại');
      return false;
    }
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