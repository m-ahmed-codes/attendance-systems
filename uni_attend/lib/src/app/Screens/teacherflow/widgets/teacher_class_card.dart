import 'package:flutter/material.dart';

class TeacherClassCard extends StatelessWidget {
  final String subject;
  final String code;
  final String time;
  final String room;
  final String attendance; // e.g. "38/40 Students Present"
  final String status; // Completed, Live Now, Upcoming
  final VoidCallback? onManageAttendance;
  final VoidCallback? onViewReport;

  const TeacherClassCard({
    Key? key,
    required this.subject,
    required this.code,
    required this.time,
    required this.room,
    required this.attendance,
    required this.status,
    this.onManageAttendance,
    this.onViewReport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    Color statusBgColor;

    switch (status) {
      case 'Live Now':
        statusColor = const Color(0xFF2E7D32); // Green
        statusBgColor = const Color(0xFFE8F5E9);
        break;
      case 'Upcoming':
        statusColor = const Color(0xFFF57F17); // Orange/Amber
        statusBgColor = const Color(0xFFFFF8E1);
        break;
      case 'Completed':
      default:
        statusColor = Colors.grey[700]!;
        statusBgColor = Colors.grey[200]!;
        break;
    }

    bool isLive = status == 'Live Now';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        border: isLive
            ? Border(left: BorderSide(color: const Color(0xFF137fec), width: 4))
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF101922),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Course ID: $code',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isLive)
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Time',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time_filled,
                              size: 14, color: Color(0xFF57636C)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              time,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF101922),
                                  fontSize: 12), // Slightly reduced font
                              // maxLines: 1,
                              // overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // const SizedBox(width: 70),
                Spacer(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Room',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 14, color: Color(0xFF57636C)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              room,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF101922),
                                  fontSize: 13), // Slightly reduced font
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (status != 'Upcoming') ...[
              const Text('Attendance',
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: isLive ? const Color(0xFF137fec) : Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    attendance,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF101922),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onManageAttendance,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Colors.grey /*Colors.grey[300]*/),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Manage Attendance',
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onViewReport,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF137fec)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'View Report',
                        style: TextStyle(
                            color: Color(0xFF137fec),
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              // Upcoming class specific UI
              const SizedBox(height: 4),
              Text(
                attendance, // using attendance field for "Start Class (Opens ...)" text
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: null, // Disabled for upcoming
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Start Class (Opens 12:55)',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ),
              ),
            ],
            if (isLive) ...[
              const SizedBox(height: 12),
              // Blue CTA for Live class
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onManageAttendance,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF137fec),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit_note, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Manage Attendance',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              //  We need to remove the previous buttons if we add this big one or match exactly.
              //  Screenshot 2 shows "Manage Attendance" and "View Report" as outline buttons for Live class too?
              //  Actually Screenshot 1 (Teacher Flow Dashboard):
              //  - Database Systems (Completed): Manage Attendance (Outline), View Report (Outline)
              //  - Data Structures (Live Now): Manage Attendance (Blue Fill), View Report (Outline)
              //  - Web Dev (Upcoming): Start Class (Grey Fill)

              //  Let's refine the logic in the build method instead of this if block.
            ],
          ],
        ),
      ),
    );
  }
}
