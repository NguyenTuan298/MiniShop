// lib/controllers/category_controller.dart

import 'package:get/get.dart';

import '../../../data/models/category.dart';

class CategoryController extends GetxController {
  var isLoading = true.obs;
  // Danh sách gốc, không bao giờ thay đổi sau khi fetch
  var categoryList = <Category>[].obs;
  // BIẾN MỚI: Lưu trữ chuỗi người dùng nhập vào ô tìm kiếm
  var searchQuery = ''.obs;
  // HÀM GETTER MỚI: Trả về một danh sách đã được lọc dựa trên searchQuery
  // View sẽ sử dụng danh sách này để hiển thị.
  List<Category> get filteredCategories {
    // Nếu ô tìm kiếm trống, trả về toàn bộ danh sách
    if (searchQuery.isEmpty) {
      return categoryList;
    } else {
      // Nếu không, lọc danh sách
      return categoryList.where((category) {
        // Chuyển cả tên danh mục và chuỗi tìm kiếm về chữ thường để tìm kiếm không phân biệt hoa/thường.
        // Xóa ký tự '\n' khỏi tên danh mục để tìm kiếm chính xác hơn.
        final categoryName = category.name.toLowerCase().replaceAll('\n', ' ');
        final query = searchQuery.value.toLowerCase();
        return categoryName.contains(query);
      }).toList();
    }
  }

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  // HÀM MỚI: Cập nhật giá trị cho searchQuery mỗi khi người dùng gõ
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }
  /// Tải danh sách các danh mục.
  /// Trong thực tế, bạn sẽ gọi API ở đây.
  /// Hiện tại, chúng ta sẽ dùng dữ liệu giả lập (mock data).
  void fetchCategories() async {
    try {
      isLoading(true);
      // Giả lập độ trễ của mạng
      await Future.delayed(const Duration(milliseconds: 500));

      // Dữ liệu giả lập
      categoryList.value = [
        Category(id: '1', name: 'Điện Tử', imageUrl: 'assets/images/dientu.png'),
        Category(id: '2', name: 'Thời Trang', imageUrl: 'assets/images/thoitrang.png'),
        Category(id: '3', name: 'Mỹ phẩm\n– Làm đẹp', imageUrl: 'assets/images/mypham.png'),
        Category(id: '4', name: 'Gia dụng', imageUrl: 'assets/images/giadung.png'),
        Category(id: '5', name: 'Đời sống\n– Tiện ích', imageUrl: 'assets/images/doisong.png'),
        Category(id: '6', name: 'Đồ chơi\n– Giải trí', imageUrl: 'assets/images/dochoi.png'),
        Category(id: '7', name: 'Thể thao\n– Du lịch', imageUrl: 'assets/images/thethao.png'),
        Category(id: '8', name: 'Thực phẩm\n– Đồ uống', imageUrl: 'assets/images/thucpham.png'),
      ];
    } finally {
      isLoading(false);
    }
  }
}