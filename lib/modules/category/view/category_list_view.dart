import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/category_controller.dart';

class CategoryListView extends GetView<CategoryController> {
  const CategoryListView({super.key});


  @override
  Widget build(BuildContext context) {
    List<String> categories = ['Điện tử', 'Thời trang', 'Mỹ phẩm - Làm đẹp', 'Đồ gia dụng', 'Đời sống - Tiện ích', 'Đồ chơi - Giải trí', 'Thể thao','Du lịch','Thực phẩm','Đồ uống'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh mục sản phẩm',style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        )),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Ô tìm kiếm
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm danh mục...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              return GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 cột
                  mainAxisSpacing: 35,
                  crossAxisSpacing: 25,
                  childAspectRatio: 0.8,
                ),
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                    return GestureDetector(
                      onTap: () {
                        switch (categories[index]) {
                          case 'Điện tử':
                            Get.toNamed('/electronics');
                            break;
                          case 'Thời trang':
                            Get.toNamed('/fashion');
                            break;
                            case 'Mỹ phẩm - Làm đẹp':
                            Get.toNamed('/cosmetics-beauty');
                            break;
                          case 'Đồ gia dụng':
                            Get.toNamed('/household');
                            break;
                          case 'Đời sống - Tiện ích':
                            Get.toNamed('/life-utilities');
                            break;
                            case 'Đồ chơi - Giải trí':
                            Get.toNamed('/toys-entertainment');
                            break;
                          case 'Thể thao':
                            Get.toNamed('/sports');
                            break;
                            case 'Du lịch':
                            Get.toNamed('/travel');
                            break;
                          case 'Thực phẩm':
                            Get.toNamed('/food');
                            break;
                          case 'Đồ uống':
                            Get.toNamed('/beverage');
                            break;
                          default:
                            Get.snackbar('Thông báo', 'Trang chưa có');
                        }
                      },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[200],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: Image.asset(
                                category.image,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.center,
                            child: Text(
                              category.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
