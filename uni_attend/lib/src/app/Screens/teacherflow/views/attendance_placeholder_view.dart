import 'package:flutter/material.dart';

class AttendancePlaceholderView extends StatelessWidget {
  const AttendancePlaceholderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event_note,
                size: 48,
                color: Color(0xFF137fec),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Select a Class",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF101922),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Please click on 'Manage Attendance' for a specific course in the Dashboard to view its student list.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
