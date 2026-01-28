import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_attend/src/app/data/repositories/student_repository.dart';
import 'package:uni_attend/src/app/Screens/profile/controllers/profile_controller.dart';
import 'package:uni_attend/src/app/routes/app_routes.dart';

class ScanSuccessView extends StatelessWidget {
  const ScanSuccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments;
    final List<List<double>> embeddings =
        args['embeddings'] ?? [args['embedding']];
    final RxBool isSaving = false.obs;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline,
                  color: Colors.green, size: 100),
              const SizedBox(height: 24),
              const Text(
                'Face Scanned Successfully',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF101922),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your biometric data has been generated. Press the button below to securely save it to your profile.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 48),
              Obx(() => ElevatedButton(
                    onPressed: isSaving.value
                        ? null
                        : () async {
                            isSaving.value = true;
                            try {
                              final repo = StudentRepository();
                              await repo.updateFaceEmbeddings(embeddings);

                              // Refresh profile
                              if (Get.isRegistered<ProfileController>()) {
                                await Get.find<ProfileController>()
                                    .fetchProfile();
                              }

                              Get.snackbar(
                                'Success',
                                'Face data saved successfully',
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );

                              // Go back to profile
                              Get.offAllNamed(Routes.DASHBOARD);
                              // Navigate to profile tab specifically if possible,
                              // but offAllNamed is safer to clear camera state.
                            } catch (e) {
                              Get.snackbar(
                                  'Error', 'Failed to save face data: $e');
                            } finally {
                              isSaving.value = false;
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF137fec),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: isSaving.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Save Face Embedding',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                  )),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Retake Scan',
                    style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
