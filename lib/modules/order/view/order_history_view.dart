import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:minishop/modules/order/controller/order_controller.dart';
import 'package:minishop/utils/format.dart';
import 'package:minishop/routes.dart';

import '../../../data/models/order.dart';

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderController>();
    final theme = Theme.of(context);

    return Scaffold(
      // KHÔNG set backgroundColor cứng; để ThemeData quyết định
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(
              child: Obx(() {
                if (controller.orderHistory.isEmpty) {
                  return Center(
                    child: Text(
                      'Bạn chưa có đơn hàng nào.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: controller.orderHistory.length,
                  itemBuilder: (context, index) {
                    final order = controller.orderHistory[index];
                    return _buildOrderCard(context, order);
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

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/logo1.png', height: 40),
          const SizedBox(height: 16),
          Text(
            'My orders',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    final theme = Theme.of(context);
    final onSurfaceSubtle = theme.colorScheme.onSurface.withOpacity(0.7);

    return Card(
      elevation: 0,
      color: theme.cardColor, // tự đổi theo light/dark
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #${order.id}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary, // dùng màu nhấn theo theme
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('d/M/yyyy').format(order.date),
                      style: theme.textTheme.bodySmall?.copyWith(color: onSurfaceSubtle),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppFormatters.formatCurrency(order.totalAmount),
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: () {
                  // Điều hướng đến trang chi tiết và truyền đối tượng 'order' đi
                  Get.toNamed(AppRoutes.orderDetail, arguments: order);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  side: BorderSide(color: theme.colorScheme.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Xem chi tiết'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
