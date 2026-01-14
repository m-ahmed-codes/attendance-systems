import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Column(
              children: [
                Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    color: const Color(0xFF137FEC),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF137FEC).withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Center(
                    child: Icon(
                      Icons.school,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
                  Positioned(
                    bottom: -8,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'UniAttend',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111418),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Secure. Smart. Attendance.'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[500],
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 48.0),
              child: Column(
                children: [
                  SizedBox(
                    width: 200,
                    child: LinearProgressIndicator(
                      value: 0.45,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF137FEC)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Version 1.0.2',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
