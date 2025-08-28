// lib/views/order/order_success_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/modules/order/controller/order_controller.dart';
import 'package:minishop/utils/format.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderController>();
    final theme = Theme.of(context);

    return Scaffold(
      // để theme quyết định nền
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context, controller),
              _buildConfirmationSection(context, controller),
              const SizedBox(height: 16),
              _buildSection(
                context: context,
                child: _buildOrderSummary(context, controller),
              ),
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
              _buildActionButtons(context, controller),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // --- HEADER ---
  Widget _buildHeader(BuildContext context, OrderController controller) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/images/logo1.png', height: 40),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              tooltip: 'Quay lại',
              onPressed: controller.goToShopping,
              icon: const Icon(Icons.arrow_back),
              color: theme.appBarTheme.iconTheme?.color ??
                  theme.iconTheme.color ??
                  theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  // --- CONFIRMATION ---
  Widget _buildConfirmationSection(BuildContext context, OrderController controller) {
    final theme = Theme.of(context);
    final subColor = theme.colorScheme.onSurface.withOpacity(0.7);

    return _buildSection(
      context: context,
      child: Column(
        children: [
          Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 60),
          const SizedBox(height: 16),
          Text(
            'Xác nhận đơn hàng!',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Obx(
                () => Text(
              'Cảm ơn bạn đã mua hàng. Đơn hàng #${controller.completedOrderId.value} của bạn đã được đặt thành công',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: subColor),
            ),
          ),
        ],
      ),
    );
  }

  // --- ACTION BUTTONS ---
  Widget _buildActionButtons(BuildContext context, OrderController controller) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: controller.goToShopping,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.colorScheme.primary),
                foregroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Tiếp tục mua sắm'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: controller.contactSupport,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Liên hệ hỗ trợ'),
            ),
          ),
        ],
      ),
    );
  }

  // --- REUSABLE SECTION WRAPPER ---
  Widget _buildSection({required BuildContext context, required Widget child}) {
    final theme = Theme.of(context);
    final bg = theme.colorScheme.surfaceVariant.withOpacity(
      theme.brightness == Brightness.dark ? 0.25 : 1.0,
    );
    return Container(
      width: double.infinity,
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: child,
    );
  }

  // --- ORDER SUMMARY ---
  Widget _buildOrderSummary(BuildContext context, OrderController controller) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tóm tắt đơn hàng', style: titleStyle),
        const SizedBox(height: 12),
        ...controller.currentOrderItems.map((item) {
          final itemName = '${item.product.name} (x${item.quantity.value})';
          final itemTotal = item.product.price * item.quantity.value;
          return _buildSummaryRow(context, itemName, AppFormatters.formatCurrency(itemTotal));
        }),
        _buildSummaryRow(context, 'Vận chuyển', AppFormatters.formatCurrency(controller.currentShippingFee)),
        Divider(height: 20, color: theme.dividerColor.withOpacity(0.4)),
        _buildSummaryRow(
          context,
          'Tổng cộng',
          AppFormatters.formatCurrency(controller.currentTotal),
          isBold: true,
        ),
      ],
    );
  }

  // --- SHIPPING / PAYMENT INFO ---
  Widget _buildShippingInfo(BuildContext context, OrderController controller) {
    return _buildInfoCard(
      context: context,
      title: 'Thông tin giao hàng',
      children: [
        _buildInfoRow(context, 'Họ Tên:', controller.userName),
        _buildInfoRow(context, 'Địa Chỉ:', controller.address),
        _buildInfoRow(context, 'SĐT:', controller.phoneNumber),
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
          'Hết hạn vào ngày ${controller.currentExpirationDate}',
          style: theme.textTheme.bodySmall?.copyWith(color: sub),
        ),
      ],
    );
  }

  // --- SMALL HELPERS ---
  Widget _buildSummaryRow(BuildContext context, String title, String value, {bool isBold = false}) {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.onSurface;
    final left = theme.textTheme.bodyMedium?.copyWith(
      color: baseColor.withOpacity(0.8),
    );
    final right = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      color: baseColor,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title, style: left, overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 12),
          Text(value, style: right),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required String title,
    required List<Widget> children,
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
          Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
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
