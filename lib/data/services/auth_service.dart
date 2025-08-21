// lib/data/services/auth_service.dart
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService extends GetxService {
  // final String _baseUrl = 'http://localhost:3000/api/auth';
  final String _baseUrl = 'http://192.168.1.7:3000/api/auth';
  // final String _baseUrl = 'https://f21ad8b6569e.ngrok-free.app/api/auth';

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

  Future<bool> forgotPassword(String phoneEmail) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/forgot-password'),
        body: jsonEncode({'phoneEmail': phoneEmail}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Get.snackbar("Thành công", "OTP mặc định là 111111");
        return true;
      } else {
        Get.snackbar("Lỗi", jsonDecode(response.body)['error'] ?? 'Gửi OTP thất bại');
        return false;
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Kết nối đến server thất bại");
      return false;
    }
  }

  Future<bool> verifyOTP(String phoneEmail, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/verify-otp'),
        body: jsonEncode({'phoneEmail': phoneEmail, 'otp': otp}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        Get.snackbar("Lỗi", jsonDecode(response.body)['error'] ?? 'OTP không hợp lệ');
        return false;
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Kết nối đến server thất bại");
      return false;
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