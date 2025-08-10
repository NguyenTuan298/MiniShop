import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:minishop/controllers/order_controller.dart'; // *** THÊM IMPORT NÀY ***
import 'package:minishop/models/cart_item.dart';
import 'package:minishop/models/order.dart';
import 'package:minishop/routes.dart';
import 'package:minishop/utils/format.dart';
import 'package:minishop/utils/theme.dart';

class OrderDetailView extends StatelessWidget {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Sửa lại kiểu dữ liệu của controller
    final controller = Get.find<OrderController>();

    // Gọi hàm để tải dữ liệu cho màn hình này
    controller.loadSelectedOrderDetails();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          final order = controller.selectedOrder.value;
          if (order == null) {
            return const Center(
              child: Text('Không tìm thấy thông tin đơn hàng.'),
            );
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildSection(child: _buildOrderSummary(order)),
                _buildItemListSection(controller, order),
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
                _buildBottomButton(controller),
                const SizedBox(height: 16),
              ],
            ),
          );
        }),
      ),
    );
  }

  // --- CÁC HÀM HELPER XÂY DỰNG GIAO DIỆN (ĐÃ SỬA LẠI THAM SỐ) ---

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/logo1.png', height: 40),
          const SizedBox(height: 16),
          const Text('Order Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(OrderModel order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Đơn hàng #${order.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 12),
        _buildSummaryRow('Ngày đặt hàng:', DateFormat('d/M/yyyy').format(order.date)),
        _buildSummaryRow('Tổng cộng', AppFormatters.formatCurrency(order.totalAmount)),
      ],
    );
  }

  Widget _buildItemListSection(OrderController controller, OrderModel order) {
    return _buildSection(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Các mặt hàng trong đơn', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            ...order.items.map((item) => _buildProductRow(item)),
            const Divider(height: 24),
            // Sửa lại cách truy cập
            _buildSummaryRow('Tạm tính', AppFormatters.formatCurrency(controller.selectedOrderSubtotal)),
            _buildSummaryRow('Vận chuyển', AppFormatters.formatCurrency(controller.shippingFee)),
            const Divider(height: 24),
            _buildSummaryRow('Tổng', AppFormatters.formatCurrency(order.totalAmount), isBold: true),
          ],
        )
    );
  }

  Widget _buildProductRow(CartItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(item.product.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(
                '${item.quantity.value} × ${AppFormatters.formatCurrency(item.product.price)}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Sửa lại kiểu tham số
  Widget _buildShippingInfo(OrderController controller) {
    return _buildInfoCard(
      title: 'Thông tin giao hàng',
      children: [
        // Truy cập đúng biến trong OrderController
        _buildInfoRow('Họ Tên:', controller.userName),
        _buildInfoRow('Địa Chỉ:', controller.address),
        _buildInfoRow('SĐT:', controller.phoneNumber),
      ],
    );
  }

  // Sửa lại kiểu tham số
  Widget _buildPaymentMethod(OrderController controller) {
    return _buildInfoCard(
      title: 'Phương thức thanh toán',
      children: [
        _buildInfoRow('Mbbank:', '0334043054'),
        _buildInfoRow('', 'Phan Quoc Hung'),
        const SizedBox(height: 8),
        Text(
          // Truy cập đúng biến trong OrderController
          'hết hạn vào ngày ${controller.selectedOrderExpirationDate}',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }

  // Sửa lại kiểu tham số
  Widget _buildBottomButton(OrderController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Get.toNamed(AppRoutes.checkout, arguments: controller.selectedOrder.value);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text('Tiếp tục thanh toán'),
        ),
      ),
    );
  }


  // --- WIDGETS TIỆN ÍCH ---
  Widget _buildSection({required Widget child}) {
    return Container(
      width: double.infinity,
      color: Colors.grey[200],
      padding: const EdgeInsets.all(16.0),
      child: child,
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
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