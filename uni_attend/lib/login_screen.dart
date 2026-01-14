import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isStudent = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildWelcomeText(),
            const SizedBox(height: 24),
            _buildRoleSwitcher(),
            const SizedBox(height: 24),
            _buildLoginForm(),
            const SizedBox(height: 48),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 180,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/header.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.6),
              Colors.transparent,
            ],
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(16),
        child: const Text(
          'University Portal',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return const Column(
      children: [
        Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111418),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Smart Attendance System',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF637588),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSwitcher() {
    return Container(
      width: 320,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isStudent = true),
              child: Container(
                decoration: BoxDecoration(
                  color: isStudent ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: isStudent
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                          )
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school,
                      size: 18,
                      color: isStudent
                          ? const Color(0xFF111418)
                          : const Color(0xFF637588),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Student',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isStudent
                            ? const Color(0xFF111418)
                            : const Color(0xFF637588),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isStudent = false),
              child: Container(
                decoration: BoxDecoration(
                  color: !isStudent ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: !isStudent
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                          )
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.person,
                      size: 18,
                      color: !isStudent
                          ? Color(0xFF111418)
                          : Color(0xFF637588),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Teacher',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: !isStudent
                            ? const Color(0xFF111418)
                            : const Color(0xFF637588),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isStudent ? 'Roll Number' : 'Email',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF111418),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF0F2F4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(
                Icons.badge,
                color: Color(0xFF637588),
              ),
              hintText: isStudent ? 'e.g. 2023-CS-101' : 'e.g. john.doe@example.com',
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Password',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF111418),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF0F2F4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(
                Icons.lock,
                color: Color(0xFF637588),
              ),
              suffixIcon: const Icon(
                Icons.visibility,
                color: Color(0xFF637588),
              ),
              hintText: '••••••••',
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  color: Color(0xFF137FEC),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF137FEC),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 5,
              shadowColor: const Color(0xFF137FEC).withOpacity(0.2),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Log In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.login,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.face,
                color: Color(0xFF137FEC),
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(
            color: Color(0xFF637588),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Register',
            style: TextStyle(
              color: Color(0xFF137FEC),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
