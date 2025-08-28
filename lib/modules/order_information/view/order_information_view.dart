import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/modules/order_information/controller/order_information_controller.dart';
import 'package:minishop/modules/profile/service/profile_service.dart';
import 'package:minishop/utils/format.dart';
import 'package:minishop/routes.dart';

// ✅ Thêm import ProfileService để đọc/ghi thông tin hồ sơ
import 'package:minishop/modules/profile/service/profile_service.dart';

class OrderInformationView extends GetView<OrderInformationController> {
  const OrderInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(theme),
              _buildSection(
                context: context,
                child: _buildOrderSummary(context),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildShippingEditor(context)), // <— chỉnh & lưu vào hồ sơ
                    const SizedBox(width: 16),
                    Expanded(child: _buildPaymentMethod(context)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildActionButtons(context),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Image.asset('assets/images/logo1.png', height: 40),
          const SizedBox(height: 8),
          SizedBox(
            height: 48,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  'Thông tin đơn hàng',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: controller.back,
                    icon: const Icon(Icons.arrow_back),
                    color: theme.appBarTheme.iconTheme?.color
                        ?? theme.iconTheme.color
                        ?? theme.colorScheme.onSurface,
                    tooltip: 'Quay lại',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required BuildContext context, required Widget child}) {
    final theme = Theme.of(context);
    final bg = theme.colorScheme.surfaceVariant.withOpacity(
      theme.brightness == Brightness.dark ? 0.25 : 1.0,
    );
    return Container(
      width: double.infinity,
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: child,
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tóm tắt đơn hàng',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...controller.items.map((it) {
          final qty = it.quantity.value;
          final name = '${it.product.name} (x$qty)';
          final total = it.product.price * qty;
          return _row(context, name, AppFormatters.formatCurrency(total));
        }),
        _row(context, 'Vận chuyển', AppFormatters.formatCurrency(controller.shippingFee)),
        Divider(height: 20, color: theme.dividerColor.withOpacity(0.4)),
        _row(context, 'Tổng cộng', AppFormatters.formatCurrency(controller.total), isBold: true),
      ],
    );
  }

  // === SHIPPING EDITOR (lấy & lưu vào Hồ sơ) ===
  Widget _buildShippingEditor(BuildContext context) {
    final theme = Theme.of(context);
    final profile = Get.find<ProfileService>(); // lấy dữ liệu hồ sơ đã lưu

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Thông tin giao hàng',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.editProfile),
                child: const Text('Chỉnh sửa'),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Hiển thị nhãn:giá trị từ trái sang phải; Địa chỉ tối đa 3 dòng
          Obx(() => _labeledValue(context, 'Họ Tên', profile.name.value)),
          Obx(() => _labeledValue(context, 'Địa Chỉ', profile.address.value, maxLines: 3)),
          Obx(() => _labeledValue(context, 'SĐT', profile.phone.value)),
        ],
      ),
    );
  }

  Widget _labeledValue(BuildContext context, String label, String value, {int maxLines = 1}) {
    final theme = Theme.of(context);
    final base = theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: base.withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: maxLines,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(color: base),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(BuildContext context) {
    final theme = Theme.of(context);
    final sub = theme.colorScheme.onSurface.withOpacity(0.6);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Phương thức thanh toán',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _infoText(context, 'Mbbank: ', '0334043054'),
          _infoText(context, '', 'Phan Quoc Hung'),
          const SizedBox(height: 8),
          Text('hết hạn vào ngày ${controller.expirationDate}',
              style: theme.textTheme.bodySmall?.copyWith(color: sub)),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String left, String right, {bool isBold = false}) {
    final theme = Theme.of(context);
    final base = theme.colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(left,
                style: theme.textTheme.bodyMedium?.copyWith(color: base.withOpacity(0.8)),
                overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: 12),
          Text(right,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: base,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              )),
        ],
      ),
    );
  }

  Widget _infoText(BuildContext context, String title, String value) {
    final theme = Theme.of(context);
    final sub = theme.colorScheme.onSurface.withOpacity(0.8);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Text(title.isEmpty ? value : '$title$value',
          style: theme.textTheme.bodyMedium?.copyWith(color: sub)),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              // Lưu + đi tiếp thanh toán
              onPressed: controller.proceedToCheckout,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.colorScheme.primary),
                foregroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Tiến hành thanh toán'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: controller.contactSupport,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Liên hệ hỗ trợ'),
            ),
          ),
        ],
      ),
    );
  }
}
