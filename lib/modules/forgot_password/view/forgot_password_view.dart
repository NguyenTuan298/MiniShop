import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blue.shade400),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(1, 0, 0,0),
                      child: IconButton(
                          onPressed: () {
                            Get.back();
                          } ,
                          icon: Icon(
                              Icons.arrow_back,
                              size: 30,
                          ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Image.asset("assets/images/logo.png", width: 45, height: 45),
                    const SizedBox(width: 1),
                    Text(
                      "Mini shop",
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // const Spacer(),
                    // Icon(Icons.close, color: Colors.grey.shade500),
                  ],
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 20),
                const Text(
                  'Quên Mật Khẩu',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Khôi phục mật khẩu đơn giản và nhanh chóng',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                const Text(
                  'Thông tin tài khoản',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  style: TextStyle(fontSize: 13),
                  controller: controller.phoneOrEmailController,
                  decoration: InputDecoration(
                    hintText: 'Nhập số điện thoại hoặc email',
                    prefixIcon: const Icon(Icons.person, color: Colors.black),   // thêm icon bằng prefixIcon của TextFormField
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validatePhoneOrEmail,
                ),
                const SizedBox(height: 30),
                Obx(() => ElevatedButton(
                  // onPressed: controller.isLoading.value ? null : controller.submit,
                  onPressed: () {
                    Get.toNamed('/otp');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'LẤY LẠI MẬT KHẨU',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}