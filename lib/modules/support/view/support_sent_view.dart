// lib/views/support/support_sent_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/modules/support/controller/support_controller.dart';

class SupportSentView extends StatelessWidget {
  const SupportSentView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SupportController>();
    final theme = Theme.of(context);
    final subTextColor = theme.colorScheme.onSurface.withOpacity(0.7);

    return Scaffold(
      // Không set màu nền cứng -> theo theme
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Image.asset('assets/images/logo1.png', height: 40),
              ),
              const Spacer(),
              // Nội dung xác nhận
              Icon(
                Icons.check_circle_outline,
                color: theme.colorScheme.primary, // màu nhấn theo theme
                size: 80,
              ),
              const SizedBox(height: 24),
              Text(
                'Tin nhắn đã được gửi!',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Yêu cầu hỗ trợ của bạn đã được gửi thành công.\nChúng tôi sẽ liên hệ bạn trong thời gian sớm nhất',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: subTextColor),
              ),
              const SizedBox(height: 48),
              // Các nút hành động
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.goToHome,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.colorScheme.primary),
                        foregroundColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Quay lại trang chủ'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.goToOrders,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.colorScheme.primary),
                        foregroundColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Xem đơn hàng'),
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
