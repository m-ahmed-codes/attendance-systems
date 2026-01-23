import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_attend/src/app/Screens/profile/controllers/profile_controller.dart';
import 'package:uni_attend/src/app/Screens/profile/views/widgets/biometric_card.dart';
import 'package:uni_attend/src/app/Screens/profile/views/widgets/profile_action_tile.dart';
import 'package:uni_attend/src/app/Screens/profile/views/widgets/profile_info_tile.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF101922),
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: controller.editProfile,
            child: const Text('Edit',
                style: TextStyle(
                    color: Color(0xFF137fec), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              // Profile Image
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white,
                            width: 4), // Border for separation
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          )
                        ]),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                          'assets/images/profile_placeholder.png'), // Need placeholder
                      backgroundColor:
                          Colors.orangeAccent, // Fallback color from screenshot
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFF137fec),
                        shape: BoxShape.circle,
                      ),
                      child:
                          const Icon(Icons.edit, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Obx(() => Text(
                    controller.studentName.value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF101922),
                    ),
                  )),
              const SizedBox(height: 4),
              Obx(() => Text(
                    'SID: ${controller.studentId.value}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  )),

              const SizedBox(height: 32),

              // Biometric Card
              Obx(() => BiometricCard(
                    isRegistered: controller.isBiometricRegistered.value,
                    onRegister: controller.registerBiometric,
                  )),

              const SizedBox(height: 32),

              // Personal Information
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF101922),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => Column(
                    children: [
                      ProfileInfoTile(
                        label: 'Department',
                        value: controller.department.value,
                        icon: Icons.school, // Screenshot uses graduation cap
                      ),
                      const SizedBox(height: 12),
                      ProfileInfoTile(
                        label: 'Email Address',
                        value: controller.email.value,
                        icon: Icons.email,
                      ),
                      const SizedBox(height: 12),
                      ProfileInfoTile(
                        label: 'Phone Number',
                        value: controller.phone.value,
                        icon: Icons.phone,
                      ),
                    ],
                  )),

              const SizedBox(height: 32),

              // Security Section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Security',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF101922),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ProfileActionTile(
                title: 'Change Password',
                icon: Icons
                    .lock_clock_outlined, // Rounded lock with clock inside or refresh? Screenshot has refresh arrow inside lock.
                onTap: controller.changePassword,
              ),
              const SizedBox(height: 12),
              ProfileActionTile(
                title: 'Log Out',
                icon: Icons.logout, // Exit icon
                onTap: controller.logout,
                isDestructive: true,
              ),

              const SizedBox(height: 32), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}
