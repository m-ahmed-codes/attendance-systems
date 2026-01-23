import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_attend/src/app/Screens/teacherflow/controllers/teacher_dashboard_controller.dart';
import 'package:uni_attend/src/app/Screens/teacherflow/views/attendance_management_view.dart';
import 'package:uni_attend/src/app/Screens/teacherflow/views/attendance_placeholder_view.dart';
import 'package:uni_attend/src/app/Screens/teacherflow/views/teacher_home_view.dart';
import 'package:uni_attend/src/app/Screens/teacherflow/views/teacher_profile_view.dart';

class TeacherDashboardView extends GetView<TeacherDashboardController> {
  const TeacherDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure controller is ready
    if (!Get.isRegistered<TeacherDashboardController>()) {
      Get.put(TeacherDashboardController());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Obx(() => IndexedStack(
            index: controller.selectedIndex.value,
            children: [
              TeacherHomeView(),
              // Conditional Rendering for Attendance Tab
              controller.selectedCourseForAttendance.value != null
                  ? const AttendanceManagementView()
                  : const AttendancePlaceholderView(),
              TeacherProfileView(),
            ],
          )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changeTabIndex,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF137fec),
            unselectedItemColor: Colors.grey[500],
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_rounded),
                label: 'Attendance',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
          )),
    );
  }
}
