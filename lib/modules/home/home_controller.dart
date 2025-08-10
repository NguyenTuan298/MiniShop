import 'package:get/get.dart';

// Trong một ứng dụng thực tế, bạn sẽ import model của mình ở đây
// import 'package:minishop/models/news_item.dart';

class HomeController extends GetxController {
  // Biến cờ để quản lý trạng thái loading
  var isLoading = false.obs;

  // Dữ liệu cho tin tức nổi bật. Sử dụng .obs để biến chúng thành reactive.
  // Khi giá trị thay đổi, UI sẽ tự động cập nhật.
  var newsImageUrl = ''.obs;
  var newsDescription = ''.obs;

  // Trong một ứng dụng thực tế, bạn sẽ có một danh sách
  // var hotNewsList = <NewsItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Gọi hàm fetch dữ liệu khi controller được khởi tạo
    fetchHomeData();
  }

  /// Tải dữ liệu cho màn hình chính.
  /// Trong thực tế, hàm này sẽ gọi đến một service (ví dụ: ApiService)
  /// để lấy dữ liệu từ server.
  Future<void> fetchHomeData() async {
    try {
      // Bắt đầu loading
      isLoading.value = true;

      // Giả lập một cuộc gọi API mất 1 giây
      await Future.delayed(const Duration(seconds: 1));

      // Gán dữ liệu giả lập (mock data)
      // Trong ứng dụng thật, dữ liệu này sẽ đến từ API
      newsImageUrl.value = 'assets/images/noibat.png'; // Đảm bảo đường dẫn này đúng
      newsDescription.value =
      'Chương trình ngày Thứ Hai Điện Tử diễn ra tập trung vào những ưu đãi khi mua sắm trực tuyến, đặc biệt là mặt hàng thời trang và phụ kiện. Vì thế nếu như là tín đồ mua sắm online thì chắc chắn không thể bỏ qua ngày Cyber Monday này.';

    } catch (e) {
      // Xử lý lỗi nếu có
      Get.snackbar(
        'Lỗi',
        'Không thể tải dữ liệu trang chủ: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      // Kết thúc loading
      isLoading.value = false;
    }
  }
}