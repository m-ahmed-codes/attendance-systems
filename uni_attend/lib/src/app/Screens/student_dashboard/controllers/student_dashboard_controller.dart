import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
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

        final hasAttended = attendance != null && attendance.isNotEmpty;
        final attendanceStatus = hasAttended
            ? attendance[0]['status']?.toString().toLowerCase()
            : null;

        if (hasAttended &&
            (attendanceStatus == 'present' || attendanceStatus == 'late')) {
          status = 'Present';
          footerText = 'Attendance Recorded';
        } else if (now.isBefore(startDt)) {
          status = 'Upcoming';
          final diff = startDt.difference(now);
          if (diff.inMinutes < 60 && diff.inMinutes > 0) {
            footerText = 'Starts in ${diff.inMinutes} min';
          } else {
            footerText = 'Opens at $start';
          }
        } else if (now.isAfter(startDt) && now.isBefore(endDt)) {
          status = 'Active';
          footerText = 'Mark Attendance';
        } else {
          // Time Passed & No Attendance Marked
          status = 'Absent';
          footerText = 'Class Finished';
        }

        return {
          'subject': course['course_name'] ?? '--',
          'code': course['course_code'] ?? '--',
          'type': 'Lecture',
          'time': '$start - $end',
          'start_dt': startDt, // Added for sorting
          'room': session['room'] ?? '--',
          'professor': teacher['full_name'] ?? '--',
          'status': status,
          'opensAt': footerText,
          'session_id': session['id'],
          'course_id': session['course_id'],
        };
      }).toList();

      // Sort by start time
      formattedSchedule.sort((a, b) =>
          (a['start_dt'] as DateTime).compareTo(b['start_dt'] as DateTime));

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

  Future<void> markAttendance(int index) async {
    // 1. Check Location Services
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'Location Required',
        'Please turn on your location services to mark attendance.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // 2. Check Permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'Permission Denied',
          'Location permission is required to verify you are on campus.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Permission Required',
        'Please enable location permissions in settings to proceed.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Navigate to flow with session data
    final session = scheduleList[index];
    Get.toNamed(Routes.ATTENDANCE_CHECKIN, arguments: {
      'course_id':
          session['course_id'], // Ensure course_id is in the session map
      'session_id':
          session['session_id'], // Ensure session_id is in the session map
      'course_name': session['subject'],
      'start_time': session['time'],
      'room': session['room'],
      'type': session['type'],
    });
  }

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
}
