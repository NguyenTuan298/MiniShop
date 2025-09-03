// lib/modules/profile/controller/edit_profile_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:minishop/data/services/auth_service.dart'; // để lấy baseUrl
import 'package:minishop/modules/order/controller/order_controller.dart';
import 'package:minishop/modules/profile/controller/profile_controller.dart' show AvatarCore;

class EditProfileController extends GetxController {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController genderController;
  late TextEditingController addressController;

  final formKey = GlobalKey<FormState>();
  final _box = GetStorage();

  // Keys lưu hồ sơ (local only)
  static const _kName = 'profile_name';
  static const _kPhone = 'profile_phone';
  static const _kEmail = 'profile_email';
  static const _kGender = 'profile_gender';
  static const _kAddress = 'profile_address';

  // Keys token (dò nhiều key để tương thích)
  static const List<String> _tokenKeys = ['auth_token', 'token', 'accessToken', 'jwt'];
  static const List<String> _refreshKeys = ['auth_refresh', 'refreshToken'];

  // Dò thông tin định danh từ login (nếu có) để gợi ý vào email/phone khi trống
  static const List<String> _emailKeys = ['auth_email', _kEmail, 'email'];
  static const List<String> _phoneKeys = ['auth_phone', _kPhone, 'phone'];

  final isCheckingSession = false.obs;

  // Base cho auth endpoints
  String get _authBase => '${AuthService.baseUrl}/auth';

  @override
  void onInit() {
    super.onInit();

    // KHÔNG đặt giá trị mặc định bên ngoài: nếu không có -> để trống
    nameController    = TextEditingController(text: _box.read<String>(_kName)    ?? '');
    phoneController   = TextEditingController(text: _box.read<String>(_kPhone)   ?? '');
    emailController   = TextEditingController(text: _box.read<String>(_kEmail)   ?? '');
    genderController  = TextEditingController(text: _box.read<String>(_kGender)  ?? '');
    addressController = TextEditingController(text: _box.read<String>(_kAddress) ?? '');

    // Nếu email/phone đang trống, thử lấy từ các key auth đã lưu
    _hydrateIdentityFromStorage();
    // Kiểm tra phiên ngay khi vào màn sửa hồ sơ (không gọi backend khác ngoài auth)
    _ensureValidSession();
    AvatarCore.ensureLoaded(); // ⬅️ đảm bảo có path avatar
    _hydrateIdentityFromStorage();
    _ensureValidSession();
  }

  // ---- Session helpers ----

  String? _readAny(List<String> keys) {
    for (final k in keys) {
      final v = _box.read(k);
      if (v is String && v.trim().isNotEmpty) return v.trim();
    }
    return null;
  }

  Future<void> changeAvatar() async {
    await AvatarCore.pickFromGallery();
  }

  Future<void> _ensureValidSession() async {
    isCheckingSession.value = true;
    try {
      final ok = await _checkTokenValid();
      if (!ok) {
        Get.snackbar('Phiên hết hạn', 'Vui lòng đăng nhập lại để tiếp tục.',
            snackPosition: SnackPosition.TOP);
      }
    } finally {
      isCheckingSession.value = false;
    }
  }

  Future<bool> _checkTokenValid() async {
    final token = _readAny(_tokenKeys);
    if (token == null) return false;

    final r = await http.get(
      Uri.parse('$_authBase/check-token'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (r.statusCode == 200) return true;
    if (r.statusCode == 401) {
      // thử refresh
      final refreshed = await _tryRefreshToken();
      if (!refreshed) return false;

      // thử lại 1 lần
      final newToken = _readAny(_tokenKeys);
      if (newToken == null) return false;

      final r2 = await http.get(
        Uri.parse('$_authBase/check-token'),
        headers: {'Authorization': 'Bearer $newToken'},
      );
      return r2.statusCode == 200;
    }
    return false;
  }

  Future<bool> _tryRefreshToken() async {
    final refresh = _readAny(_refreshKeys);
    if (refresh == null) return false;

    final r = await http.post(
      Uri.parse('$_authBase/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: '{"refreshToken":"$refresh"}',
    );

    if (r.statusCode == 200) {
      // response: { message, token }
      final token = _extractJsonField(r.body, 'token');
      if (token != null && token.isNotEmpty) {
        // lưu theo nhiều key để tương thích
        _box.write('auth_token', token);
        _box.write('token', token);
        _box.write('accessToken', token);
        _box.write('jwt', token);
        return true;
      }
    }
    return false;
  }

  // Rất nhẹ: tự trích 1 field (tránh phụ thuộc json decode ở chỗ khác)
  String? _extractJsonField(String body, String key) {
    try {
      final reg = RegExp('"$key"\\s*:\\s*"([^"]+)"');
      final m = reg.firstMatch(body);
      return m?.group(1);
    } catch (_) {
      return null;
    }
  }

  void _hydrateIdentityFromStorage() {
    if (emailController.text.trim().isEmpty) {
      final email = _readAny(_emailKeys);
      if (email != null) emailController.text = email;
    }
    if (phoneController.text.trim().isEmpty) {
      final phone = _readAny(_phoneKeys);
      if (phone != null) phoneController.text = phone;
    }
  }

  // ---- Actions ----

  Future<void> saveProfile() async {
    // Kiểm tra phiên (chỉ gọi auth/check-token; không đụng backend khác)
    await _ensureValidSession();

    // Lưu local-only
    _box.write(_kName,    nameController.text.trim());
    _box.write(_kPhone,   phoneController.text.trim());
    _box.write(_kEmail,   emailController.text.trim());
    _box.write(_kGender,  genderController.text.trim());
    _box.write(_kAddress, addressController.text.trim());
// ⬅️ Đồng bộ ngay sang OrderController để các màn Order hiển thị đúng
        if (Get.isRegistered<OrderController>()) {
          final order = Get.find<OrderController>();
          order.updateShippingInfo(
             name: nameController.text.trim(),
             address: addressController.text.trim(),
             phone: phoneController.text.trim(),
          );
        }
    Get.back();
    Get.snackbar(
      'Thành công',
      'Thông tin cá nhân đã được lưu trên thiết bị.',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  void logout() {
    // Không gọi backend. Xoá token và thông tin cục bộ.
    for (final k in [
      ..._tokenKeys,
      ..._refreshKeys,
      'auth_email',
      'auth_phone',
    ]) {
      _box.remove(k);
    }
    AvatarCore.clear();
    Get.snackbar('Đã đăng xuất', 'Phiên làm việc đã kết thúc.',
        snackPosition: SnackPosition.TOP);
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    genderController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
