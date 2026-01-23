import 'package:get/get.dart';
import 'package:uni_attend/src/app/data/repositories/teacher_repository.dart';

class TeacherDashboardController extends GetxController {
  final TeacherRepository _repository = TeacherRepository();

  final RxInt selectedIndex = 0.obs;
  final RxString teacherName = '--'.obs;
  final RxString teacherDept = '--'.obs;
  final RxString teacherId = '--'.obs;
  final RxString teacherEmail = '--'.obs;

  final Rx<Map<String, dynamic>?> selectedCourseForAttendance =
      Rx<Map<String, dynamic>?>(null);

  final selectedDate = DateTime.now().obs;
  final isLoading = false.obs;
  final classes = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
    fetchSchedule(selectedDate.value);
  }

  void changeTabIndex(int index) {
    if (index == 1) {
      selectedCourseForAttendance.value = null;
    }
    selectedIndex.value = index;
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
    fetchSchedule(date);
  }

  void navigateToAttendance(Map<String, dynamic> course) {
    selectedCourseForAttendance.value = course;
    selectedIndex.value = 1;
  }

  Future<void> fetchProfile() async {
    try {
      final profile = await _repository.getTeacherProfile();
      print("profile: ${profile}");
      if (profile != null) {
        teacherName.value = profile['full_name'] ?? '--';
        teacherDept.value = profile['department'] ?? '--';
        teacherId.value = profile['employee_id'] ?? '--';
        teacherEmail.value = profile['email'] ?? '--';
      }
    } catch (e) {
      print('Error loading teacher profile: $e');
    }
  }

  void logout() async {
    await _repository
        .logout(); // I'll add this to repository or call supabase directly
    Get.offAllNamed('/login');
  }

  Future<void> fetchSchedule(DateTime date) async {
    isLoading.value = true;
    try {
      final rawSchedule = await _repository.getScheduleForDate(date);
      final now = DateTime.now();

      final formattedSchedule = rawSchedule.map((session) {
        final course = session['courses'] as Map<String, dynamic>? ?? {};
        print("course fetchSchedule teacher dashboard: $course");

        final startTimeStr = session['start_time'] as String;
        final endTimeStr = session['end_time'] as String;

        // Parse times to DateTime for comparison (using selectedDate for correct day)
        final startParts = startTimeStr.split(':');
        final endParts = endTimeStr.split(':');

        final startDt = DateTime(date.year, date.month, date.day,
            int.parse(startParts[0]), int.parse(startParts[1]));
        final endDt = DateTime(date.year, date.month, date.day,
            int.parse(endParts[0]), int.parse(endParts[1]));

        String status;
        String actionText = '';
        bool isButtonDisabled = false;

        if (now.isAfter(endDt)) {
          status = 'Completed';
          actionText =
              'Manage Attendance'; // Though logic says completed shows both, handled in UI
        } else if (now.isAfter(startDt) && now.isBefore(endDt)) {
          status = 'Live Now';
          actionText = 'Manage Attendance';
        } else {
          status = 'Upcoming';
          isButtonDisabled = true;

          final diff = startDt.difference(now);
          if (diff.inMinutes < 60) {
            actionText = 'Starts in ${diff.inMinutes} min';
          } else {
            // Format 09:00 AM
            final h = int.parse(startParts[0]);
            final m = int.parse(startParts[1]);
            final period = h >= 12 ? 'PM' : 'AM';
            final h12 = h > 12 ? h - 12 : (h == 0 ? 12 : h);
            actionText =
                'Opens at $h12:${m.toString().padLeft(2, '0')} $period';
          }
        }

        // Format display times
        String formatTime(String t) {
          final p = t.split(':');
          final h = int.parse(p[0]);
          final m = int.parse(p[1]);
          final per = h >= 12 ? 'PM' : 'AM';
          final h12 = h > 12 ? h - 12 : (h == 0 ? 12 : h);
          return '$h12:${m.toString().padLeft(2, '0')} $per';
        }

        return {
          'id': session['id'],
          'course_id': session[
              'course_id'], // course['id'], // Added  session['course_id']
          'session_date': session['session_date'], // Added
          'subject': course['course_name'] ?? '--',
          'code': course['course_code'] ?? '--',
          'time': '${formatTime(startTimeStr)} - ${formatTime(endTimeStr)}',
          'start_time': startTimeStr, // For sorting if needed
          'room': session['room'] ?? '--',
          'attendance':
              '0/0', // Placeholder, needs aggregation query count if possible
          'status': status,
          'action_text': actionText,
          'is_disabled': isButtonDisabled
        };
      }).toList();

      classes.assignAll(formattedSchedule);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load schedule: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
