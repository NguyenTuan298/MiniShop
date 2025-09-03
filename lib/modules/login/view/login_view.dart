import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

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
                // Logo + tên app
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/logo.png", width: 40, height: 40),
                    const SizedBox(width: 6),
                    Text(
                      "Mini shop",
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // const Spacer(),
                    // Icon(Icons.close, color: Colors.grey.shade500),
                  ],
                ),
                const SizedBox(height: 16),

                // Tiêu đề
                SizedBox(
                  height: 40,
                  child: Text(
                    "Đăng nhập",
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Input số điện thoại hoặc email
                _buildTextField(
                  controller.phoneEmailController,
                  Icons.person,
                  "Nhập số điện thoại hoặc email",
                  fontSize: 14,
                ),
                const SizedBox(height: 20),

                // Input mật khẩu
                Obx(() => _buildTextField(
                  controller.passwordController,
                  Icons.lock,
                  "Nhập mật khẩu",
                  obscureText: !controller.isPasswordVisible.value,
                  fontSize: 14,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 18,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                )),
                Obx(() => Text(
                  controller.errorMessage.value,
                  style: TextStyle(color: Colors.red),
                )),
                const SizedBox(height: 16),

                // Nút đăng nhập
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: controller.login,
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0066FF), Color(0xFF003366)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        height: 45,
                        child: const Text(
                          "ĐĂNG NHẬP",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Quên mật khẩu
                GestureDetector(
                  onTap: (){
                    Get.toNamed('/forgot-password');
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Quên mật khẩu?",
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Divider
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text("Hoặc đăng nhập với"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 12),

                // Nút Google
                Container(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade500),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () {},
                    icon: Center(
                      child: Image.asset(
                        "assets/images/logo_google.png",
                        width: 20,
                        height: 20,
                      ),
                    ),
                    label: const Text(
                      "Continue with Google",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Đăng ký
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Chưa có tài khoản? "),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/register');
                      },
                      child: Text(
                        "Đăng ký",
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      IconData icon,
      String hint, {
        bool obscureText = false,
        Widget? suffixIcon,
        double fontSize = 16,
      }) {
    return TextField(
      style: TextStyle(color: Colors.black, fontSize: fontSize),
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        isDense: true,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        prefixIcon: Icon(icon, size: 20),
        suffixIcon: suffixIcon,
        hintText: hint,
        hintStyle: TextStyle(fontSize: fontSize),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
