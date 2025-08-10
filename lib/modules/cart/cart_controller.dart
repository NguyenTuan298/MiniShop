// lib/controllers/cart_controller.dart

import 'package:get/get.dart';
import 'package:minishop/models/cart_item.dart';
import 'package:minishop/models/product.dart';

class CartController extends GetxController {
  // Danh sách các sản phẩm trong giỏ, .obs để UI tự động cập nhật
  var cartItems = <CartItem>[].obs;

  // Phí ship (có thể thay đổi sau này)
  final double shippingFee = 5000.0;

  /// Tính tổng tiền hàng (chưa có phí ship)
  double get subtotal => cartItems.fold(
      0, (sum, item) => sum + (item.product.price * item.quantity.value));

  /// Tính tổng tiền cuối cùng
  double get total => subtotal + shippingFee;

  /// Thêm sản phẩm vào giỏ hàng
  void addToCart(Product product) {
    // Tìm xem sản phẩm đã có trong giỏ chưa
    final index = cartItems.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      // Nếu đã có, chỉ tăng số lượng
      cartItems[index].quantity.value++;
    } else {
      // Nếu chưa có, thêm mới vào giỏ
      cartItems.add(CartItem(product: product, quantity: 1));
    }

    // Hiển thị thông báo cho người dùng
    Get.snackbar(
      'Đã thêm vào giỏ hàng',
      '${product.name} đã được thêm vào giỏ hàng của bạn.',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  /// Tăng số lượng của một mặt hàng
  void incrementItem(CartItem item) {
    item.quantity.value++;
  }

  /// Giảm số lượng của một mặt hàng
  void decrementItem(CartItem item) {
    if (item.quantity.value > 1) {
      item.quantity.value--;
    } else {
      // Nếu số lượng là 1 và người dùng nhấn trừ, xóa khỏi giỏ hàng
      removeFromCart(item);
    }
  }

  /// Xóa một mặt hàng khỏi giỏ hàng
  void removeFromCart(CartItem item) {
    cartItems.remove(item);
  }
}