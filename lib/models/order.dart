// lib/models/order.dart

import 'package:minishop/models/cart_item.dart';

// Định nghĩa các trạng thái có thể có của đơn hàng
enum OrderStatus { pending, paid, shipped, delivered, cancelled }

class OrderModel {
  final String id;
  final DateTime date;
  final List<CartItem> items;
  final double totalAmount;
  OrderStatus status; // Thêm trường trạng thái

  OrderModel({
    required this.id,
    required this.date,
    required this.items,
    required this.totalAmount,
    this.status = OrderStatus.pending, // Mặc định là "Chờ thanh toán"
  });
}