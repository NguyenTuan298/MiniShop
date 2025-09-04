import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductService extends GetxService {
  static const String baseUrl = 'https://minishop-kto7.onrender.com/api';

  Future<List<dynamic>> fetchProductsByCategory(String category) async {
    final response =
    await http.get(Uri.parse('$baseUrl/products?category=$category'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['products'];
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }
}
