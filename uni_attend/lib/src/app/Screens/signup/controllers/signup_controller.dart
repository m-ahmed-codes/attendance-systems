import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_attend/src/app/data/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final nameController = TextEditingController();
  final rollNoController = TextEditingController();
  final employeeIdController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final selectedRole = 'Student'.obs;
  final isPasswordObscured = true.obs;
  final selectedDepartment = RxnString();
  final isLoading = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    rollNoController.dispose();
    employeeIdController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void setRole(String role) {
    selectedRole.value = role;
  }

  void togglePasswordVisibility() {
    isPasswordObscured.toggle();
  }

  void setDepartment(String? department) {
    selectedDepartment.value = department;
  }

  Future<void> register() async {
    if (!_validateInput()) return;

    try {
      isLoading.value = true;

      final Map<String, dynamic> userData = {
        'full_name': nameController.text.trim(),
        'department': selectedDepartment.value,
        'role': selectedRole.value.toLowerCase(),
      };

      if (selectedRole.value == 'Student') {
        userData['roll_number'] = rollNoController.text.trim();
      } else if (selectedRole.value == 'Teacher') {
        userData['employee_id'] = employeeIdController.text.trim();
      }

      print("Registering user: ${emailController.text.trim()}");
      print("Data: $userData");

      final response = await _authRepository.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        data: userData,
      );

      if (response.user != null) {
        Get.snackbar(
          'Success',
          'Registration successful! Please check your email for verification.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        await Future.delayed(const Duration(seconds: 1));
        Get.offAllNamed('/login');
      }
    } on AuthException catch (e) {
      print("Auth Exception: ${e.message}");
      Get.snackbar(
        'Error',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateInput() {
    if (nameController.text.isEmpty) {
      Get.snackbar('Error', 'Full Name is required',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (selectedRole.value == 'Student' && rollNoController.text.isEmpty) {
      Get.snackbar('Error', 'Roll Number is required',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (selectedRole.value == 'Teacher' && employeeIdController.text.isEmpty) {
      Get.snackbar('Error', 'Employee ID is required',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (selectedDepartment.value == null) {
      Get.snackbar('Error', 'Please select a department',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar('Error', 'Invalid Email',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (passwordController.text.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    return true;
  }
}
