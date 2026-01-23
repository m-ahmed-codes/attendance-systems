import 'package:get/get.dart';
import 'package:uni_attend/src/app/data/repositories/student_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceController extends GetxController {
  final StudentRepository _repository = StudentRepository();

  final selectedDate = DateTime.now().obs;
  final isLoading = false.obs;

  final classSchedules = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSchedule(selectedDate.value);
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
    fetchSchedule(date);
  }

  Future<void> fetchSchedule(DateTime date) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    isLoading.value = true;
    try {
      final rawSchedule = await _repository.getScheduleForDate(date);

      final formattedSchedule = rawSchedule.map((session) {
        final course = session['courses'] as Map<String, dynamic>? ?? {};
        final teacher = course['teachers'] as Map<String, dynamic>? ?? {};

        // Format time: "08:30:00" -> "08:30 AM"
        String formatTime(String? time) {
          if (time == null) return '--';
          final parts = time.split(':');
          if (parts.length >= 2) {
            final sod = Duration(
                hours: int.parse(parts[0]), minutes: int.parse(parts[1]));
            // Simple AM/PM conversion
            final hour = sod.inHours;
            final minute = sod.inMinutes % 60;
            final period = hour >= 12 ? 'PM' : 'AM';
            final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
            final minStr = minute.toString().padLeft(2, '0');
            return '$hour12:$minStr $period';
          }
          return time;
        }

        final start = formatTime(session['start_time']);
        final end = formatTime(session['end_time']);
        final type = 'Lecture'; // Default

        // Color Logic (Simple cycling or hashing)
        final colors = [
          {
            'color': 0xFF00C853,
            'tag': 0xFFE0F7FA,
            'text': 0xFF0277BD
          }, // Green/Blue
          {
            'color': 0xFFAA00FF,
            'tag': 0xFFF3E5F5,
            'text': 0xFF9C27B0
          }, // Purple
          {'color': 0xFF2962FF, 'tag': 0xFFE3F2FD, 'text': 0xFF1565C0}, // Blue
        ];
        final code = course['course_code'] ?? '';
        final colorSet = colors[code.length % colors.length];

        return {
          'time': start,
          'endTime': end,
          'subject': course['course_name'] ?? '--',
          'code': code,
          'type': type,
          'room': session['room'] ?? '--',
          'professor': teacher['full_name'] ?? '--',
          'color': colorSet['color'],
          'tagColor': colorSet['tag'],
          'tagTextColor': colorSet['text'],
          'raw_time': session['start_time'] ?? '00:00:00', // For sorting
        };
      }).toList();

      // Explicitly sort by raw time string ("09:00:00" < "10:00:00")
      formattedSchedule.sort((a, b) {
        return (a['raw_time'] as String).compareTo(b['raw_time'] as String);
      });

      classSchedules.assignAll(formattedSchedule);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load schedule: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
