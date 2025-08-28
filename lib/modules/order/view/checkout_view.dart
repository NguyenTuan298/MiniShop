// lib/views/order/checkout_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/modules/order/controller/order_controller.dart';
import 'package:minishop/utils/format.dart';
import 'package:minishop/routes.dart';
import 'package:minishop/modules/profile/service/profile_service.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderController>();

    // Nên đặt trong onInit của controller; tạm thời gọi 1 lần ở đây
    controller.loadDataForCheckout();

    return Scaffold(
      // Không set màu cứng -> theo theme
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              _buildQrCodeSection(context),
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
              _buildConfirmButton(context, controller),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Image.asset('assets/images/logo1.png', height: 40),
          const SizedBox(height: 8),
          SizedBox(
            height: 48,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  'Hóa Đơn',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: Get.back,
                    icon: const Icon(Icons.arrow_back),
                    color: theme.appBarTheme.iconTheme?.color
                        ?? theme.iconTheme.color
                        ?? theme.colorScheme.onSurface,
                    tooltip: 'Quay lại',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrCodeSection(BuildContext context) {
    final theme = Theme.of(context);
    final sub = theme.colorScheme.onSurface.withOpacity(0.7);
    return _buildSection(
      context: context,
      child: Column(
        children: [
          Image.asset('assets/images/thanhtoan.png', width: 200),
          const SizedBox(height: 8),
          Text(
            'Chuyển khoản vào mã QR:',
            style: theme.textTheme.bodyMedium?.copyWith(color: sub),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, OrderController controller) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tóm tắt đơn hàng', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),

        // items
        ...controller.currentOrderItems.map((item) {
          final qty = (item.quantity is RxInt)
              ? (item.quantity as RxInt).value
              : item.quantity as int;
          final itemName = '${item.product.name} (x$qty)';
          final itemTotal = item.product.price * qty;
          return _buildSummaryRow(context, itemName, AppFormatters.formatCurrency(itemTotal));
        }),

        Divider(height: 20, color: theme.dividerColor.withOpacity(0.4)),

        _buildSummaryRow(
          context,
          'Tạm tính',
          AppFormatters.formatCurrency(controller.currentSubtotal),
        ),
        _buildSummaryRow(
          context,
          'Vận chuyển',
          AppFormatters.formatCurrency(controller.currentShippingFee),
        ),
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

  Widget _buildShippingInfo(BuildContext context, OrderController controller) {
    final profile = Get.find<ProfileService>();
    return _buildInfoCard(
      context: context,
      title: 'Thông tin giao hàng',
      // Cho phép chỉnh sửa tại Checkout
      children: [
        Row(
          children: [
            Expanded(child: _buildInfoRow(context, 'Họ Tên:', '')),
            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.orderInformation),
              child: const Text('Chỉnh sửa'),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Obx(() => _buildInfoRow(context, '', profile.name.value)),
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
          'hết hạn vào ngày ${controller.currentExpirationDate}',
          style: theme.textTheme.bodySmall?.copyWith(color: sub),
        ),
      ],
    );
  }

  Widget _buildConfirmButton(BuildContext context, OrderController controller) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: controller.completeOrder,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: theme.colorScheme.primary),
            foregroundColor: theme.colorScheme.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text('Đã thanh toán'),
        ),
      ),
    );
  }

  // ---------------- Helpers dùng Theme ----------------

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

  Widget _buildSummaryRow(BuildContext context, String title, String value, {bool isBold = false}) {
    final theme = Theme.of(context);
    final base = theme.colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: theme.textTheme.bodyMedium?.copyWith(color: base.withOpacity(0.8))),
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
    Widget? trailing, // << thêm
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
