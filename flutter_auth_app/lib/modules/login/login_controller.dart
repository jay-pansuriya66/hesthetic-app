import 'package:flutter/material.dart';
import '../../routes/app_pages.dart';
import 'package:flutter_auth_app/services/api_service.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final apiService = ApiService();

  var isLoading = false.obs;
  var obscurePassword = true.obs;

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    final response = await apiService.login(
      usernameOrEmail: usernameController.text.trim(),
      password: passwordController.text,
    );

    isLoading.value = false;

    if (response.success) {
      Get.snackbar(
        'Success',
        response.message,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Ensure we have valid user data before navigating
      if (response.user != null) {
        // Pass the user object directly
        Get.offAllNamed(Routes.HOME, arguments: response.user);
      } else {
        // If no user data, show error and stay on login screen
        Get.snackbar(
          'Error',
          'User data not available',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        'Error',
        response.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
