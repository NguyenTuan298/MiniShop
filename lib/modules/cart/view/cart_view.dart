import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/modules/cart/controller/cart_controller.dart';
import 'package:minishop/modules/order/controller/order_controller.dart';
import 'package:minishop/utils/format.dart';
import 'package:minishop/widgets/cart_item_card.dart';
import 'package:minishop/routes.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final orderController = Get.find<OrderController>();
    final theme = Theme.of(context);

    return Scaffold(
      // KHÔNG set backgroundColor cứng -> theo theme
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(theme),
            Expanded(
              child: Obx(() {
                if (cartController.cartItems.isEmpty) {
                  return Center(
                    child: Text(
                      'Giỏ hàng của bạn đang trống',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 16,
                      ),
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
              return _buildTotalsAndActions(context, cartController, orderController);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        children: [
          Image.asset('assets/images/logo1.png', height: 35),
          const SizedBox(height: 16),
          Text(
            'Giỏ hàng của bạn',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Khu tổng kết & hành động dưới cùng — tự đổi theo theme
  Widget _buildTotalsAndActions(
      BuildContext context,
      CartController cartController,
      OrderController orderController,
      ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.12),
            spreadRadius: 1,
            blurRadius: 6,
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
              color: theme.colorScheme.surface, // hợp cả light/dark
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildTotalRow(
                  context,
                  'Tạm tính',
                  AppFormatters.formatCurrency(cartController.subtotal),
                ),
                const SizedBox(height: 8),
                _buildTotalRow(
                  context,
                  'Phí ship',
                  AppFormatters.formatCurrency(cartController.shippingFee),
                ),
                Divider(
                  height: 20,
                  thickness: 1,
                  color: theme.dividerColor.withOpacity(0.4),
                ),
                _buildTotalRow(
                  context,
                  'Tổng cộng',
                  AppFormatters.formatCurrency(cartController.total),
                  isBold: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final orderController = Get.find<OrderController>();
                    orderController.loadDataForCheckout();          // <-- chuẩn bị dữ liệu
                    Get.toNamed(AppRoutes.orderInformation);        // <-- điều hướng
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Xác nhận đơn hàng', style: TextStyle(fontSize: 14)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: orderController.goToOrderHistory,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: theme.colorScheme.primary),
                    foregroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Xem đơn hàng', style: TextStyle(fontSize: 14)),
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

    final baseColor = theme.colorScheme.onSurface;
    final color = isBold ? baseColor : baseColor.withOpacity(0.8);

    final textStyle = theme.textTheme.bodyMedium?.copyWith(
      fontSize: 14,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      color: color,
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
