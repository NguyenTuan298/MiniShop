// lib/bindings/edit_profile_binding.dart

import 'package:get/get.dart';
import 'package:minishop/modules/profile/controller/edit_profile_controller.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditProfileController>(() => EditProfileController());
  }
}