import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:minishop/modules/cart/controller/cart_controller.dart';
import 'package:minishop/modules/dashboard/controller/dashboard_controller.dart';
import 'package:minishop/routes.dart';

import '../../../data/models/cart_item.dart';
import '../../../data/models/order.dart';

class OrderController extends GetxController {
  //========================================================================
  // DEPENDENCIES & CORE STATE
  //========================================================================

  final CartController cartController = Get.find();

  /// Danh sách lịch sử tất cả các đơn hàng của người dùng.
  /// Dùng .obs để OrderHistoryView tự động cập nhật khi có đơn hàng mới.
  var orderHistory = <OrderModel>[].obs;

  /// Dữ liệu người dùng giả lập (trong thực tế sẽ lấy từ AuthController).
  final String userName = 'Nguyễn Quốc Tuấn';
  final String address = 'Thủ Đức';
  final String phoneNumber = '0321123222';
  final double shippingFee = 5000.0;

  //========================================================================
  // STATE CHO MÀN HÌNH CHI TIẾT ĐƠN HÀNG (OrderDetailView)
  //========================================================================

  /// Đơn hàng đang được chọn để xem chi tiết.
  final Rx<OrderModel?> selectedOrder = Rx<OrderModel?>(null);

  /// Ngày hết hạn của đơn hàng đang được xem chi tiết.
  late String selectedOrderExpirationDate;

  /// Getter để tính tổng phụ của đơn hàng đang xem chi tiết.
  double get selectedOrderSubtotal {
    if (selectedOrder.value == null) return 0;
    return selectedOrder.value!.totalAmount - shippingFee;
  }

  /// Tải dữ liệu cho màn hình Chi tiết đơn hàng.
  /// Được gọi từ `build()` của OrderDetailView.
  void loadSelectedOrderDetails() {
    if (Get.arguments is OrderModel) {
      selectedOrder.value = Get.arguments;
      if (selectedOrder.value != null) {
        final orderDate = selectedOrder.value!.date;
        final futureDate = orderDate.add(const Duration(days: 5));
        selectedOrderExpirationDate = DateFormat('dd/MM/yyyy').format(futureDate);
      } else {
        selectedOrderExpirationDate = 'N/A';
      }
    }
  }

  //========================================================================
  // STATE CHO LUỒNG THANH TOÁN (CheckoutView & OrderSuccessView)
  //========================================================================

  /// Dữ liệu tạm thời cho hóa đơn hiện tại (biến thường).
  late List<CartItem> currentOrderItems;
  late double currentSubtotal;
  late double currentShippingFee;
  late double currentTotal;
  late String currentExpirationDate;

  /// Mã của đơn hàng vừa hoàn tất (dùng cho OrderSuccessView).
  var completedOrderId = ''.obs;

  /// Biến nội bộ để xác định xem có đang thanh toán cho một đơn hàng cũ không.
  OrderModel? _payingForExistingOrder;

  /// Tải dữ liệu cho màn hình Hóa đơn (CheckoutView).
  /// Hàm này sẽ tự quyết định lấy dữ liệu từ giỏ hàng hay từ một đơn hàng cũ.
  void loadDataForCheckout() {
    if (Get.arguments is OrderModel) {
      // Luồng 1: Thanh toán cho một đơn hàng cũ đã có trong lịch sử.
      _payingForExistingOrder = Get.arguments;
      final order = _payingForExistingOrder!;

      currentOrderItems = order.items;
      currentTotal = order.totalAmount;
      currentShippingFee = shippingFee;
      currentSubtotal = order.totalAmount - currentShippingFee;
      final futureDate = order.date.add(const Duration(days: 5));
      currentExpirationDate = DateFormat('dd/MM/yyyy').format(futureDate);
    } else {
      // Luồng 2: Thanh toán cho giỏ hàng hiện tại.
      _payingForExistingOrder = null;
      _prepareDataFromCart();
    }
  }

  /// Hàm nội bộ để chuẩn bị dữ liệu từ CartController.
  void _prepareDataFromCart() {
    currentOrderItems = List.from(cartController.cartItems);
    currentSubtotal = cartController.subtotal;
    currentShippingFee = cartController.shippingFee;
    currentTotal = cartController.total;
    final now = DateTime.now();
    final futureDate = now.add(const Duration(days: 5));
    currentExpirationDate = DateFormat('dd/MM/yyyy').format(futureDate);
  }

  //========================================================================
  // CÁC HÀNH ĐỘNG VÀ ĐIỀU HƯỚNG
  //========================================================================

  /// Hoàn tất đơn hàng. Được gọi từ nút "Đã thanh toán" hoặc "Tiến hành thanh toán".
  void completeOrder() {
    if (_payingForExistingOrder != null) {
      // --- XỬ LÝ THANH TOÁN CHO ĐƠN HÀNG CŨ ---
      final index = orderHistory.indexWhere((o) => o.id == _payingForExistingOrder!.id);
      if (index != -1) {
        orderHistory[index].status = OrderStatus.paid;
        orderHistory.refresh(); // Thông báo cho UI (OrderHistoryView) cập nhật
      }

      // Chuẩn bị dữ liệu để hiển thị trên màn hình xác nhận
      completedOrderId.value = _payingForExistingOrder!.id;
      // Tải lại dữ liệu vào các biến tạm thời
      loadDataForCheckout();

      Get.toNamed(AppRoutes.orderSuccess);
      Get.snackbar('Thành công', 'Đơn hàng #${_payingForExistingOrder!.id} đã được thanh toán.');
    } else {
      // --- XỬ LÝ THANH TOÁN CHO GIỎ HÀNG MỚI ---
      _prepareDataFromCart();
      if (currentOrderItems.isEmpty) {
        Get.snackbar('Thông báo', 'Giỏ hàng của bạn đang trống.');
        return;
      }

      completedOrderId.value = (Random().nextInt(900) + 100).toString();

      final newOrder = OrderModel(
        id: completedOrderId.value,
        date: DateTime.now(),
        items: List<CartItem>.from(currentOrderItems),
        totalAmount: currentTotal,
        status: OrderStatus.paid,
      );
      orderHistory.insert(0, newOrder);

      Get.toNamed(AppRoutes.orderSuccess);
      cartController.cartItems.clear();
    }
  }

  /// Điều hướng về trang chủ.
  void goToShopping() {
    Get.until((route) => Get.currentRoute == AppRoutes.dashboard);
    Get.find<DashboardController>().changeTabIndex(0);
  }

  /// Điều hướng đến lịch sử đơn hàng.
  void goToOrderHistory() {
    Get.until((route) => Get.currentRoute == AppRoutes.dashboard);
    Get.find<DashboardController>().changeTabIndex(3);
  }

  /// Xử lý hành động liên hệ hỗ trợ.
  void contactSupport() {
    Get.toNamed(AppRoutes.support, arguments: completedOrderId.value);
  }
}