import 'package:get/get.dart';
import 'package:uni_attend/src/app/data/repositories/student_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uni_attend/src/app/routes/app_routes.dart';

class ProfileController extends GetxController {
  final StudentRepository _repository = StudentRepository();

  final studentName = '--'.obs;
  final studentId = '--'.obs;
  final department = '--'.obs;
  final email = '--'.obs;
  final phone = '--'.obs;

  final isLoading = false.obs;
  final isBiometricRegistered = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final profile = await _repository.getStudentProfile();
      if (profile != null) {
        studentName.value = profile['full_name'] ?? '--';
        studentId.value = profile['roll_number'] ?? '--';
        department.value = profile['department'] ?? '--';
        email.value = profile['email'] ?? '--';
        phone.value = profile['phone'] ?? '--';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void registerBiometric() {
    // Logic to start face registration
    print('Starting Face Registration...');
  }

  void editProfile() {
    Get.snackbar('Info', 'Edit Profile not implemented yet');
  }

  void changePassword() {
    Get.snackbar('Info', 'Change Password not implemented yet');
  }

  Future<void> logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar('Error', 'Logout failed: $e');
    }
  }
}
