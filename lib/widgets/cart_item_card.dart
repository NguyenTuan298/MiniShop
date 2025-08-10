// lib/widgets/cart_item_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/controllers/cart_controller.dart';
import 'package:minishop/models/cart_item.dart';
import 'package:minishop/utils/format.dart';
import 'package:minishop/utils/theme.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Ảnh sản phẩm
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              item.product.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Tên và giá
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  AppFormatters.formatCurrency(item.product.price),
                  style: const TextStyle(fontSize: 14, color: AppTheme.primaryColor),
                ),
              ],
            ),
          ),
          // Tăng giảm số lượng và xóa
          Column(
            children: [
              _buildQuantityStepper(controller, item),
              const SizedBox(height: 8),
              IconButton(
                onPressed: () => controller.removeFromCart(item),
                icon: const Icon(Icons.delete, color: Colors.red),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildQuantityStepper(CartController controller, CartItem item) {
    return Row(
      children: [
        _buildStepperButton(icon: Icons.remove, onPressed: () => controller.decrementItem(item)),
        Obx(() => Text(item.quantity.value.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
        _buildStepperButton(icon: Icons.add, onPressed: () => controller.incrementItem(item)),
      ],
    );
  }

  Widget _buildStepperButton({required IconData icon, required VoidCallback onPressed}) {
    return SizedBox(
      width: 30,
      height: 30,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        padding: EdgeInsets.zero,
        splashRadius: 15,
      ),
    );
  }
}