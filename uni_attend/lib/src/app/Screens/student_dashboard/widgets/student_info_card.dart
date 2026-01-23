import 'package:flutter/material.dart';

class StudentInfoCard extends StatelessWidget {
  final String name;
  final String rollNo;
  final String department;
  final String imageUrl;

  const StudentInfoCard({
    super.key,
    required this.name,
    required this.rollNo,
    required this.department,
    this.imageUrl =
        'assets/images/profile_placeholder.png', // Generic placeholder
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundImage: AssetImage(imageUrl),
            backgroundColor: Colors.grey[200],
            // Child for fallback if image fails or isn't there yet
            child: const Icon(Icons.person, size: 32, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF101922),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Roll No: $rollNo',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Dept: $department',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.qr_code, color: Color(0xFF137fec), size: 28),
        ],
      ),
    );
  }
}
