// lib/data/services/auth_service.dart
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minishop/modules/profile/service/profile_service.dart';
import 'dart:convert' as json;

class AuthService extends GetxService {
  // API auth base
  final String _baseUrl = 'https://minishop-kto7.onrender.com/api/auth';
  // API chung cho các resource khác (giữ nguyên để dùng fetchProductsByCategory)
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

  void _applyProfileLocal({
    required String name,
    required String phone,
    required String email,
    String gender = 'Nam',
    String address = '',
  }) {
    final profile = Get.isRegistered<ProfileService>()
        ? Get.find<ProfileService>()
        : Get.put(ProfileService(), permanent: true);

    profile.saveAll(
      name: name,
      phone: phone,
      email: email,
      gender: gender,
      address: address,
    );
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

    if (response.statusCode == 200) {
      final data = json.jsonDecode(response.body);
      final token = data['token'];

      // Lưu token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);

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
        // Fallback: ít nhất cũng ghi lại email/phone
        final profile = Get.isRegistered<ProfileService>()
            ? Get.find<ProfileService>()
            : Get.put(ProfileService(), permanent: true);
        _applyProfileLocal(
          name: profile.name.value,
          phone: phoneEmail.contains('@') ? profile.phone.value : phoneEmail,
          email: phoneEmail.contains('@') ? phoneEmail : profile.email.value,
          gender: profile.gender.value,
          address: profile.address.value,
        );
      }

      return data;
    } else {
      return {'success': false, 'message': 'Đăng nhập thất bại'};
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) return false;

    try {
      final response = await http
          .get(
        Uri.parse('$_baseUrl/check-token'),
        headers: {'Authorization': 'Bearer $token'},
      )
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        return true;
      } else {
        await logout();
        return false;
      }
    } catch (e) {
      await logout();
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
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
        // Lưu full hồ sơ local
        final p = <String, String>{
          'name': name,
          'phone': phone,
          'email': email,
          'gender': 'Nam', // nếu form có thì truyền đúng
          'address': '',   // nếu form có thì truyền đúng
        };

        // Cache theo userId để lần sau login nạp lại đủ
        final userId = (responseData['userId'] ?? '').toString();
        if (userId.isNotEmpty) _cacheProfileById(userId, p);

        // Đồng bộ vào ProfileService + GetStorage
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
        Get.snackbar("Lỗi",
            json.jsonDecode(response.body)['error'] ?? 'Reset thất bại');
        return false;
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Kết nối đến server thất bại");
      return false;
    }
  }

  // (Tùy chọn) Hàm cũ – không bắt buộc dùng, giữ lại nếu nơi khác có gọi
  void _mirrorLoginProfile(String phoneEmail) {
    try {
      final profile = Get.isRegistered<ProfileService>()
          ? Get.find<ProfileService>()
          : Get.put(ProfileService(), permanent: true);

      String name = profile.name.value;
      String phone = profile.phone.value;
      String email = profile.email.value;
      String gender = profile.gender.value;
      String address = profile.address.value;

      if (phoneEmail.contains('@')) {
        email = phoneEmail;
      } else {
        phone = phoneEmail;
      }

      profile.saveAll(
        name: name,
        phone: phone,
        email: email,
        gender: gender,
        address: address,
      );
    } catch (_) {}
  }

  Future<List<dynamic>> fetchProductsByCategory(String category) async {
    final response =
    await http.get(Uri.parse('$baseUrl/products?category=$category'));

    if (response.statusCode == 200) {
      final data = json.jsonDecode(response.body); // ✅ dùng json.jsonDecode
      return data['products'];
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }
}
