import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_attend/src/app/Screens/attendance/controllers/attendance_controller.dart';
import 'package:uni_attend/src/app/Screens/attendance/views/widgets/calendar_strip.dart';
import 'package:uni_attend/src/app/Screens/attendance/views/widgets/timeline_item.dart';

class AttendanceView extends GetView<AttendanceController> {
  const AttendanceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AttendanceController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Class Schedule',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF101922),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_active,
                        color: Colors.black87, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Calendar Strip
              Obx(() => CalendarStrip(
                    selectedDate: controller.selectedDate.value,
                    onDateSelected: controller.selectDate,
                  )),

              const SizedBox(height: 32),

              Obx(() {
                // Format selected date
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
                  'January',
                  'February',
                  'March',
                  'April',
                  'May',
                  'June',
                  'July',
                  'August',
                  'September',
                  'October',
                  'November',
                  'December'
                ];
                final dateString =
                    '${dayNames[date.weekday - 1]}, ${monthNames[date.month - 1]} ${date.day}';

                return Text(
                  dateString,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF101922),
                  ),
                );
              }),
              const SizedBox(height: 24),

              // Timeline List
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.classSchedules.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Icon(Icons.event_busy,
                            size: 60, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'No classes scheduled',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.classSchedules.length,
                  itemBuilder: (context, index) {
                    final item = controller.classSchedules[index];
                    return TimelineItem(
                      time: item['time'],
                      endTime: item['endTime'],
                      subject: item['subject'],
                      code: item['code'],
                      type: item['type'],
                      room: item['room'],
                      professor: item['professor'],
                      color: item['color'],
                      tagColor: item['tagColor'],
                      tagTextColor: item['tagTextColor'],
                      isLast: index == controller.classSchedules.length - 1,
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
