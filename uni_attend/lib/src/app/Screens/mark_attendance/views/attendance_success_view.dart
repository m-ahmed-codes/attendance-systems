import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_attend/src/app/Screens/mark_attendance/controllers/mark_attendance_controller.dart';
import 'package:uni_attend/src/app/Screens/student_dashboard/controllers/student_dashboard_controller.dart';
import 'package:uni_attend/src/app/data/repositories/student_repository.dart';
import 'package:uni_attend/src/app/routes/app_routes.dart';

class AttendanceSuccessView extends GetView<MarkAttendanceController> {
  const AttendanceSuccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = Get.arguments;
    final bool isVerificationResult = args?['isVerificationResult'] ?? false;
    final bool isMatched = args?['isMatched'] ?? true;
    final String? courseId = args?['course_id'];
    final String? sessionId = args?['session_id'];
    final RxBool isSaving = false.obs;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          isVerificationResult ? 'Face Verification' : 'Attendance Success',
          style: const TextStyle(
            color: Color(0xFF101922),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: isVerificationResult
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Get.back(),
              )
            : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10), // Add top spacing instead of Spacer
                // Success/Failure Icon
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            (isMatched ? const Color(0xFF137fec) : Colors.red)
                                .withOpacity(0.1),
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isMatched ? const Color(0xFF137fec) : Colors.red,
                      ),
                      child: Icon(isMatched ? Icons.check : Icons.close,
                          color: Colors.white, size: 40),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  isMatched
                      ? (isVerificationResult
                          ? 'Face verified\nsuccessfully'
                          : 'Attendance marked\nsuccessfully')
                      : 'Face verification\nfailed',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF101922),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  isMatched
                      ? (isVerificationResult
                          ? 'Your identity is confirmed. Tap below to mark attendance.'
                          : 'Your presence has been recorded.')
                      : 'We couldn\'t verify your identity. Please try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[500],
                  ),
                ),

                const SizedBox(height: 25),

                // Summary Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'COURSE',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.smart_toy,
                                    size: 12, color: Color(0xFF137fec)),
                                SizedBox(width: 4),
                                Text('Auto-marked',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF137fec),
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Obx(() => Text(
                            controller.courseName.value,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF101922)),
                          )),
                      const SizedBox(height: 24),
                      const Divider(height: 1, thickness: 0.5),
                      const SizedBox(height: 24),

                      Obx(
                        () => Row(
                          children: [
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  const Row(children: [
                                    Icon(Icons.calendar_today,
                                        size: 14, color: Colors.grey),
                                    SizedBox(width: 8),
                                    Text('Date',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey))
                                  ]),
                                  const SizedBox(height: 6),
                                  Text(controller.courseDate.value,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                ])),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  const Row(children: [
                                    Icon(Icons.access_time,
                                        size: 14, color: Colors.grey),
                                    SizedBox(width: 8),
                                    Text('Time',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey))
                                  ]),
                                  const SizedBox(height: 6),
                                  Text(controller.courseTime.value,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                ])),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      Obx(() => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(children: [
                                  Icon(Icons.access_time,
                                      size: 14, color: Colors.grey),
                                  SizedBox(width: 8),
                                  Text('Attendance Time',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey))
                                ]),
                                const SizedBox(height: 6),
                                Text(controller.captureTime.value,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                              ])),
                      const SizedBox(height: 24),
                      Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(children: [
                                Icon(Icons.location_on,
                                    size: 14, color: Colors.grey),
                                SizedBox(width: 8),
                                Text('Location',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey))
                              ]),
                              const SizedBox(height: 6),
                              Text(controller.locationName.value,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                            ],
                          )),
                      const SizedBox(height: 24),

                      // Map Placeholder again?
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                            child: Text('300x300',
                                style: TextStyle(color: Colors.grey))),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                    height: 40), // Add bottom spacing instead of Spacer

                // Action Button
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isSaving.value
                            ? null
                            : (isMatched
                                ? (isVerificationResult
                                    ? () async {
                                        isSaving.value = true;
                                        try {
                                          final repo = StudentRepository();
                                          await repo.markAttendanceRecord(
                                            courseId: courseId ?? '',
                                            sessionId: sessionId ?? '',
                                            latitude: controller.currentPosition
                                                    .value?.latitude ??
                                                0,
                                            longitude: controller
                                                    .currentPosition
                                                    .value
                                                    ?.longitude ??
                                                0,
                                          );

                                          // Navigate to same screen but in "final success" mode (isVerificationResult = false)
                                          Get.offNamed(
                                            Routes.DASHBOARD,
                                          );
                                        } catch (e) {
                                          Get.snackbar('Error',
                                              'Failed to mark attendance: $e');
                                        } finally {
                                          isSaving.value = false;
                                        }
                                      }
                                    : controller.finish)
                                : () => Get.back()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isMatched ? const Color(0xFF137fec) : Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: isSaving.value
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                isMatched
                                    ? (isVerificationResult
                                        ? 'Mark Attendance'
                                        : 'Done')
                                    : 'Retry Verification',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                      ),
                    )),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
