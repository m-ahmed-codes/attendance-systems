import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_attend/src/app/components/custom_button.dart';
import 'package:uni_attend/src/app/components/custom_text_field.dart';
import 'package:uni_attend/src/app/components/role_switcher.dart';
import 'package:uni_attend/src/app/Screens/signup/controllers/signup_controller.dart';

class SignupView extends StatelessWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SignupController signupController = Get.put(SignupController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 20, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Create Account',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GetBuilder(
          init: signupController,
          builder: (_) {
            return SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Join the Classroom',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF101922),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Smart attendance tracking starts here.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 32),
                  Obx(() => RoleSwitcher(
                        selectedRole: signupController.selectedRole.value,
                        onRoleSelected: signupController.setRole,
                      )),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'Full Name',
                    hint: 'John Doe',
                    controller: signupController.nameController,
                    suffixIcon: Icon(Icons.person, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  // Only show Roll Number if role is Student
                  Obx(() => signupController.selectedRole.value == 'Student'
                      ? Column(
                          children: [
                            CustomTextField(
                              label: 'Roll Number',
                              hint: 'e.g. 2023-CS-045',
                              controller: signupController.rollNoController,
                              suffixIcon: Icon(Icons.badge_outlined,
                                  color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                          ],
                        )
                      : const SizedBox.shrink()),

                  // Only show Employee ID if role is Teacher
                  Obx(() => signupController.selectedRole.value == 'Teacher'
                      ? Column(
                          children: [
                            CustomTextField(
                              label: 'Employee ID',
                              hint: 'e.g. EMP-2023-001',
                              controller: signupController.employeeIdController,
                              suffixIcon: Icon(Icons.badge_outlined,
                                  color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                          ],
                        )
                      : const SizedBox.shrink()),
                  _buildDepartmentDropdown(signupController),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'University Email',
                    hint: 'john.doe@university.edu',
                    controller: signupController.emailController,
                    suffixIcon: Icon(Icons.email_outlined, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Obx(() => CustomTextField(
                        label: 'Password',
                        hint: '........',
                        controller: signupController.passwordController,
                        obscureText: signupController.isPasswordObscured.value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            signupController.isPasswordObscured.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey[500],
                          ),
                          onPressed: signupController.togglePasswordVisibility,
                        ),
                      )),
                  const SizedBox(height: 8),
                  Text(
                    'Must be at least 8 characters long.',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 40),
                  Obx(() => CustomButton(
                        text: signupController.isLoading.value
                            ? 'Creating Account...'
                            : 'Sign Up',
                        icon: signupController.isLoading.value
                            ? null
                            : Icons.arrow_forward,
                        onPressed: signupController.isLoading.value
                            ? () {}
                            : () => signupController.register(),
                      )),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already a member? ',
                        style: TextStyle(color: Colors.grey[700], fontSize: 15),
                      ),
                      GestureDetector(
                        onTap: () => Get.offNamed(
                            '/login'), // We will define this route later
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            color: Color(0xFF137fec),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            );
          }),
    );
  }

  Widget _buildDepartmentDropdown(SignupController signupController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Department',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF101922),
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => DropdownButtonFormField<String>(
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey[600]),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF137fec)),
                ),
              ),
              value: signupController.selectedDepartment.value,
              hint: const Text('Select Department',
                  style: TextStyle(color: Colors.black)),
              onChanged: signupController.setDepartment,
              items: <String>[
                'Computer Science',
                'Software Engineering',
                'Data Science'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )),
      ],
    );
  }
}
