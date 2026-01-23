import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uni_attend/src/app/data/repositories/student_repository.dart';
import 'package:uni_attend/src/app/routes/app_routes.dart';

class StudentDashboardController extends GetxController {
  final StudentRepository _repository = StudentRepository();

  final studentName = '--'.obs;
  final fullName = '--'.obs;
  final rollNo = '--'.obs;
  final department = '--'.obs;

  final attendancePercentage = 0.0.obs;
  final missingAlerts = 0.obs;
  final isLoading = false.obs;

  final selectedIndex = 0.obs;

  final scheduleList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  String getFormattedDateTime() {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, MMM d • hh:mm a');
    return formatter.format(now);
  }

  Future<void> fetchDashboardData() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      Get.snackbar('Error', 'User not authenticated');
      return;
    }

    print("User : ${user}");

    isLoading.value = true;
    try {
      // 1. Fetch Profile
      final profile = await _repository.getStudentProfile();

      if (profile != null) {
        fullName.value = profile['full_name'] ?? '--';
        // Extract first name for "Hi, [Name]"
        studentName.value =
            (profile['full_name'] as String?)?.split(' ').first ?? '--';
        rollNo.value = profile['roll_number'] ?? '--';
        department.value = profile['department'] ?? '--';
      }

      // 2. Fetch Stats
      final stats = await _repository.getAttendanceStats();
      print("Stats : ${stats}");
      attendancePercentage.value = (stats['percentage'] as num).toDouble();
      missingAlerts.value = (stats['missingAlerts'] as num).toInt();

      // 3. Fetch Schedule
      final rawSchedule = await _repository.getTodaySchedule();

      final formattedSchedule = rawSchedule.map((session) {
        final course = session['courses'] as Map<String, dynamic>? ?? {};
        final teacher = course['teachers'] as Map<String, dynamic>? ?? {};
        final attendance = session['attendance'] as List<dynamic>?;

        // Format time: "08:30:00" -> "08:30"
        String formatTime(String? time) {
          if (time == null) return '--';
          final parts = time.split(':');
          if (parts.length >= 2) return '${parts[0]}:${parts[1]}';
          return time;
        }

        final start = formatTime(session['start_time']);
        final end = formatTime(session['end_time']);

        // Time Logic
        final now = DateTime.now();
        final dateStr = session['session_date'] as String; // "YYYY-MM-DD"

        // Helper to parse time string "HH:MM:SS"
        DateTime parseDateTime(String date, String time) {
          final parts = time.split(':');
          return DateTime.parse(
              '${date}T${parts[0]}:${parts[1]}:${parts.length > 2 ? parts[2] : '00'}');
        }

        final startDt = parseDateTime(dateStr, session['start_time']);
        final endDt = parseDateTime(dateStr, session['end_time']);

        // Determine Status & Footer Text (opensAt)
        String status = 'Upcoming';
        String footerText = 'Opens at $start';

        if (attendance != null && attendance.isNotEmpty) {
          final statusStr =
              attendance[0]['status']?.toString().capitalizeFirst ?? 'Pending';
          status = (statusStr == 'Present' || statusStr == 'Late')
              ? 'Present'
              : statusStr;
          // If 'Absent', we might show 'Class Finished' or similar in footer if we wanted,
          // but mapped to 'Present' UI logic (green check) vs others.
          // For simplicity using 'Present' for checkmark UI, others fall through.
        } else {
          if (now.isBefore(startDt)) {
            status = 'Upcoming';
            final diff = startDt.difference(now);
            if (diff.inMinutes < 60) {
              footerText = 'Starts in ${diff.inMinutes} min';
            } else {
              footerText = 'Opens at $start';
            }
          } else if (now.isAfter(startDt) && now.isBefore(endDt)) {
            status = 'Active';
            // Active shows generic "Mark Attendance" button in UI
          } else {
            // Time Passed & No Attendance Marked
            status = 'Absent'; // Or 'Missed'
            footerText = 'Class Finished';
          }
        }

        return {
          'subject': course['course_name'] ?? '--',
          'code': course['course_code'] ?? '--',
          'type': 'Lecture',
          'time': '$start - $end',
          'room': session['room'] ?? '--',
          'professor': teacher['full_name'] ?? '--',
          'status': status,
          'opensAt': footerText,
        };
      }).toList();

      scheduleList.assignAll(formattedSchedule);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load dashboard data: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void markAttendance(int index) {
    // Navigate to flow
    // Pass session details or course details if needed
    // For now, keeping original navigation
    Get.toNamed(Routes.ATTENDANCE_CHECKIN);
  }

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
}
