import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_attend/src/app/data/repositories/student_repository.dart';
import 'package:uni_attend/src/app/routes/app_routes.dart';
import 'package:uni_attend/src/app/Screens/mark_attendance/controllers/mark_attendance_controller.dart';

class AttendanceVerificationResultView extends StatelessWidget {
  const AttendanceVerificationResultView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments;
    final bool isMatched = args['isMatched'] ?? false;
    final String? courseId = args['course_id'];
    final String? sessionId = args['session_id'];

    final RxBool isSaving = false.obs;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Face Verification',
            style: TextStyle(
                color: Color(0xFF101922), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isMatched ? Icons.check_circle : Icons.error_outline,
                color: isMatched ? Colors.green : Colors.red,
                size: 100,
              ),
              const SizedBox(height: 24),
              Text(
                isMatched
                    ? 'Face verified successfully'
                    : 'Face verification failed',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF101922),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isMatched
                    ? 'Your identity has been confirmed. You can now mark your attendance.'
                    : 'We couldn\'t match your face with the registered data. Please try again in a well-lit area.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 48),
              if (isMatched)
                Obx(() => ElevatedButton(
                      onPressed: isSaving.value
                          ? null
                          : () async {
                              isSaving.value = true;
                              try {
                                final repo = StudentRepository();
                                final markController =
                                    Get.find<MarkAttendanceController>();

                                await repo.markAttendanceRecord(
                                  courseId: courseId ?? '',
                                  sessionId: sessionId ?? '',
                                  latitude: markController
                                          .currentPosition.value?.latitude ??
                                      0,
                                  longitude: markController
                                          .currentPosition.value?.longitude ??
                                      0,
                                );

                                Get.toNamed(Routes.ATTENDANCE_SUCCESS);
                              } catch (e) {
                                Get.snackbar(
                                    'Error', 'Failed to mark attendance: $e');
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
                      ),
                      child: isSaving.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Mark Attendance',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                    ))
              else
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Retry Verification',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              const SizedBox(height: 16),
              if (!isMatched)
                TextButton(
                  onPressed: () => Get.offAllNamed(Routes.DASHBOARD),
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.grey)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
