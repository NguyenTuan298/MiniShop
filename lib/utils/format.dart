// lib/utils/formatters.dart

import 'package:intl/intl.dart';

class AppFormatters {
  static String formatCurrency(double amount) {
    // Sử dụng NumberFormat từ gói intl để định dạng
    final format = NumberFormat.currency(
      locale: 'vi_VN', // Định dạng cho Việt Nam
      symbol: 'đ',      // Ký hiệu tiền tệ
      decimalDigits: 0, // Không hiển thị số thập phân
    );
    return format.format(amount);
  }
}