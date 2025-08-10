import 'package:flutter/material.dart';
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
            style: TextStyle(
              // *** SỬA Ở ĐÂY: Sử dụng màu chữ tương phản ***
              color: theme.colorScheme.onPrimary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Logic để chuyển đến trang thể loại
              // Ví dụ: Get.find<DashboardController>().changeTabIndex(1);
            },
            style: ElevatedButton.styleFrom(
              // *** SỬA Ở ĐÂY: Cập nhật style của nút cho phù hợp theme ***
              // Nền của nút là màu tương phản với banner
              backgroundColor: theme.colorScheme.onPrimary,
              // Chữ của nút có màu giống màu nền của banner
              foregroundColor: theme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Xem thể loại',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
  }