import 'package:get/get.dart';
import 'package:minishop/modules/support/controller/support_controller.dart';

class SupportBinding extends Bindings {
  @override
  void dependencies() {
    // Sử dụng lazyPut để controller chỉ được khởi tạo khi cần
    Get.lazyPut<SupportController>(() => SupportController());
  }
}