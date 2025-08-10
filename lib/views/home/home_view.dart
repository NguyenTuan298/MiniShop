import 'package:flutter/material.dart';
import 'package:minishop/utils/theme.dart';
import 'package:minishop/widgets/news_card.dart';
import 'package:minishop/widgets/welcome_banner.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy dữ liệu theme hiện tại từ context
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          // Tăng padding một chút để logo không quá sát lề
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/logo1.png'),
        ),
        leadingWidth: 200, // Giữ nguyên chiều rộng theo yêu cầu cũ
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        // Để WelcomeBanner có thể full-width, nên di chuyển Padding vào trong
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WelcomeBanner(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Tin nổi bật',
                    // *** SỬA LỖI Ở ĐÂY ***
                    // Sử dụng một kiểu văn bản từ theme hiện tại.
                    // titleLarge là một lựa chọn tốt cho tiêu đề của một khu vực.
                    // Nó sẽ tự động có màu sắc và font weight đúng cho cả light/dark mode.
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  const NewsCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}