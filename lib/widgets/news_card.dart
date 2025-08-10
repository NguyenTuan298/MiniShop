import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/modules/home/home_controller.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Tìm HomeController đã được khởi tạo bởi DashboardBinding
    final controller = Get.find<HomeController>();

    return Obx(() {
      // Dùng Obx để lắng nghe thay đổi từ các biến reactive trong controller.
      // Nếu isLoading là true, hiển thị một vòng quay loading.
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      // Nếu không có dữ liệu, hiển thị một widget rỗng
      if (controller.newsImageUrl.isEmpty) {
        return const SizedBox.shrink();
      }

      // Nếu có dữ liệu, hiển thị thẻ tin tức
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              // Lấy dữ liệu ảnh từ controller
              child: Image.asset(
                controller.newsImageUrl.value,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              // Lấy dữ liệu mô tả từ controller
              child: Text(
                controller.newsDescription.value,
                style: TextStyle(
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}