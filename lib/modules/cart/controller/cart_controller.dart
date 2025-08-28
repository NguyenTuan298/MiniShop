// lib/modules/cart/controller/cart_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart'; // thêm để dùng Color & Theme

import '../../../data/models/cart_item.dart';
import '../../../data/models/product.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
  final double shippingFee = 5000.0;

  double get subtotal =>
      cartItems.fold(0, (sum, item) => sum + (item.product.price * item.quantity.value));

  double get total => subtotal + shippingFee;

  void addToCart(Product product) {
    final index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      cartItems[index].quantity.value++;
    } else {
      cartItems.add(CartItem(product: product, quantity: 1));
    }

    // Snackbar theo theme (tự tối/sáng)
    final theme = Get.theme;
    final bg = theme.colorScheme.surface.withOpacity(
      theme.brightness == Brightness.dark ? 0.98 : 1.0,
    );
    final fg = theme.colorScheme.onSurface;

    Get.snackbar(
      'Đã thêm vào giỏ hàng',
      '${product.name} đã được thêm vào giỏ hàng của bạn.',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      backgroundColor: bg,
      colorText: fg,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      snackStyle: SnackStyle.FLOATING,
    );
  }

  void incrementItem(CartItem item) => item.quantity.value++;

  void decrementItem(CartItem item) {
    if (item.quantity.value > 1) {
      item.quantity.value--;
    } else {
      removeFromCart(item);
    }
  }

  void removeFromCart(CartItem item) => cartItems.remove(item);
}
