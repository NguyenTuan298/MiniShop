import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/modules/order/controller/order_controller.dart';
import 'package:minishop/routes.dart';
import '../../../data/models/cart_item.dart';

class OrderInformationController extends GetxController {
  final OrderController order = Get.find<OrderController>();

  // Form controllers
  late final TextEditingController nameCtrl;
  late final TextEditingController addressCtrl;
  late final TextEditingController phoneCtrl;
  // Hiển thị tóm tắt
  List<CartItem> get items => order.currentOrderItems;
  double get subtotal => order.currentSubtotal;
  double get shippingFee => order.currentShippingFee;
  double get total => order.currentTotal;

  // Hiển thị ngày hết hạn thanh toán (nếu cần)
  String get expirationDate => order.currentExpirationDate;

  @override
  void onInit() {
    super.onInit();
    // đảm bảo dữ liệu có sẵn
    order.loadDataForCheckout();

    nameCtrl = TextEditingController(text: order.userName);
    addressCtrl = TextEditingController(text: order.address);
    phoneCtrl = TextEditingController(text: order.phoneNumber);
  }

  void saveShipping() {
    order.updateShippingInfo(
      name: nameCtrl.text.trim(),
      address: addressCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
    );
    // Không pop ngay, vì có thể user muốn xem tiếp tóm tắt rồi mới rời
    // Nếu muốn pop sau khi lưu: Get.back();
  }

  void back() => Get.back();
  void proceedToCheckout() {
    saveShipping(); // Lưu trước khi đi tiếp
    Get.toNamed(AppRoutes.checkout);
  }

  void contactSupport() => order.contactSupport();

  @override
  void onClose() {
    nameCtrl.dispose();
    addressCtrl.dispose();
    phoneCtrl.dispose();
    super.onClose();
  }
}
