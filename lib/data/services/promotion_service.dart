// lib/data/services/promotion_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert' as json;
import 'package:minishop/data/models/promotion.dart';
import 'package:minishop/data/services/auth_service.dart'; // để tái dùng baseUrl

class PromotionService {
  final String _base = AuthService.baseUrl; // https://minishop-kto7.onrender.com/api

  Future<List<Promotion>> fetchActiveTop10() async {
    final uri = Uri.parse('$_base/promotions?active=1');
    final resp = await http.get(uri);

    if (resp.statusCode != 200) {
      throw Exception('HTTP ${resp.statusCode}: ${resp.body}');
    }

    final data = json.jsonDecode(resp.body) as List<dynamic>;
    return data.map((e) => Promotion.fromJson(e as Map<String, dynamic>)).toList();
  }
}
