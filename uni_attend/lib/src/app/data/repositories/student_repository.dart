import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';

class StudentRepository {
  final SupabaseClient _supabase;

  StudentRepository({SupabaseClient? supabaseClient})
      : _supabase = supabaseClient ?? SupabaseService.client;

  /// Fetches the student's profile including roll number and department.
  Future<Map<String, dynamic>?> getStudentProfile() async {
    final userID = _supabase.auth.currentUser;
    print("User ID: ${userID!.id}");
    try {
      final response = await _supabase
          .from('students')
          .select('full_name, roll_number, department')
          .eq('id', userID.id)
          .maybeSingle();

      if (response != null) {
        // Attach email from Auth User
        response['email'] = userID.email;
        // Phone might not be in DB, so we can leave it or check if user metadata has it
        response['phone'] = userID.phone ?? '--';
      }
      // print("Response: ${response}");
      return response;
    } catch (e) {
      print("Error: ${e}");
      rethrow;
    }
  }

  /// Fetches attendance statistics (percentage and missing alerts).
  /// Note: This is an aggregation. For now we will calculate it from the raw attendance records
  /// or fetch it if there's a view. Given the schema, we count rows.
  Future<Map<String, dynamic>> getAttendanceStats() async {
    final studentId = _supabase.auth.currentUser!.id;
    print("Student ID: ${studentId}");

    try {
      // 1. Get total sessions (past) for courses the student is enrolled in.
      // This is complex in a single query without a view.
      // For MVP, we might just count 'present' vs total records in 'attendance' table
      // assuming records are created for every session.

      // Fetch all attendance records for this student
      final attendanceRecords = await _supabase
          .from('attendance')
          .select('status')
          .eq('student_id', studentId);

      print("Attendance Records: ${attendanceRecords}");

      int totalClasses = attendanceRecords.length;
      int presentClasses = 0;
      int missingClasses = 0;

      for (var record in attendanceRecords) {
        final status = record['status'] as String;
        if (status == 'present' || status == 'late') {
          presentClasses++;
        } else if (status == 'absent') {
          missingClasses++;
        }
      }

      double percentage =
          totalClasses > 0 ? (presentClasses / totalClasses) * 100 : 0.0;

      // Alerts could be simply the number of absences
      return {
        'percentage': percentage,
        'missingAlerts': missingClasses,
      };
    } catch (e) {
      print("Error: ${e}");
      // Return default error values or rethrow
      return {
        'percentage': 0.0,
        'missingAlerts': 0,
      };
    }
  }

  /// Fetches today's schedule for the student.
  /// Joins: course_enrollments -> courses -> class_sessions
  Future<List<Map<String, dynamic>>> getTodaySchedule() async {
    final now = DateTime.now();
    return getScheduleForDate(now);
  }

  /// Fetches schedule for a specific date
  Future<List<Map<String, dynamic>>> getScheduleForDate(DateTime date) async {
    final studentId = _supabase.auth.currentUser!.id;
    try {
      final dateStr = date.toIso8601String().split('T')[0]; // YYYY-MM-DD

      // 1. Get courses student is enrolled in
      final enrollments = await _supabase
          .from('course_enrollments')
          .select('course_id')
          .eq('student_id', studentId);

      if (enrollments.isEmpty) return [];

      final courseIds =
          (enrollments as List).map((e) => e['course_id']).toList();

      // 2. Get sessions for these courses for the specific DATE
      final response = await _supabase
          .from('class_sessions')
          .select('''
            *,
            courses:course_id (
              course_name,
              course_code,
              teachers:teacher_id (full_name)
            ),
            attendance!left (
              status,
              id
            )
          ''')
          .inFilter('course_id', courseIds)
          .eq('session_date', dateStr)
          .eq('attendance.student_id', studentId)
          .order('start_time');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Error getScheduleForDate: ${e}");
      rethrow;
    }
  }
}
