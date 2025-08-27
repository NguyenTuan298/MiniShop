import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/modules/category/controller/category_controller.dart';
import 'package:minishop/widgets/category_card.dart';

// Sửa thành GetView để code gọn hơn và tuân thủ best practice
class CategoryListView extends GetView<CategoryController> {
  const CategoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    // Lưu ý: Đoạn mã này vẫn giữ lại Scaffold và AppBar.
    // Trong ứng dụng thực tế của bạn, bạn nên loại bỏ chúng và tích hợp
    // AppBar vào DashboardView như đã làm trước đó để giữ lại thanh điều hướng dưới.

    return Scaffold(
      appBar: AppBar(
        // ... phần leading giữ nguyên ...
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: Text(
              "Minishop",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        leadingWidth: 100,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          // SỬA ĐỔI: Thêm onChanged cho TextField
          child: TextField(
            // Gọi hàm updateSearchQuery trong controller mỗi khi nội dung thay đổi
            onChanged: controller.updateSearchQuery,
            decoration: const InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        // SỬA ĐỔI: Hiển thị thông báo nếu không có kết quả tìm kiếm
        if (controller.filteredCategories.isEmpty) {
          return const Center(
            child: Text(
              'Không tìm thấy danh mục nào',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          // SỬA ĐỔI: Sử dụng danh sách đã lọc thay vì danh sách gốc
          itemCount: controller.filteredCategories.length,
          itemBuilder: (context, index) {
            // SỬA ĐỔI: Lấy danh mục từ danh sách đã lọc
            final category = controller.filteredCategories[index];
            return CategoryCard(category: category);
          },
        );
      }),
    );
  }
}