import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/controllers/order_controller.dart';
import 'package:minishop/utils/format.dart';
import 'package:minishop/utils/theme.dart';


class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderController>();

    // Nên gọi trong onInit của controller.
    // Nếu cần gọi ở đây thì đảm bảo chỉ gọi 1 lần.
    controller.loadDataForCheckout();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildQrCodeSection(),
              const SizedBox(height: 16),
              _buildSection(child: _buildOrderSummary(controller)),
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
              _buildConfirmButton(controller),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Image.asset('assets/images/logo1.png', height: 40),
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.center,
            children: [
              const Text('Hóa Đơn',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: Get.back,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQrCodeSection() {
    return _buildSection(
      child: Column(
        children: [
          Image.asset('assets/images/thanhtoan.png', width: 200),
          const SizedBox(height: 8),
          Text('Chuyển khoản vào mã QR:',
              style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(OrderController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tóm tắt đơn hàng',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),

        // items
        ...controller.currentOrderItems.map((item) {
          final qty = (item.quantity is RxInt)
              ? (item.quantity as RxInt).value
              : item.quantity as int;
          final itemName = '${item.product.name} (x$qty)';
          final itemTotal = item.product.price * qty; // qty là int => OK
          return _buildSummaryRow(itemName, AppFormatters.formatCurrency(itemTotal));
        }),

        const Divider(height: 20),

        _buildSummaryRow(
          'Tạm tính',
          AppFormatters.formatCurrency(controller.currentSubtotal),
        ),
        _buildSummaryRow(
          'Vận chuyển',
          AppFormatters.formatCurrency(controller.currentShippingFee),
        ),
        const Divider(height: 20),
        _buildSummaryRow(
          'Tổng cộng',
          AppFormatters.formatCurrency(controller.currentTotal),
          isBold: true,
        ),
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

  Widget _buildConfirmButton(OrderController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: controller.completeOrder,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppTheme.primaryColor),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text(
            'Đã thanh toán',
            style: TextStyle(color: AppTheme.primaryColor),
          ),
        ),
      ),
    );
  }

  // Helpers
  Widget _buildSection({required Widget child}) => Container(
    width: double.infinity,
    color: Colors.grey[200],
    padding:
    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
    child: child,
  );

  Widget _buildSummaryRow(String title, String value, {bool isBold = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(color: Colors.grey[700])),
            Text(value,
                style: TextStyle(
                    fontWeight:
                    isBold ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      );

  Widget _buildInfoCard(
      {required String title, required List<Widget> children}) =>
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...children,
            ]),
      );

  Widget _buildInfoRow(String title, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.0),
    child: Text('$title $value',
        style: TextStyle(color: Colors.grey[700])),
  );
}
