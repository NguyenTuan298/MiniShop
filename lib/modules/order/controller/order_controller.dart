import 'dart:math';
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

  /// Lịch sử đơn hàng
  final orderHistory = <OrderModel>[].obs;

  /// Phí ship cố định (có thể thay đổi)
  final double shippingFee = 5000.0;

  //========================================================================
  // SHIPPING INFO (Reactive) - có thể chỉnh ở OrderInformationView
  //========================================================================

  final RxString _shippingName = ''.obs;
  final RxString _shippingAddress = ''.obs;
  final RxString _shippingPhone = ''.obs;

  /// Getter giữ API cũ để các màn khác không phải sửa
  String get userName => _shippingName.value;
  String get address => _shippingAddress.value;
  String get phoneNumber => _shippingPhone.value;

  /// Cập nhật thông tin giao hàng (được gọi từ OrderInformationController)
  void updateShippingInfo({
    required String name,
    required String address,
    required String phone,
  }) {
    _shippingName.value = name;
    _shippingAddress.value = address;
    _shippingPhone.value = phone;
  }

  //========================================================================
  // STATE CHO MÀN HÌNH CHI TIẾT ĐƠN HÀNG (OrderDetailView)
  //========================================================================

  /// Đơn hàng đang xem chi tiết
  final Rx<OrderModel?> selectedOrder = Rx<OrderModel?>(null);

  /// Ngày hết hạn của đơn hàng đang xem
  String selectedOrderExpirationDate = 'N/A';

  /// Tổng phụ của đơn hàng đang xem chi tiết
  double get selectedOrderSubtotal {
    if (selectedOrder.value == null) return 0;
    return selectedOrder.value!.totalAmount - shippingFee;
  }

  /// Tải dữ liệu cho OrderDetailView
  void loadSelectedOrderDetails() {
    if (Get.arguments is OrderModel) {
      selectedOrder.value = Get.arguments as OrderModel;
      final orderDate = selectedOrder.value!.date;
      final futureDate = orderDate.add(const Duration(days: 5));
      selectedOrderExpirationDate = DateFormat('dd/MM/yyyy').format(futureDate);
    }
  }

  //========================================================================
  // STATE CHO LUỒNG THANH TOÁN (Checkout / Success / OrderInformation)
  //========================================================================

  /// Dữ liệu hóa đơn hiện tại (dùng private backing field + getters an toàn)
  List<CartItem> _currentOrderItems = <CartItem>[];
  double _currentSubtotal = 0;
  double _currentShippingFee = 0;
  double _currentTotal = 0;
  String _currentExpirationDate = '';

  List<CartItem> get currentOrderItems => _currentOrderItems;
  double get currentSubtotal => _currentSubtotal;
  double get currentShippingFee => _currentShippingFee;
  double get currentTotal => _currentTotal;
  String get currentExpirationDate => _currentExpirationDate;

  /// Mã đơn hoàn tất cho màn success
  final completedOrderId = ''.obs;

  /// Nếu đang thanh toán cho một đơn hàng cũ
  OrderModel? _payingForExistingOrder;

  /// Chuẩn bị dữ liệu cho Checkout/OrderInformation
  /// Tự quyết định lấy từ giỏ hàng hay từ đơn hàng cũ (Get.arguments)
  void loadDataForCheckout() {
    if (Get.arguments is OrderModel) {
      // Thanh toán lại đơn cũ
      _payingForExistingOrder = Get.arguments as OrderModel;
      final order = _payingForExistingOrder!;

      _currentOrderItems = order.items;
      _currentShippingFee = shippingFee;
      _currentTotal = order.totalAmount;
      _currentSubtotal = _currentTotal - _currentShippingFee;

      final futureDate = order.date.add(const Duration(days: 5));
      _currentExpirationDate = DateFormat('dd/MM/yyyy').format(futureDate);
    } else {
      // Thanh toán giỏ hàng hiện tại
      _payingForExistingOrder = null;
      _prepareDataFromCart();
    }

    // Nếu thông tin giao hàng đang trống, gán giá trị mặc định an toàn
    if (_shippingName.value.isEmpty) _shippingName.value = '...';
    if (_shippingAddress.value.isEmpty) _shippingAddress.value = '...';
    if (_shippingPhone.value.isEmpty) _shippingPhone.value = '...';
  }

  /// Lấy dữ liệu từ giỏ hàng
  void _prepareDataFromCart() {
    _currentOrderItems = List<CartItem>.from(cartController.cartItems);
    _currentSubtotal = cartController.subtotal;
    _currentShippingFee = cartController.shippingFee;
    _currentTotal = cartController.total;

    final now = DateTime.now();
    final futureDate = now.add(const Duration(days: 5));
    _currentExpirationDate = DateFormat('dd/MM/yyyy').format(futureDate);
  }

  //========================================================================
  // HÀNH ĐỘNG & ĐIỀU HƯỚNG
  //========================================================================

  /// Hoàn tất đơn hàng (đã thanh toán)
  void completeOrder() {
    if (_payingForExistingOrder != null) {
      // Thanh toán lại đơn hàng lịch sử
      final idx = orderHistory.indexWhere((o) => o.id == _payingForExistingOrder!.id);
      if (idx != -1) {
        orderHistory[idx].status = OrderStatus.paid;
        orderHistory.refresh();
      }

      completedOrderId.value = _payingForExistingOrder!.id;
      loadDataForCheckout(); // cập nhật lại dữ liệu tạm

      Get.toNamed(AppRoutes.orderSuccess);
      Get.snackbar('Thành công', 'Đơn hàng #${_payingForExistingOrder!.id} đã được thanh toán.');
      return;
    }

    // Thanh toán giỏ hàng mới
    _prepareDataFromCart();
    if (_currentOrderItems.isEmpty) {
      Get.snackbar('Thông báo', 'Giỏ hàng của bạn đang trống.');
      return;
    }

    completedOrderId.value = (Random().nextInt(900) + 100).toString();

    final newOrder = OrderModel(
      id: completedOrderId.value,
      date: DateTime.now(),
      items: List<CartItem>.from(_currentOrderItems),
      totalAmount: _currentTotal,
      status: OrderStatus.paid,
    );

    orderHistory.insert(0, newOrder);
    Get.toNamed(AppRoutes.orderSuccess);
    cartController.cartItems.clear();
  }

  /// Quay về Trang chủ (tab 0)
  void goToShopping() {
    Get.until((route) => Get.currentRoute == AppRoutes.dashboard);
    Get.find<DashboardController>().changeTabIndex(0);
  }

  /// Mở tab Lịch sử đơn hàng (tab 3)
  void goToOrderHistory() {
    Get.until((route) => Get.currentRoute == AppRoutes.dashboard);
    Get.find<DashboardController>().changeTabIndex(3);
  }

  /// Điều hướng tới màn hỗ trợ
  void contactSupport() {
    Get.toNamed(AppRoutes.support, arguments: completedOrderId.value);
  }
}
