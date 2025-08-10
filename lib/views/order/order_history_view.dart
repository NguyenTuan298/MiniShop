import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:minishop/controllers/order_controller.dart';
import 'package:minishop/models/order.dart';
import 'package:minishop/utils/format.dart';
import 'package:minishop/utils/theme.dart';
import 'package:minishop/routes.dart';

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: Obx(() { // Obx đảm bảo UI được cập nhật khi orderHistory thay đổi
                if (controller.orderHistory.isEmpty) {
                  return const Center(
                    child: Text('Bạn chưa có đơn hàng nào.'),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: controller.orderHistory.length,
                  itemBuilder: (context, index) {
                    final order = controller.orderHistory[index];
                    return _buildOrderCard(order);
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/logo1.png', height: 40),
          const SizedBox(height: 16),
          const Text(
            'My orders',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order #${order.id}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateFormat('d/M/yyyy').format(order.date),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppFormatters.formatCurrency(order.totalAmount),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              // SỬA LẠI HÀNH ĐỘNG NÚT NÀY
              onPressed: () {
                // Điều hướng đến trang chi tiết và truyền đối tượng 'order' đi
                Get.toNamed(AppRoutes.orderDetail, arguments: order);
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.primaryColor),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('Xem chi tiết'),
            ),
          )
        ],
      ),
    );
  }
}