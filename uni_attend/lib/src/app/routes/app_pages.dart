import 'package:get/get.dart';
import 'package:uni_attend/src/app/Screens/login/views/login_view.dart';
import 'package:uni_attend/src/app/Screens/signup/views/signup_view.dart';
import 'package:uni_attend/src/app/Screens/student_dashboard/views/student_dashboard_view.dart';
import 'package:uni_attend/src/app/routes/app_routes.dart';
import 'package:uni_attend/src/app/Screens/splash/views/splash_screen.dart';
import 'package:uni_attend/src/app/Screens/mark_attendance/views/attendance_checkin_view.dart';
import 'package:uni_attend/src/app/Screens/mark_attendance/views/scan_face_view.dart';
import 'package:uni_attend/src/app/Screens/mark_attendance/views/review_submission_view.dart';
import 'package:uni_attend/src/app/Screens/mark_attendance/views/attendance_success_view.dart';
import 'package:uni_attend/src/app/Screens/teacherflow/views/teacher_dashboard_view.dart';
import 'package:uni_attend/src/app/Screens/teacherflow/views/attendance_management_view.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
    ),
    GetPage(
      name: Routes.SIGNUP,
      page: () => const SignupView(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const StudentDashboardView(),
    ),
    GetPage(
        name: Routes.ATTENDANCE_CHECKIN,
        page: () => const AttendanceCheckInView()),
    GetPage(name: Routes.SCAN_FACE, page: () => const ScanFaceView()),
    GetPage(
        name: Routes.REVIEW_SUBMISSION,
        page: () => const ReviewSubmissionView()),
    GetPage(
        name: Routes.ATTENDANCE_SUCCESS,
        page: () => const AttendanceSuccessView()),
    GetPage(
        name: Routes.TEACHER_DASHBOARD,
        page: () => const TeacherDashboardView()),
    GetPage(
        name: Routes.ATTENDANCE_MANAGEMENT,
        page: () => const AttendanceManagementView()),
  ];
}
