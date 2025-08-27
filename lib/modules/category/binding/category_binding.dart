import 'package:get/get.dart';
import 'package:minishop/modules/category/controller/category_controller.dart';

class CategoryBinding extends Bindings {
  @override
  void dependencies() {
    // Sử dụng lazyPut để controller chỉ được khởi tạo khi cần đến lần đầu tiên.
    // fenix: true giúp controller không bị xóa khỏi bộ nhớ khi không còn route nào sử dụng,
    // rất hữu ích để giữ lại dữ liệu danh mục đã tải.
    Get.lazyPut<CategoryController>(() => CategoryController(), fenix: true);
  }
}