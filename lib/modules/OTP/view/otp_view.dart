import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/OTP_controller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo và tên ứng dụng
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(1, 0, 0, 0),
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
                      "Mini Shop",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Tiêu đề
                Text(
                  "Xác thực OTP",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 10),

                // Mô tả
                Text(
                  "Mã OTP đã được gửi đến số điện thoại/email của bạn",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Ô nhập OTP
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: controller.otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      letterSpacing: 8,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      hintText: "------",
                      hintStyle: const TextStyle(
                        letterSpacing: 9,
                        color: Colors.grey,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: const Icon(Icons.lock_clock, size: 25, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Nút xác thực
                SizedBox(
                  width: double.infinity,
                  child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.verifyOtp,
                    // onPressed: (){
                    //   Get.toNamed('/reset-password');
                    // },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "XÁC THỰC",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
                ),
                const SizedBox(height: 15),

                // Nút gửi lại OTP
                Obx(() => TextButton(
                  onPressed: controller.canResend.value ? controller.resendOtp : null,
                  child: Text(
                    controller.canResend.value
                        ? "Gửi lại mã OTP"
                        : "Gửi lại mã sau ${controller.countdown.value}s",
                    style: TextStyle(
                      color: controller.canResend.value
                          ? Colors.blue.shade700
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
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