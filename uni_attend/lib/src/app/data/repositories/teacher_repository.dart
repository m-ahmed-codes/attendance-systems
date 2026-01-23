import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';

class TeacherRepository {
  final SupabaseClient _supabase;

  TeacherRepository({SupabaseClient? supabaseClient})
      : _supabase = supabaseClient ?? SupabaseService.client;

  /// Fetches the teacher's profile.
  Future<Map<String, dynamic>?> getTeacherProfile() async {
    final userID = _supabase.auth.currentUser;
    if (userID == null) return null;

    try {
      final response = await _supabase
          .from('teachers')
          .select('full_name, department, employee_id')
          .eq('id', userID.id)
          .maybeSingle();

      if (response != null) {
        response['email'] = userID.email;
      }
      // print("response: ${response}");
      return response;
    } catch (e) {
      print("error of teacher profile: ${e}");
      print("Error fetching teacher profile: ${e}");
      rethrow;
    }
  }

  /// Fetches schedule for a specific date
  Future<List<Map<String, dynamic>>> getScheduleForDate(DateTime date) async {
    final teacherId = _supabase.auth.currentUser!.id;
    try {
      final dateStr = date.toIso8601String().split('T')[0]; // YYYY-MM-DD

      final response = await _supabase
          .from('class_sessions')
          .select('''
        id,
        session_date,
        start_time,
        end_time,
        room,
        course_id,

        courses:course_id (
          course_name,
          course_code,   
          teacher_id
        )
      ''')
          .eq('session_date', dateStr)
          .eq('courses.teacher_id', teacherId) // 🔥 KEY FIX
          .order('start_time');

      //   final response = await _supabase
      //       .from('class_sessions')
      //       .select('''
      //   id,
      //   session_date,
      //   start_time,
      //   end_time,
      //   room,
      //   courses:course_id!inner (
      //     course_name,
      //     course_code,
      //     teacher_id
      //   )
      // ''')
      //       .eq('session_date', dateStr)
      //       .eq('courses.teacher_id', teacherId)
      //       .order('start_time');

      // print("response: ${response}");

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Error getTeacherSchedule: ${e}");
      rethrow;
    }
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  /// Fetch all students enrolled in a specific course
  Future<List<Map<String, dynamic>>> getEnrolledStudents(
      String courseId) async {
    print("courseId: $courseId");
    try {
      final response = await _supabase.from('course_enrollments').select('''
            student_id,
            students:student_id (
              id,
              full_name,
              roll_number,
              email
            )
          ''').eq('course_id', courseId);

      print("getEnrolledStudents response: ${response}");

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Error getEnrolledStudents: $e");
      rethrow;
    }
  }

  /// Fetch attendance records for a specific session
  Future<List<Map<String, dynamic>>> getSessionAttendance(
      String sessionId) async {
    try {
      final response = await _supabase.from('attendance').select('''
            id,
            student_id,
            status,
            source,
            marked_at,
            latitude,
            longitude
          ''').eq('session_id', sessionId);

      print("getSessionAttendance response: ${response}");

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Error getSessionAttendance: $e");
      rethrow;
    }
  }

  /// Update or Insert attendance record
  Future<void> updateAttendance({
    required String sessionId,
    required String studentId,
    required String courseId,
    required String date,
    required String status,
    required String source,
  }) async {
    try {
      await _supabase.from('attendance').upsert({
        'session_id': sessionId,
        'student_id': studentId,
        'course_id': courseId,
        'date': date,
        'status': status,
        'source': source,
        'marked_at': DateTime.now().toIso8601String(),
      }, onConflict: 'student_id, course_id, date');
    } catch (e) {
      print("Error updateAttendance: $e");
      rethrow;
    }
  }
}
