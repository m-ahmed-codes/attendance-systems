import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_attend/src/app/Screens/teacherflow/controllers/teacher_dashboard_controller.dart';

class TeacherProfileView extends StatelessWidget {
  const TeacherProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeacherDashboardController>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Profile',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF101922),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Get.snackbar('Info', 'Edit Profile not implemented yet');
                    },
                    child: const Text("Edit"))
              ],
            ),
            const SizedBox(height: 30),

            // Profile Image
            Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1), blurRadius: 10),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/profile_placeholder.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF137fec),
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.edit, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => Text(
                  controller.teacherName.value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF101922),
                  ),
                )),
            const SizedBox(height: 4),
            Obx(() => Text(
                  controller.teacherDept.value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                )),

            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'PERSONAL INFORMATION',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Obx(() => Column(
                    children: [
                      _buildProfileTile(
                          Icons.email,
                          'Email',
                          controller.teacherEmail.value,
                          const Color(0xFF137fec),
                          const Color(0xFFE3F2FD)), // Blue
                      const Divider(height: 1, indent: 56),
                      _buildProfileTile(
                          Icons.business,
                          'Department',
                          controller.teacherDept.value,
                          const Color(0xFF7C4DFF),
                          const Color(0xFFEDE7F6)), // Purple
                      const Divider(height: 1, indent: 56),
                      _buildProfileTile(
                          Icons.badge,
                          'Employee ID',
                          controller.teacherId.value,
                          const Color(0xFFF57F17),
                          const Color(0xFFFFF8E1)), // Orange
                      const Divider(height: 1, indent: 56),
                      _buildProfileTile(
                          Icons.meeting_room,
                          'Office Location',
                          '--', // Currently not in DB
                          const Color(0xFF2E7D32),
                          const Color(0xFFE8F5E9)), // Green
                    ],
                  )),
            ),

            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'SECURITY & SETTINGS',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSettingTile(Icons.lock, 'Change Password',
                      hasArrow: true),
                ],
              ),
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: controller.logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFef4444),
                  elevation: 0,
                  side: BorderSide(color: Colors.grey[200]!),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  'Log Out',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Version 2.4.0 (Build 392)',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(IconData icon, String title, String subtitle,
      Color iconColor, Color bgColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF101922))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title,
      {bool hasArrow = false,
      bool hasSwitch = false,
      bool switchValue = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.grey[700], size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF101922))),
          ),
          if (hasArrow)
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          if (hasSwitch)
            SizedBox(
              height: 24,
              child: Switch(
                value: switchValue,
                onChanged: (v) {},
                activeColor: const Color(0xFF137fec),
              ),
            )
        ],
      ),
    );
  }
}
