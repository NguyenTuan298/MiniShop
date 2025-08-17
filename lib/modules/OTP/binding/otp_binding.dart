import 'package:get/get.dart';

import '../controller/OTP_controller.dart';

class OtpBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpController>(
          () => OtpController(),
      fenix: true,
    );
  }
}