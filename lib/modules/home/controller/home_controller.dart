import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:minishop/data/models/promotion.dart';
import 'package:minishop/data/services/promotion_service.dart';
import 'package:minishop/data/services/auth_service.dart';

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

      final rawList = await _service.fetchActiveTop10();
      final fixed = await _resolveImages(rawList);
      promotions.assignAll(fixed);
    } catch (e) {
      promoError.value = e.toString();
      promotions.clear();
    } finally {
      isLoadingPromos.value = false;
    }
  }


  String _originFromBase() {
    final u = Uri.parse(AuthService.baseUrl);
    final port = (u.hasPort && u.port != 80 && u.port != 443) ? ':${u.port}' : '';
    return '${u.scheme}://${u.host}$port'; // https://minishop-kto7.onrender.com
  }

  List<String> _candidatesFor(String raw) {
    final origin = _originFromBase();
    final r = raw.trim();

    if (r.startsWith('http://') || r.startsWith('https://')) {
      if (r.contains('/images/banners/')) {
        final fname = r.split('/').last;
        return [r, '$origin/images/$fname'];
      }
      return [r];
    }

    if (r.startsWith('/')) {
      final first = '$origin$r';
      if (r.contains('/images/banners/')) {
        final fname = r.split('/').last;
        return [first, '$origin/images/$fname'];
      }
      return [first];
    }

    final first = '$origin/images/$r';
    return [first];
  }

  Future<bool> _urlHasImage(String url) async {
    try {
      final uri = Uri.parse(url);
      final head = await http
          .head(uri, headers: const {'Accept': 'image/*'})
          .timeout(const Duration(seconds: 3));
      if (head.statusCode == 200) return true;

      // fallback thử GET nếu HEAD bị chặn
      if (head.statusCode == 405 || head.statusCode == 403) {
        final get = await http
            .get(uri, headers: const {'Accept': 'image/*'})
            .timeout(const Duration(seconds: 4));
        return get.statusCode == 200 && (get.headers['content-type']?.startsWith('image/') ?? false);
      }
    } catch (_) {}
    return false;
  }

  Future<Promotion> _pickWorkingImage(Promotion p) async {
    final cands = _candidatesFor(p.imageUrl);
    for (final u in cands) {
      if (await _urlHasImage(u)) {
        return p.copyWith(imageUrl: u);
      }
    }
    final ph = 'https://picsum.photos/seed/${p.id}/800/450';
    return p.copyWith(imageUrl: ph);
  }

  Future<List<Promotion>> _resolveImages(List<Promotion> list) async {
    final tasks = list.map(_pickWorkingImage).toList();
    return await Future.wait(tasks);
  }
}

extension _PromotionCopy on Promotion {
  Promotion copyWith({
    int? id,
    String? title,
    String? subtitle,
    String? description,
    String? imageUrl,
    int? discountPercent,
    DateTime? startAt,
    DateTime? endAt,
  }) {
    return Promotion(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      discountPercent: discountPercent ?? this.discountPercent,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
    );
  }
}
