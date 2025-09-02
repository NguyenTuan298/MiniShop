// order_detail_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:minishop/modules/order/controller/order_controller.dart';
import 'package:minishop/routes.dart';
import 'package:minishop/modules/profile/service/profile_service.dart';
import 'package:minishop/utils/format.dart';
import 'package:minishop/data/models/cart_item.dart';
import 'package:minishop/data/models/order.dart';

class OrderDetailView extends StatelessWidget {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderController>();

    controller.loadSelectedOrderDetails();

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final order = controller.selectedOrder.value;
          if (order == null) {
            return Center(
              child: Text(
                'Không tìm thấy thông tin đơn hàng.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                _buildSection(context: context, child: _buildOrderSummary(context, order as OrderModel)),
                _buildItemListSection(context, controller, order as OrderModel),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildShippingInfo(context, controller)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildPaymentMethod(context, controller)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _buildBottomButton(context, controller),
                const SizedBox(height: 16),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/logo1.png', height: 40),
          const SizedBox(height: 16),
          Text(
            'Order Details',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, OrderModel order) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Đơn hàng #${order.id}',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildSummaryRow(
          context,
          'Ngày đặt hàng:',
          DateFormat('d/M/yyyy').format(order.date),
        ),
        _buildSummaryRow(
          context,
          'Tổng cộng',
          AppFormatters.formatCurrency(order.totalAmount),
        ),
      ],
    );
  }

  Widget _buildItemListSection(
      BuildContext context,
      OrderController controller,
      OrderModel order,
      ) {
    final theme = Theme.of(context);
    return _buildSection(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Các mặt hàng trong đơn',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...order.items.map((item) => _buildProductRow(context, item)),
          const Divider(height: 24),
          _buildSummaryRow(
            context,
            'Tạm tính',
            AppFormatters.formatCurrency(controller.selectedOrderSubtotal),
          ),
          _buildSummaryRow(
            context,
            'Vận chuyển',
            AppFormatters.formatCurrency(controller.shippingFee),
          ),
          const Divider(height: 24),
          _buildSummaryRow(
            context,
            'Tổng',
            AppFormatters.formatCurrency(order.totalAmount),
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildProductRow(BuildContext context, CartItem item) {
    final theme = Theme.of(context);
    final sub = theme.colorScheme.onSurface.withOpacity(0.7);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              item.product.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  '${item.quantity.value} × ${AppFormatters.formatCurrency(item.product.price.toDouble())}', // Sửa ở đây
                  style: theme.textTheme.bodySmall?.copyWith(color: sub),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingInfo(BuildContext context, OrderController controller) {
    final profile = Get.find<ProfileService>();
    return _buildInfoCard(
      context: context,
      title: 'Thông tin giao hàng',
      trailing: TextButton(
        onPressed: () => Get.toNamed(AppRoutes.editProfile),
        child: const Text('Hồ sơ'),
      ),
      children: [
        Obx(() => _buildInfoRow(context, 'Họ Tên:', profile.name.value)),
        Obx(() => _buildInfoRow(context, 'Địa Chỉ:', profile.address.value)),
        Obx(() => _buildInfoRow(context, 'SĐT:', profile.phone.value)),
      ],
    );
  }

  Widget _buildPaymentMethod(BuildContext context, OrderController controller) {
    final theme = Theme.of(context);
    final sub = theme.colorScheme.onSurface.withOpacity(0.6);

    return _buildInfoCard(
      context: context,
      title: 'Phương thức thanh toán',
      children: [
        _buildInfoRow(context, 'Mbbank:', '0334043054'),
        _buildInfoRow(context, '', 'Phan Quoc Hung'),
        const SizedBox(height: 8),
        Text(
          'hết hạn vào ngày ${controller.selectedOrderExpirationDate}',
          style: theme.textTheme.bodySmall?.copyWith(color: sub),
        ),
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context, OrderController controller) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Get.toNamed(AppRoutes.checkout, arguments: controller.selectedOrder.value);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text('Tiếp tục thanh toán'),
        ),
      ),
    );
  }

  Widget _buildSection({required BuildContext context, required Widget child}) {
    final theme = Theme.of(context);
    final bg = theme.colorScheme.surfaceVariant.withOpacity(
      theme.brightness == Brightness.dark ? 0.25 : 1.0,
    );
    return Container(
      width: double.infinity,
      color: bg,
      padding: const EdgeInsets.all(16.0),
      child: child,
    );
  }

  Widget _buildSummaryRow(BuildContext context, String title, String value, {bool isBold = false}) {
    final theme = Theme.of(context);
    final base = theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(color: base.withOpacity(0.8)),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: base,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required String title,
    required List<Widget> children,
    Widget? trailing,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String title, String value) {
    final theme = Theme.of(context);
    final sub = theme.colorScheme.onSurface.withOpacity(0.8);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Text(
        title.isEmpty ? value : '$title $value',
        style: theme.textTheme.bodyMedium?.copyWith(color: sub),
      ),
    );
  }
}