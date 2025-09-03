// D:\MiniShop\lib\modules\cart\controller\cart_controller.dart
import 'package:get/get.dart';
import 'package:minishop/data/models/product_model.dart';
import 'package:minishop/data/models/cart_item.dart';

class CartController extends GetxController {
  final cartItems = <CartItem>[].obs;

  void addToCart(Product product) {
    final idx = cartItems.indexWhere((e) => e.product.id == product.id);
    if (idx >= 0) {
      cartItems[idx].quantity.value++;
    } else {
      // 👇 chỉ đổi .obs -> số nguyên 1
      cartItems.add(CartItem(product: product, quantity: 1));
    }
  }

  void incrementItem(CartItem item) {
    item.quantity.value++;
    cartItems.refresh();
  }

  void decrementItem(CartItem item) {
    if (item.quantity.value > 1) {
      item.quantity.value--;
      cartItems.refresh();
    } else {
      removeFromCart(item);
    }
  }

  void removeFromCart(CartItem item) {
    cartItems.removeWhere((e) => e.product.id == item.product.id);
  }

  double get subtotal =>
      cartItems.fold(0.0, (sum, it) => sum + (it.product.price * it.quantity.value));

  double get shippingFee => cartItems.isEmpty ? 0.0 : 15000.0;

  double get total => subtotal + shippingFee;
}
