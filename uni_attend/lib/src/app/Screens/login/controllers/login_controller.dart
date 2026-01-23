import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uni_attend/src/app/data/repositories/auth_repository.dart';
import 'package:uni_attend/src/app/routes/app_routes.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final selectedRole = 'Student'.obs;
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void setRole(String role) {
    selectedRole.value = role;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter both email and password',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      print("Login Controller: ${emailController.text.trim()}");
      print("Login Controller: ${passwordController.text}");

      final response = await _authRepository.signInWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // print("Login Controller: ${passwordController.text}");
      final user = response.user;
      print("user: ${user}");

      if (user != null) {
        final role = user.userMetadata?['role']?.toString().toLowerCase();
        print("user: ${user.userMetadata}");

        print("User Role: $role");

        if (role == 'student') {
          Get.offAllNamed(Routes.DASHBOARD);
        } else if (role == 'teacher') {
          Get.offAllNamed(Routes.TEACHER_DASHBOARD);
        } else {
          Get.snackbar(
            'Error',
            'Unknown user role',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } on AuthException catch (e) {
      Get.snackbar(
        'Login Failed',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred during login',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
