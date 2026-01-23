import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_attend/src/app/components/custom_button.dart';
import 'package:uni_attend/src/app/components/custom_text_field.dart';
import 'package:uni_attend/src/app/components/role_switcher.dart';
import 'package:uni_attend/src/app/Screens/login/controllers/login_controller.dart';
import 'package:uni_attend/src/app/routes/app_routes.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get.put(LoginController());

    LoginController loginController = Get.put(LoginController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder(
        init: loginController,
        builder: (_) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Keeping the header image as it adds to the design,
                      // but ensuring the rest of the UI matches the new clean look.
                      Image.asset(
                        'assets/images/header.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFF137fec),
                            child: const Center(
                              child: Icon(Icons.school,
                                  size: 50, color: Colors.white24),
                            ),
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      const Positioned(
                        bottom: 16,
                        left: 24, // Matched padding with Signup
                        child: Text(
                          'University Portal',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF101922),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Smart Attendance System',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Obx(() => RoleSwitcher(
                            selectedRole: loginController.selectedRole.value,
                            onRoleSelected: loginController.setRole,
                          )),
                      const SizedBox(height: 32),
                      CustomTextField(
                        label: 'University Email',
                        hint: 'john.doe@university.edu',
                        controller: loginController.emailController,
                        suffixIcon: const Icon(Icons.email_outlined,
                            color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      Obx(() => CustomTextField(
                            label: 'Password',
                            hint: '••••••••',
                            controller: loginController.passwordController,
                            obscureText:
                                !loginController.isPasswordVisible.value,
                            suffixIcon: IconButton(
                              icon: Icon(
                                loginController.isPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey[500],
                              ),
                              onPressed:
                                  loginController.togglePasswordVisibility,
                            ),
                          )),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            foregroundColor: const Color(0xFF137fec),
                          ),
                          child: const Text('Forgot Password?',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Obx(() => CustomButton(
                            text: loginController.isLoading.value
                                ? 'Logging In...'
                                : 'Log In',
                            icon: loginController.isLoading.value
                                ? null
                                : Icons.login,
                            onPressed: loginController.isLoading.value
                                ? () {}
                                : () {
                                    loginController.login();
                                  }, // loginController.login(),
                          )),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account? ",
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 15)),
                          GestureDetector(
                            onTap: () => Get.toNamed(Routes.SIGNUP),
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                color: Color(0xFF137fec),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
