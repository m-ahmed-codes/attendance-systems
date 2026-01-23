import 'package:get/get.dart';
import 'package:uni_attend/src/app/data/repositories/teacher_repository.dart';
import 'package:uni_attend/src/app/Screens/teacherflow/controllers/teacher_dashboard_controller.dart';
import 'package:uni_attend/src/app/Screens/teacherflow/widgets/student_attendance_tile.dart';

class AttendanceManagementController extends GetxController {
  final TeacherRepository _repository = TeacherRepository();
  final TeacherDashboardController _dashboardController =
      Get.find<TeacherDashboardController>();

  final RxList<Map<String, dynamic>> students = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt totalCount = 0.obs;
  final RxInt presentCount = 0.obs;
  final RxInt absentCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen for course changes and fetch data automatically
    ever(_dashboardController.selectedCourseForAttendance, (_) {
      fetchStudents();
    });
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    final courseData = _dashboardController.selectedCourseForAttendance.value;
    print("courseData in fetchStudents: $courseData");
    if (courseData == null) return;

    isLoading.value = true;
    try {
      final courseId = courseData['course_id'] ??
          ''; // Need to ensure course_id is passed from dashboard
      print("courseId in fetchStudents: $courseId");
      final sessionId = courseData['id'] ?? '';

      // If courseData doesn't have course_id directly, we might need it from the session table
      // In dashboard controller we mapped course data to many fields.

      final enrollmentList = await _repository.getEnrolledStudents(courseId);
      final attendanceList = await _repository.getSessionAttendance(sessionId);

      final List<Map<String, dynamic>> mappedStudents = [];
      int present = 0;
      int absent = 0;

      for (var enrollment in enrollmentList) {
        final student = enrollment['students'] as Map<String, dynamic>;
        final studentId = student['id'];

        // Find attendance record for this student
        final attendance = attendanceList
            .firstWhereOrNull((a) => a['student_id'] == studentId);

        AttendanceStatus uiStatus;
        if (attendance == null) {
          // No record yet.
          // If class is live -> Pending
          // If class is completed -> Not Marked
          uiStatus = _dashboardController
                      .selectedCourseForAttendance.value?['status'] ==
                  'Completed'
              ? AttendanceStatus.notMarked
              : AttendanceStatus.pending;
        } else {
          final dbStatus = attendance['status'];
          final dbSource = attendance['source'];

          if (dbStatus == 'present') {
            uiStatus = dbSource == 'auto'
                ? AttendanceStatus.markedByStudent
                : AttendanceStatus.markedByTeacher;
            present++;
          } else {
            uiStatus = AttendanceStatus.absent;
            absent++;
          }
        }

        mappedStudents.add({
          'db_id': studentId, // Student UUID
          'name': student['full_name'] ?? 'Unknown Student',
          'id': student['roll_number'] ?? 'N/A',
          'status': uiStatus,
          'time': attendance != null && attendance['marked_at'] != null
              ? _formatMarkedTime(attendance['marked_at'])
              : null,
          'location':
              attendance?['latitude'] != null ? 'Recorded Location' : null,
        });
      }

      students.assignAll(mappedStudents);
      totalCount.value = enrollmentList.length;
      presentCount.value = present;
      absentCount.value = absent;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load students: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String _formatMarkedTime(String isoString) {
    try {
      final dt = DateTime.parse(isoString);
      final h = dt.hour;
      final m = dt.minute;
      final period = h >= 12 ? 'PM' : 'AM';
      final h12 = h > 12 ? h - 12 : (h == 0 ? 12 : h);
      return '$h12:${m.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return '--:--';
    }
  }

  Future<void> _updateAttendance(
      int index, String status, String source) async {
    final student = students[index];
    final courseData = _dashboardController.selectedCourseForAttendance.value;
    if (courseData == null) return;

    try {
      await _repository.updateAttendance(
        sessionId: courseData['id'],
        studentId: student['db_id'],
        courseId: courseData['course_id'],
        date: courseData[
            'session_date'], // We need to ensure session_date is in courseData
        status: status,
        source: source,
      );
      await fetchStudents(); // Refresh data
    } catch (e) {
      Get.snackbar('Error', 'Failed to update attendance: $e');
    }
  }

  void markPresent(int index) =>
      _updateAttendance(index, 'present', 'byteacher');

  void markAbsent(int index) => _updateAttendance(index, 'absent', 'byteacher');

  void overrideAttendance(int index) => markAbsent(index);
}
