import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileService extends GetxService {
  final _box = GetStorage();

  // Keys phải trùng với EditProfileController để đồng bộ dữ liệu
  static const _kName    = 'profile_name';
  static const _kPhone   = 'profile_phone';
  static const _kEmail   = 'profile_email';
  static const _kGender  = 'profile_gender';
  static const _kAddress = 'profile_address';

  // Reactive fields
  final name    = 'User 1'.obs;
  final phone   = '0123456789'.obs;
  final email   = 'user1@email.com'.obs;
  final gender  = 'Nam'.obs;
  final address = 'Quận 12, Tân Chánh HIệp'.obs;

  @override
  void onInit() {
    super.onInit();
    // Load từ storage (nếu có)
    name.value    = _box.read<String>(_kName)    ?? name.value;
    phone.value   = _box.read<String>(_kPhone)   ?? phone.value;
    email.value   = _box.read<String>(_kEmail)   ?? email.value;
    gender.value  = _box.read<String>(_kGender)  ?? gender.value;
    address.value = _box.read<String>(_kAddress) ?? address.value;
  }

  // Lưu 1 lần tất cả (đồng bộ view)
  void saveAll({
    required String name,
    required String phone,
    required String email,
    required String gender,
    required String address,
  }) {
    this.name.value    = name.trim();
    this.phone.value   = phone.trim();
    this.email.value   = email.trim();
    this.gender.value  = gender.trim();
    this.address.value = address.trim();

    _box.write(_kName, this.name.value);
    _box.write(_kPhone, this.phone.value);
    _box.write(_kEmail, this.email.value);
    _box.write(_kGender, this.gender.value);
    _box.write(_kAddress, this.address.value);
  }
}
