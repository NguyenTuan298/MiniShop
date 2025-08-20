// lib/widgets/product_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/modules/cart/controller/cart_controller.dart';
import 'package:minishop/utils/format.dart';

import '../data/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  // D:\minishop\lib\widgets\product_card.dart

  @override
  Widget build(BuildContext context) {
    // Lấy dữ liệu theme hiện tại từ context
    final theme = Theme.of(context);
    // Tìm CartController đã được khởi tạo
    final cartController = Get.find<CartController>();

    return Container(
      decoration: BoxDecoration(
        // *** SỬA Ở ĐÂY: Sử dụng màu card từ theme ***
        // Màu này sẽ là xám nhạt (light mode) hoặc xám đậm (dark mode)
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phần ảnh sản phẩm (không cần thay đổi)
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.asset(
                product.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Phần thông tin (tên, giá, nút thêm)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  // *** SỬA Ở ĐÂY: Sử dụng màu chữ từ theme ***
                  // Dùng bodyMedium cho tên sản phẩm là phù hợp
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Giá sản phẩm
                    Text(
                      AppFormatters.formatCurrency(product.price),
                      style: TextStyle(
                        // *** SỬA Ở ĐÂY: Sử dụng màu chính từ theme ***
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Nút thêm vào giỏ hàng
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        // *** SỬA Ở ĐÂY: Sử dụng màu chính từ theme ***
                        color: theme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        // Màu của icon sẽ là màu tương phản với màu chính
                        icon: Icon(
                          Icons.add,
                          color: theme.colorScheme.onPrimary,
                          size: 16,
                        ),
                        onPressed: () {
                          cartController.addToCart(product);
                        },
                      ),
                    )
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