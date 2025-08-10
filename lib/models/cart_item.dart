// lib/models/cart_item.dart

import 'package:get/get.dart';
import 'package:minishop/models/product.dart';

class CartItem {
  final Product product;
  final RxInt quantity;

  CartItem({required this.product, required int quantity})
      : quantity = quantity.obs;
}