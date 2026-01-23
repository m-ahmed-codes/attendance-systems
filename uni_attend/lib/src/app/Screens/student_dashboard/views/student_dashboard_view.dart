import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_attend/src/app/Screens/attendance/views/attendance_view.dart';
import 'package:uni_attend/src/app/Screens/profile/views/profile_view.dart';
import 'package:uni_attend/src/app/Screens/student_dashboard/controllers/student_dashboard_controller.dart';
import 'package:uni_attend/src/app/Screens/student_dashboard/widgets/schedule_card.dart';
import 'package:uni_attend/src/app/Screens/student_dashboard/widgets/stats_card.dart';
import 'package:uni_attend/src/app/Screens/student_dashboard/widgets/student_info_card.dart';

class StudentDashboardView extends GetView<StudentDashboardController> {
  const StudentDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(StudentDashboardController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Light grey background
      body: Obx(() => IndexedStack(
            index: controller.selectedIndex.value,
            children: [
              _buildDashboardContent(),
              const AttendanceView(),
              const ProfileView(),
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

  Widget _buildDashboardContent() {
    return SafeArea(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                            'Hi, ${controller.studentName.value}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF101922),
                            ),
                          )),
                      const SizedBox(height: 4),
                      Text(
                        '${controller.getFormattedDateTime()}', // Fixed date per screenshot, normally dynamic
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.notifications, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Student Card
              Obx(() => StudentInfoCard(
                    name: controller.fullName.value,
                    rollNo: controller.rollNo.value,
                    department: controller.department.value,
                  )),

              const SizedBox(height: 24),

              // Stats Row
              Row(
                children: [
                  Obx(() => StatsCard(
                        label: 'Attendance',
                        value: '${controller.attendancePercentage.value}%',
                        subtext: 'Overall',
                        icon: Icons.pie_chart, // Or similar circular indicator
                        iconColor: const Color(0xFF137fec),
                      )),
                  const SizedBox(width: 16),
                  Obx(() => StatsCard(
                        label: 'Alerts',
                        value: '${controller.missingAlerts.value}',
                        subtext: 'Missing',
                        icon: Icons.warning_amber_rounded,
                        iconColor: Colors.orange,
                      )),
                ],
              ),

              const SizedBox(height: 32),

              // Schedule Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Today\'s Schedule',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF101922),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to calendar tab
                      controller.changeTabIndex(1);
                    },
                    child: const Text('See Schedule'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Schedule List
              Obx(() {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.scheduleList.length,
                  itemBuilder: (context, index) {
                    final item = controller.scheduleList[index];

                    return ScheduleCard(
                      subject: item['subject'],
                      code: item['code'],
                      type: item['type'],
                      time: item['time'],
                      room: item['room'],
                      professor: item['professor'],
                      status: item['status'],
                      opensAt: item['opensAt'],
                      onMarkAttendance: () => controller.markAttendance(index),
                    );
                  },
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}
