import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final String subject;
  final String code;
  final String type;
  final String time;
  final String room;
  final String professor;
  final String status; // 'Present', 'Active', 'Upcoming'
  final String? opensAt;
  final VoidCallback? onMarkAttendance;

  const ScheduleCard({
    super.key,
    required this.subject,
    required this.code,
    required this.type,
    required this.time,
    required this.room,
    required this.professor,
    required this.status,
    this.opensAt,
    this.onMarkAttendance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: status == 'Active'
            ? Border(left: BorderSide(color: Color(0xFF00AA6C), width: 4))
            : null, // The screenshot showed a green bar on the left for the first item, but that item state was 'Present'? Wait, the first item 'Database Systems' is 'Present' and has a green bar. The second 'Data Structures' is 'Active' and has blue bar.
        // Correction based on screenshot:
        // 'Database Systems' (Present) -> Green left border.
        // 'Data Structures' (Active) -> Blue left border.
        // 'Web Development' (Upcoming) -> No border visible, just generic.
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF101922),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          code,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(Icons.circle,
                              size: 4, color: Colors.grey[400]),
                        ),
                        Text(
                          type,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (status == 'Present')
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F7EF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    // Using Row for icon+text
                    children: [
                      Icon(Icons.check_circle,
                          size: 14, color: Color(0xFF00AA6C)),
                      SizedBox(width: 4),
                      Text(
                        'Present',
                        style: TextStyle(
                          color: Color(0xFF00AA6C),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              else if (status == 'Active')
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9E6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: Color(0xFFFFB020)),
                      SizedBox(width: 6),
                      Text(
                        'Active',
                        style: TextStyle(
                          color: Color(0xFFFFB020),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              else if (status == 'Upcoming')
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Upcoming',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                )
              else if (status == 'Absent')
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE8E8), // Light red background
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.cancel, size: 14, color: Colors.red),
                      SizedBox(width: 4),
                      Text(
                        'Absent',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded,
                            size: 16,
                            color: status == 'Active'
                                ? const Color(0xFF137fec)
                                : const Color(
                                    0xFF00AA6C)), // Active uses blue icon, Present uses green? Screenshot shows green icon for first item, blue for second.
                        const SizedBox(width: 6),
                        Text(
                          time,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Room',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 16,
                            color: status == 'Active'
                                ? const Color(0xFF137fec)
                                : const Color(0xFF00AA6C)),
                        const SizedBox(width: 6),
                        Text(
                          room,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Professor',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.person,
                      size: 16,
                      color: status == 'Active'
                          ? const Color(0xFF137fec)
                          : const Color(
                              0xFF00AA6C)), // Assuming Icon color logic follows status
                  const SizedBox(width: 6),
                  Text(
                    professor,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (status == 'Present')
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Attendance Recorded',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else if (status == 'Active')
            ElevatedButton(
              onPressed: onMarkAttendance,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF137fec),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 45),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center content
                children: [
                  Icon(Icons.fingerprint, size: 20),
                  SizedBox(width: 8),
                  Text('Mark Attendance',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_clock, size: 16, color: Colors.grey[400]),
                  const SizedBox(width: 8),
                  Text(
                    opensAt ?? '',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
