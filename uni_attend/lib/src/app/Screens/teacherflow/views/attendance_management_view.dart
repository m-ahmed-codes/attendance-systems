import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_attend/src/app/Screens/teacherflow/controllers/attendance_management_controller.dart';
import 'package:uni_attend/src/app/Screens/teacherflow/controllers/teacher_dashboard_controller.dart';
import 'package:uni_attend/src/app/Screens/teacherflow/widgets/student_attendance_tile.dart';

class AttendanceManagementView extends StatelessWidget {
  const AttendanceManagementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // We can access properties of the selected course from the dashboard controller
    final dashboardController = Get.find<TeacherDashboardController>();
    // Ensure attendance controller is put
    final controller = Get.put(AttendanceManagementController());

    return SafeArea(
      child: Column(
        children: [
          // Custom Header (replaces AppBar)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            color: const Color(0xFFF8FAFC),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Attendance Management',
                        style: TextStyle(
                          color: Color(0xFF101922),
                          fontWeight: FontWeight.bold,
                          fontSize: 18, // Reduced from 20
                        ),
                      ),
                      const SizedBox(height: 4),
                      Obx(() {
                        final course = dashboardController
                                .selectedCourseForAttendance.value ??
                            {};
                        return Text(
                          '${course['code'] ?? 'CS-XXX'} • ${course['subject'] ?? 'Subject'}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      }),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.black),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // KPI Cards
                  Obx(() => Row(
                        children: [
                          _buildKpiCard(
                              'TOTAL',
                              '${controller.totalCount.value}',
                              Colors.white,
                              const Color(0xFF101922)),
                          const SizedBox(width: 12),
                          _buildKpiCard(
                              'PRESENT',
                              '${controller.presentCount.value}',
                              const Color(0xFFE8F5E9),
                              const Color(0xFF2E7D32)),
                          const SizedBox(width: 12),
                          _buildKpiCard(
                              'ABSENT',
                              '${controller.absentCount.value}',
                              const Color(0xFFFFEBEE),
                              const Color(0xFFD32F2F)),
                        ],
                      )),
                  const SizedBox(height: 24),

                  // List
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF137fec),
                          ),
                        );
                      }

                      if (controller.students.isEmpty) {
                        return const Center(
                          child: Text(
                            'No students enrolled in this course.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: controller.students.length,
                        itemBuilder: (context, index) {
                          final student = controller.students[index];
                          return StudentAttendanceTile(
                            name: student['name'],
                            id: student['id'],
                            status: student['status'],
                            time: student['time'],
                            location: student['location'],
                            onMarkPresent: () => controller.markPresent(index),
                            onMarkAbsent: () => controller.markAbsent(index),
                            onOverrideAbsent: () =>
                                controller.overrideAttendance(index),
                          );
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard(String label, String value, Color bg, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!, width: 1),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2))
            ]),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11, // Reduced from 12
                fontWeight: FontWeight.bold,
                color: textColor.withOpacity(0.6),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22, // Reduced from 24
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
