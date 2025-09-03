// lib/data/services/auth_service.dart
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'dart:convert' as json;

class AuthService extends GetxService {
  // API auth base
  final String _baseUrl = 'https://minishop-kto7.onrender.com/api/auth';
  static const String baseUrl = 'https://minishop-kto7.onrender.com/api';

  // Cache hồ sơ (local)
  final _box = GetStorage();

  // ===== Helpers =====
  Map<String, dynamic>? _decodeJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      String _normalize(String s) =>
          s.padRight(s.length + (4 - s.length % 4) % 4, '=');

      final payload =
      json.utf8.decode(json.base64Url.decode(_normalize(parts[1])));
      return json.jsonDecode(payload) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Ghi hồ sơ xuống GetStorage để EditProfile đọc được
  void _applyProfileLocal({
    required String name,
    required String phone,
    required String email,
    String gender = 'Nam',
    String address = '',
  }) {
    _box.write('profile_name', name);
    _box.write('profile_phone', phone);
    _box.write('profile_email', email);
    _box.write('profile_gender', gender);
    _box.write('profile_address', address);
  }

  void _cacheProfileById(String userId, Map<String, String> p) {
    _box.write('profile_by_id_$userId', p);
    if ((p['email'] ?? '').isNotEmpty) {
      _box.write('profile_by_email_${p['email']}', p);
    }
    if ((p['phone'] ?? '').isNotEmpty) {
      _box.write('profile_by_phone_${p['phone']}', p);
    }
  }

  Map<String, String>? _getCachedById(String userId) {
    final v = _box.read('profile_by_id_$userId');
    if (v is Map) {
      return v.map((k, w) => MapEntry(k.toString(), (w ?? '').toString()));
    }
    return null;
  }

  Map<String, String>? _getCachedByLogin(String phoneEmail) {
    final key = phoneEmail.contains('@')
        ? 'profile_by_email_$phoneEmail'
        : 'profile_by_phone_$phoneEmail';
    final v = _box.read(key);
    if (v is Map) {
      return v.map((k, w) => MapEntry(k.toString(), (w ?? '').toString()));
    }
    return null;
  }

  // ===== Auth APIs =====
  Future<Map<String, dynamic>> login(String phoneEmail, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.jsonEncode({'phoneEmail': phoneEmail, 'password': password}),
    );

    print('Login response status: ${response.statusCode}');
    print('Login response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.jsonDecode(response.body);
      final token = data['token'];
      final refreshToken = data['refreshToken'];
      print('Parsed login data: $data');

      _box.write('auth_token', token);
      if (refreshToken != null) {
        _box.write('refresh_token', refreshToken);
      }
      print('Token saved to GetStorage: ${_box.read('auth_token')}');
      print('RefreshToken saved to GetStorage: ${_box.read('refresh_token')}');

      // Lấy userId từ JWT để nạp hồ sơ cache
      String? userId;
      final payload = _decodeJwt(token);
      if (payload != null && payload['id'] != null) {
        userId = payload['id'].toString();
      }

      Map<String, String>? p;
      if (userId != null) {
        p = _getCachedById(userId);
      }
      p ??= _getCachedByLogin(phoneEmail);

      if (p != null) {
        _applyProfileLocal(
          name: p['name'] ?? 'User 1',
          phone: p['phone'] ?? '',
          email: p['email'] ?? (phoneEmail.contains('@') ? phoneEmail : ''),
          gender: p['gender'] ?? 'Nam',
          address: p['address'] ?? '',
        );
      } else {
        // Fallback: đọc giá trị hiện có trong storage, chỉ thay email/phone theo thông tin đăng nhập
        final curName = _box.read('profile_name') ?? 'User 1';
        final curPhone = _box.read('profile_phone') ?? '';
        final curEmail = _box.read('profile_email') ?? '';
        final curGender = _box.read('profile_gender') ?? 'Nam';
        final curAddress = _box.read('profile_address') ?? '';

        _applyProfileLocal(
          name: curName,
          phone: phoneEmail.contains('@') ? curPhone : phoneEmail,
          email: phoneEmail.contains('@') ? phoneEmail : curEmail,
          gender: curGender,
          address: curAddress,
        );
      }

      return data;
    } else {
      return {'success': false, 'message': 'Đăng nhập thất bại'};
    }
  }

  Future<bool> isLoggedIn() async {
    final token = _box.read('auth_token');
    final refreshToken = _box.read('refresh_token');
    print(
        'Checking login status - Token: $token, RefreshToken: $refreshToken (raw from box: ${_box.read('auth_token')})');

    if (token == null) {
      print('No token found, returning false');
      return false;
    }

    try {
      final response = await http
          .get(
        Uri.parse('$_baseUrl/check-token'),
        headers: {'Authorization': 'Bearer $token'},
      )
          .timeout(const Duration(seconds: 10));
      print('API /check-token response: ${response.statusCode}');
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        if (refreshToken != null) {
          print('Token expired (401), attempting to refresh');
          final refreshResponse = await http.post(
            Uri.parse('$_baseUrl/refresh'),
            headers: {'Content-Type': 'application/json'},
            body: json.jsonEncode({'refreshToken': refreshToken}),
          );
          if (refreshResponse.statusCode == 200) {
            final data = json.jsonDecode(refreshResponse.body);
            _box.write('auth_token', data['token']);
            print('Token refreshed successfully: ${_box.read('auth_token')}');
            return true;
          }
          print('Refresh failed, logging out');
          await logout();
        } else {
          print('No refresh token available, logging out');
          await logout();
        }
        return false;
      } else {
        print(
            'Unexpected status code: ${response.statusCode}, keeping token (but return false)');
        return false;
      }
    } catch (e) {
      print('Network error or timeout in isLoggedIn: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _box.remove('auth_token');
    await _box.remove('refresh_token');
    Get.offAllNamed('/login');
  }

  Future<bool> register(
      String phone, String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        body: json.jsonEncode({
          'phone': phone,
          'name': name,
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      final responseData = json.jsonDecode(response.body);

      if (response.statusCode == 201) {
        final p = <String, String>{
          'name': name,
          'phone': phone,
          'email': email,
          'gender': 'Nam',
          'address': '',
        };

        final userId = (responseData['userId'] ?? '').toString();
        if (userId.isNotEmpty) _cacheProfileById(userId, p);

        _applyProfileLocal(
          name: p['name']!,
          phone: p['phone']!,
          email: p['email']!,
          gender: p['gender']!,
          address: p['address']!,
        );

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
    final response = await http.post(
      Uri.parse('$_baseUrl/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.jsonEncode({'phoneEmail': phoneEmail}),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Khôi phục mật khẩu thất bại');
    }
  }

  Future<bool> verifyOTP(String phoneEmail, String otp) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: json.jsonEncode({'phoneEmail': phoneEmail, 'otp': otp}),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'Xác thực OTP thất bại: ${json.jsonDecode(response.body)['error']}');
    }
  }

  Future<bool> resetPassword(String phoneEmail, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/reset-password'),
        body: json.jsonEncode(
            {'phoneEmail': phoneEmail, 'newPassword': newPassword}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        Get.snackbar(
            "Lỗi", json.jsonDecode(response.body)['error'] ?? 'Reset thất bại');
        return false;
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Kết nối đến server thất bại");
      return false;
    }
  }

  // Giữ nguyên để các màn gọi API sản phẩm dùng
  Future<List<dynamic>> fetchProductsByCategory(String category) async {
    final response =
    await http.get(Uri.parse('$baseUrl/products?category=$category'));

    if (response.statusCode == 200) {
      final data = json.jsonDecode(response.body);
      return data['products'];
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }
}
