import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/modules/cart/cart_controller.dart';
import 'package:minishop/modules/order/order_controller.dart';
import 'package:minishop/routes.dart';
import 'package:minishop/utils/format.dart';
import 'package:minishop/utils/theme.dart';
import 'package:minishop/widgets/cart_item_card.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final orderController = Get.find<OrderController>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Obx(() {
                if (cartController.cartItems.isEmpty) {
                  return const Center(
                    child: Text(
                      'Giỏ hàng của bạn đang trống',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    return CartItemCard(item: cartController.cartItems[index]);
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                );
              }),
            ),
            Obx(() {
              if (cartController.cartItems.isEmpty) {
                return const SizedBox.shrink();
              }
              // *** SỬA Ở ĐÂY: Truyền 'context' vào hàm helper ***
              return _buildTotalsAndActions(context, cartController, orderController);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        children: [
          Image.asset('assets/images/logo1.png', height: 35),
          const SizedBox(height: 16),
          const Text(
            'Giỏ hàng của bạn',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// *** SỬA Ở ĐÂY: Thêm BuildContext context vào tham số ***
  Widget _buildTotalsAndActions(BuildContext context, CartController cartController, OrderController orderController) {
    // Lấy theme từ context
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.cardColor, // Dùng màu card của theme
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor, // Dùng màu nền của theme
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildTotalRow(context, 'Tạm tính', AppFormatters.formatCurrency(cartController.subtotal)),
                const SizedBox(height: 8),
                _buildTotalRow(context, 'Phí ship', AppFormatters.formatCurrency(cartController.shippingFee)),
                const Divider(height: 20, thickness: 1),
                _buildTotalRow(context, 'Tổng cộng', AppFormatters.formatCurrency(cartController.total), isBold: true),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: orderController.completeOrder,
                  style: ElevatedButton.styleFrom(
                    // Lấy màu từ theme để tự động đổi theo sáng/tối
                    backgroundColor: theme.primaryColor,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Tiến hành thanh toán', style: TextStyle(fontSize: 14)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: orderController.goToOrderHistory,
                  style: OutlinedButton.styleFrom(
                    // Lấy màu từ theme
                    side: BorderSide(color: theme.primaryColor),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Xem đơn hàng',
                    style: TextStyle(fontSize: 14, color: theme.primaryColor),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTotalRow(BuildContext context, String title, String value, {bool isBold = false}) {
    final theme = Theme.of(context);

    // *** SỬA Ở ĐÂY: Cập nhật tên thuộc tính TextTheme ***
    final Color textColor;
    if (isBold) {
      // Dùng bodyLarge cho văn bản chính, nổi bật
      textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    } else {
      // Dùng bodyMedium cho văn bản phụ
      textColor = theme.textTheme.bodyMedium?.color ?? Colors.grey;
    }

    final textStyle = TextStyle(
      fontSize: 14,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      color: textColor,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: textStyle),
        Text(value, style: textStyle),
      ],
    );
  }
}