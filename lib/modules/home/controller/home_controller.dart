// lib/modules/home/controller/home_controller.dart
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
      final fixed = await _resolveImages(rawList); // ✅ xử lý ảnh trước khi hiển thị
      promotions.assignAll(fixed);
    } catch (e) {
      promoError.value = e.toString();
      promotions.clear();
    } finally {
      isLoadingPromos.value = false;
    }
  }

  // ================= Helpers =================

  String _originFromBase() {
    final u = Uri.parse(AuthService.baseUrl); // ví dụ: https://minishop-kto7.onrender.com/api
    final port = (u.hasPort && u.port != 80 && u.port != 443) ? ':${u.port}' : '';
    return '${u.scheme}://${u.host}$port'; // https://minishop-kto7.onrender.com
  }

  // Tạo danh sách các URL ứng viên cho 1 ảnh (từ raw)
  List<String> _candidatesFor(String raw) {
    final origin = _originFromBase();
    final r = raw.trim();

    // 1) Nếu đã là http/https -> ưu tiên dùng luôn
    if (r.startsWith('http://') || r.startsWith('https://')) {
      // thêm phương án fallback nếu đường dẫn chứa /images/banners/
      if (r.contains('/images/banners/')) {
        final fname = r.split('/').last;
        return [r, '$origin/images/$fname'];
      }
      return [r];
    }

    // 2) Nếu là đường dẫn bắt đầu bằng '/' -> ghép origin + raw
    if (r.startsWith('/')) {
      final first = '$origin$r';
      // nếu có /images/banners/, thêm fallback /images/<file>
      if (r.contains('/images/banners/')) {
        final fname = r.split('/').last;
        return [first, '$origin/images/$fname'];
      }
      return [first];
    }

    // 3) Còn lại coi như tên file trần -> /images/<file> trên cùng origin
    final first = '$origin/images/$r';
    return [first];
  }

  // Kiểm tra URL có tồn tại ảnh không (HEAD trước, nếu server không hỗ trợ HEAD thì thử GET nhẹ)
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

  // Trả về Promotion với imageUrl đã được “chọn” URL chạy được, nếu không có thì dùng placeholder
  Future<Promotion> _pickWorkingImage(Promotion p) async {
    final cands = _candidatesFor(p.imageUrl);
    for (final u in cands) {
      if (await _urlHasImage(u)) {
        return p.copyWith(imageUrl: u);
      }
    }
    // placeholder (đảm bảo luôn hiển thị ảnh)
    final ph = 'https://picsum.photos/seed/${p.id}/800/450';
    return p.copyWith(imageUrl: ph);
  }

  // Xử lý toàn bộ danh sách promotions song song
  Future<List<Promotion>> _resolveImages(List<Promotion> list) async {
    final tasks = list.map(_pickWorkingImage).toList();
    return await Future.wait(tasks);
  }
}

// ✅ tiện lợi: thêm extension copyWith cho Promotion (không sửa model gốc)
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
