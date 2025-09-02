import 'package:get/get.dart';

class Category {
  final String name;
  final String image;

  Category({required this.name, required this.image});
}

class CategoryController extends GetxController {
  var categories = <Category>[
    Category(name: 'Điện Tử', image: 'assets/images/dientu.png'),
    Category(name: 'Thời Trang', image: 'assets/images/thoitrang.png'),
    Category(name: 'Mỹ phẩm - Làm đẹp', image: 'assets/images/mypham.png'),
    Category(name: 'Đồ gia Dụng', image: 'assets/images/giadung.png',),
    Category(name: 'Đời sống - Tiện ích', image: 'assets/images/doisong.png'),
    Category(name: 'Đồ chơi - Giải trí', image: 'assets/images/dochoi.png'),
    Category(name: 'Thể thao', image: 'assets/images/thethao.png'),
    Category(name: 'Du lịch', image: 'assets/images/dulich.png'),
    Category(name: 'Thực phẩm', image: 'assets/images/thucpham.png'),
    Category(name: 'Đồ uống', image: 'assets/images/douong.png'),
  ].obs;
}
