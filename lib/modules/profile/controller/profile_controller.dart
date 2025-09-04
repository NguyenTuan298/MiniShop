// lib/modules/profile/controller/profile_controller.dart
import 'dart:io';
import 'dart:convert' as convert;
import 'package:get/get.dart';
import 'package:minishop/modules/dashboard/controller/dashboard_controller.dart';
import 'package:minishop/routes.dart';

import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Helper tĩnh dùng chung cho mọi màn hình (không cần module mới)
class AvatarCore {
  static const _kAvatarPath = 'profile_avatar_path'; // legacy
  static const List<String> _tokenKeys = ['auth_token', 'token', 'accessToken', 'jwt'];
  static const List<String> _emailKeys = ['auth_email', 'profile_email', 'email'];
  static const List<String> _phoneKeys = ['auth_phone', 'profile_phone', 'phone'];

  static final _box = GetStorage();
  static final avatarPath = RxnString();
  static final ImagePicker _picker = ImagePicker();
  static bool _busy = false;

  static String? _readAny(List<String> keys) {
    for (final k in keys) {
      final v = _box.read(k);
      if (v is String && v.trim().isNotEmpty) return v.trim();
    }
    return null;
  }

  static Map<String, dynamic>? _decodeJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      String _norm(String s) => s.padRight(s.length + (4 - s.length % 4) % 4, '=');
      final payload = convert.utf8.decode(convert.base64Url.decode(_norm(parts[1])));
      return convert.jsonDecode(payload) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static String? _currentIdentity() {
    final token = _readAny(_tokenKeys);
    if (token != null) {
      final jwt = _decodeJwt(token);
      final uid = jwt?['id']?.toString();
      if (uid != null && uid.isNotEmpty) return 'uid:$uid';
    }
    final email = _readAny(_emailKeys);
    if (email != null && email.isNotEmpty) return 'email:$email';
    final phone = _readAny(_phoneKeys);
    if (phone != null && phone.isNotEmpty) return 'phone:$phone';
    return null;
  }

  static String _keyForIdentity(String? ident) =>
      ident == null ? _kAvatarPath : '${_kAvatarPath}__$ident';

  static void ensureLoaded() {
    final ident = _currentIdentity();
    final k = _keyForIdentity(ident);
    final path = _box.read<String>(k);
    avatarPath.value = path;
  }

  static Future<void> pickFromGallery() async {
    if (_busy) return;
    _busy = true;
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (picked == null) return;

      final docs = await getApplicationDocumentsDirectory();
      final newPath = p.join(
        docs.path,
        'avatar_${DateTime.now().millisecondsSinceEpoch}${p.extension(picked.path)}',
      );
      final saved = await File(picked.path).copy(newPath);

      final old = avatarPath.value;
      if (old != null && old != saved.path) {
        final f = File(old);
        if (await f.exists()) await f.delete();
      }

      avatarPath.value = saved.path;

      final ident = _currentIdentity();
      final k = _keyForIdentity(ident);
      await _box.write(k, saved.path);
    } finally {
      _busy = false;
    }
  }

  static Future<void> clear() async {
    final current = avatarPath.value;
    avatarPath.value = null;

    final ident = _currentIdentity();
    final k = _keyForIdentity(ident);

    await _box.remove(k);

    if (current != null) {
      final f = File(current);
      if (await f.exists()) await f.delete();
    }
  }
}

/// ⬇️ KHÔI PHỤC LẠI CONTROLLER NÀY
class ProfileController extends GetxController {
  final name = ''.obs;
  final _box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    AvatarCore.ensureLoaded();          // giữ avatar như cũ
    refreshFromStorage();               // ⬅️ load tên ngay khi vào màn
  }

  // ⬇️ gọi hàm này mỗi khi hồ sơ thay đổi để cập nhật UI
  void refreshFromStorage() {
    name.value = (_box.read<String>('profile_name') ?? '').trim();
  }

  /// Điều hướng người dùng đến tab "Đơn đặt hàng"
  void navigateToMyOrders() {
    final dashboardController = Get.find<DashboardController>();
    dashboardController.changeTab(3);
  }

  void editProfile() {
    Get.toNamed(AppRoutes.editProfile);
  }

  void goToSettings() {
    Get.toNamed(AppRoutes.settings);
  }

  Future<void> changeAvatar() async {
    await AvatarCore.pickFromGallery();
  }
}