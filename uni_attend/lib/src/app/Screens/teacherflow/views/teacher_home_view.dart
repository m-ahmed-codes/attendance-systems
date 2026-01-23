import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_attend/src/app/Screens/teacherflow/controllers/teacher_dashboard_controller.dart';
import 'package:uni_attend/src/app/Screens/teacherflow/widgets/teacher_class_card.dart';
import 'package:uni_attend/src/app/Screens/teacherflow/views/widgets/teacher_calendar_strip.dart';

class TeacherHomeView extends GetView<TeacherDashboardController> {
  const TeacherHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
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
                          'Hi, ${controller.teacherName.value}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF101922),
                          ),
                        )),
                    const SizedBox(height: 4),
                    Obx(() {
                      final date = controller.selectedDate.value;
                      final dayNames = [
                        'Monday',
                        'Tuesday',
                        'Wednesday',
                        'Thursday',
                        'Friday',
                        'Saturday',
                        'Sunday'
                      ];
                      final monthNames = [
                        'Oct',
                        'Nov',
                        'Dec',
                        'Jan',
                        'Feb',
                        'Mar',
                        'Apr',
                        'May',
                        'Jun',
                        'Jul',
                        'Aug',
                        'Sep'
                      ];
                      return Text(
                        '${dayNames[date.weekday - 1]}, ${monthNames[(date.month - 10) % 12]} ${date.day}', // Simple hack or use DateFormat
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.notifications_outlined,
                          color: Colors.black87),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Horizontal Calendar Strip
            Obx(() => TeacherCalendarStrip(
                  selectedDate: controller.selectedDate.value,
                  onDateSelected: controller.selectDate,
                )),

            const SizedBox(height: 24),

            // My Classes Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Classes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF101922),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View Schedule'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Class Lists
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.classes.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Text('No classes scheduled',
                        style: TextStyle(color: Colors.grey[500])),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.classes.length,
                itemBuilder: (context, index) {
                  final item = controller.classes[index];
                  return TeacherClassCard(
                    subject: item['subject'],
                    code: item['code'],
                    time: item['time'],
                    room: item['room'],
                    attendance: item['status'] == 'Upcoming'
                        ? item['action_text']
                        : item['attendance'],
                    status: item['status'],
                    onManageAttendance: () {
                      print("item: $item");
                      controller.navigateToAttendance(item);
                    },
                    onViewReport: () {
                      // View Report Action
                    },
                  );
                },
              );
            }),
            const SizedBox(height: 80), // Bottom padding
          ],
        ),
      ),
    );
  }
}
