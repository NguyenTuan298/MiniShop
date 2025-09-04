// lib/modules/home/controller/home_controller.dart
import 'package:get/get.dart';
import 'package:minishop/data/models/promotion.dart';
import 'package:minishop/data/services/promotion_service.dart';

class HomeController extends GetxController {
  final promotions = <Promotion>[].obs;
  final isLoadingPromos = false.obs;
  final promoError = RxnString();

  final _service = PromotionService();

  @override
  void onInit() {
    super.onInit();
    loadPromotions();
  }

  Future<void> loadPromotions() async {
    try {
      isLoadingPromos.value = true;
      promoError.value = null;

      final list = await _service.fetchActiveTop10();
      promotions.assignAll(list);
    } catch (e) {
      promoError.value = e.toString();
      promotions.clear();
    } finally {
      isLoadingPromos.value = false;
    }
  }
}
