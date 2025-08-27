import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/modules/category/binding/category_binding.dart'; // Import binding vừa tạo
import 'package:minishop/modules/category/view/category_list_view.dart'; // Import view cần đến
import 'package:minishop/utils/theme.dart';

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({super.key});

  // D:\minishop\lib\widgets\welcome_banner.dart

  @override
  Widget build(BuildContext context) {
    // Lấy dữ liệu theme hiện tại từ context
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        // *** SỬA Ở ĐÂY: Sử dụng màu chính từ theme ***
        // Màu này sẽ tự động thay đổi giữa light và dark mode
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chào mừng đến Minishop',
            style: TextStyle(
              // *** SỬA Ở ĐÂY: Sử dụng màu chữ tương phản với màu chính ***
              // `onPrimary` đảm bảo chữ luôn đọc được trên nền `primaryColor`
              color: theme.colorScheme.onPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Đặt hàng dễ dàng, nhanh chóng',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // *** ĐÂY LÀ ĐOẠN CODE ĐIỀU HƯỚNG ***
              // Sử dụng Get.to() để chuyển đến CategoryListView.
              // Đồng thời truyền vào 'binding' để đảm bảo CategoryController
              // được khởi tạo đúng lúc cho view mới.
              Get.to(() => const CategoryListView(), binding: CategoryBinding());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).primaryColor,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text('Xem thể loại'),
          ),
        ],
      ),
    );
  }
}