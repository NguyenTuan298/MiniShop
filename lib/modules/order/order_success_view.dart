// lib/views/order/order_success_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/modules/order/order_controller.dart';
import 'package:minishop/utils/format.dart';
import 'package:minishop/utils/theme.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(controller),
              _buildConfirmationSection(controller),
              const SizedBox(height: 16),
              _buildSection(
                child: _buildOrderSummary(controller),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildShippingInfo(controller)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildPaymentMethod(controller)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildActionButtons(controller),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // --- CÁC HÀM HELPER ĐỂ XÂY DỰNG GIAO DIỆN ---

  Widget _buildHeader(OrderController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/images/logo1.png', height: 40),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: controller.goToShopping,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationSection(OrderController controller) {
    return _buildSection(
      child: Column(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 60),
          const SizedBox(height: 16),
          const Text(
            'Xác nhận đơn hàng!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Obx(() => Text(
            'cảm ơn bạn đã mua hàng. Đơn hàng #${controller.completedOrderId.value} của bạn đã được đặt thành công',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[700]),
          )),
        ],
      ),
    );
  }

  /// CẬP NHẬT: Thay đổi nút "Xem đơn hàng" thành "Liên hệ hỗ trợ"
  Widget _buildActionButtons(OrderController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: controller.goToShopping,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.primaryColor),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Tiếp tục mua sắm'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              // Sửa lại hành động và văn bản
              onPressed: controller.contactSupport,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
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

  // --- CÁC WIDGET TÁI SỬ DỤNG ---

  Widget _buildSection({required Widget child}) {
    return Container(
      width: double.infinity,
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: child,
    );
  }

  Widget _buildOrderSummary(OrderController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tóm tắt đơn hàng', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...controller.currentOrderItems.map((item) {
          final itemName = '${item.product.name} (x${item.quantity.value})';
          final itemTotal = item.product.price * item.quantity.value;
          return _buildSummaryRow(itemName, AppFormatters.formatCurrency(itemTotal));
        }),
        _buildSummaryRow('Vận chuyển', AppFormatters.formatCurrency(controller.currentShippingFee)),
        const Divider(height: 20),
        _buildSummaryRow('Tổng cộng', AppFormatters.formatCurrency(controller.currentTotal), isBold: true),
      ],
    );
  }

  Widget _buildShippingInfo(OrderController controller) {
    return _buildInfoCard(
      title: 'Thông tin giao hàng',
      children: [
        _buildInfoRow('Họ Tên:', controller.userName),
        _buildInfoRow('Địa Chỉ:', controller.address),
        _buildInfoRow('SĐT:', controller.phoneNumber),
      ],
    );
  }

  Widget _buildPaymentMethod(OrderController controller) {
    return _buildInfoCard(
      title: 'Phương thức thanh toán',
      children: [
        _buildInfoRow('Mbbank:', '0334043054'),
        _buildInfoRow('', 'Phan Quoc Hung'),
        const SizedBox(height: 8),
        Text(
          'hết hạn vào ngày ${controller.currentExpirationDate}',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[700])),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...children,
      ]),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Text('$title $value', style: TextStyle(color: Colors.grey[700])),
    );
  }
}