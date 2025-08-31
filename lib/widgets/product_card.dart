// lib/widgets/product_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/data/models/product.dart'; // ✅ giữ 1 import duy nhất
import 'package:minishop/modules/cart/controller/cart_controller.dart';
import 'package:minishop/utils/format.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = Get.find<CartController>();

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias, // bo góc cả phần ảnh
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh sản phẩm
          Expanded(
            child: Image.asset(
              product.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Thông tin + nút thêm
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppFormatters.formatCurrency(product.price),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary, // ✅ dùng ColorScheme
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _AddButton(
                      onTap: () => cart.addToCart(product),
                      color: theme.colorScheme.primary,
                      iconColor: theme.colorScheme.onPrimary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final Color iconColor;
  const _AddButton({
    required this.onTap,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 32,
          height: 32,
          child: Icon(Icons.add, size: 16, color: iconColor),
        ),
      ),
    );
  }
}
