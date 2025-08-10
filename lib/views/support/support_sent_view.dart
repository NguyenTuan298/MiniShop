// lib/views/support/support_sent_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/controllers/support_controller.dart';
import 'package:minishop/utils/theme.dart';

class SupportSentView extends StatelessWidget {
  const SupportSentView({super.key});

  @override
  Widget build(BuildContext context) {
    // Tìm SupportController đã được tạo ở màn hình trước
    final controller = Get.find<SupportController>();

    return Scaffold(
      backgroundColor: Colors.white,
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
              // Phần nội dung xác nhận
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 80,
              ),
              const SizedBox(height: 24),
              const Text(
                'Tin nhắn đã được gửi!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Yêu cầu hỗ trợ của bạn đã được gửi thành công.\nChúng tôi sẽ liên hệ bạn trong thời gian sớm nhất',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 48),
              // Các nút hành động
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.goToHome,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.primaryColor),
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
                        side: const BorderSide(color: AppTheme.primaryColor),
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