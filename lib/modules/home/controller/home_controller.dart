import 'package:get/get.dart';

class HomeController extends GetxController {
  var newsList = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    newsList.value = [
      {
        'image': 'assets/images/noibat.png',
        'description': 'Khuyến mãi hot tháng 9 - Giảm giá đến 50%!'
      },
      {
        'image': 'assets/images/noibat.png',
        'description': 'Mua 1 tặng 1 cho đơn hàng hôm nay!'
      },
    ];
  }
}
