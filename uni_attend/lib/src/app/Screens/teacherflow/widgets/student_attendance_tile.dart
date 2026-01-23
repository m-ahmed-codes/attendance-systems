import 'package:flutter/material.dart';

enum AttendanceStatus {
  markedByStudent, // Green: "Marked by Student"
  markedByTeacher, // Blue: "Marked by Teacher"
  pending, // Yellow: "Pending" (Live)
  notMarked, // Red: "Not Marked" (Completed)
  absent // Red: "Absent"
}

class StudentAttendanceTile extends StatelessWidget {
  final String name;
  final String id;
  final AttendanceStatus status;
  final String? time; // e.g. "09:42 AM"
  final String? location; // e.g. "Lecture Hall A"
  final VoidCallback? onMarkPresent;
  final VoidCallback? onMarkAbsent;
  final VoidCallback? onOverrideAbsent;

  const StudentAttendanceTile({
    Key? key,
    required this.name,
    required this.id,
    required this.status,
    this.time,
    this.location,
    this.onMarkPresent,
    this.onMarkAbsent,
    this.onOverrideAbsent,
  }) : super(key: key);

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
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: _getBorderColor(),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                    ),
                    child: const Icon(Icons.person, color: Colors.grey),
                  ),
                  if (status == AttendanceStatus.markedByStudent)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00C853), // Green
                          shape: BoxShape.circle,
                          border: Border.fromBorderSide(
                              BorderSide(color: Colors.white, width: 2)),
                        ),
                      ),
                    ),
                  if (status == AttendanceStatus.notMarked)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF5252), // Red
                          shape: BoxShape.circle,
                          border: Border.fromBorderSide(
                              BorderSide(color: Colors.white, width: 2)),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),

              // Name and ID
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 15, // Reduced from 16
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF101922),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      id,
                      style: TextStyle(
                        fontSize: 13, // Reduced from 14
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (status == AttendanceStatus.markedByStudent) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          _buildInfoChip(
                              Icons.access_time_filled,
                              time ?? '--:--',
                              Color(0xFFE8F5E9),
                              Color(0xFF2E7D32)),
                          _buildInfoChip(
                              Icons.location_on,
                              location ?? 'Unknown',
                              Color(0xFFE8F5E9),
                              Color(0xFF2E7D32)),
                        ],
                      ),
                    ] else if (status == AttendanceStatus.pending) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          _buildInfoChip(Icons.access_time_filled, '--:--',
                              Colors.grey[100]!, Colors.grey),
                          _buildInfoChip(
                              Icons.wifi_tethering,
                              'Waiting for student...',
                              Color(0xFFFFF8E1),
                              Color(0xFFF57F17),
                              isTextOnly: true), // Orange-ish
                        ],
                      ),
                    ] else if (status == AttendanceStatus.notMarked) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          _buildInfoChip(Icons.access_time_filled, '--:--',
                              Colors.grey[100]!, Colors.grey),
                          _buildInfoChip(Icons.wifi_off, 'Class Over',
                              Color(0xFFFFEBEE), Color(0xFFE53935),
                              isTextOnly: true), // Red-ish
                        ],
                      ),
                    ]
                  ],
                ),
              ),

              // Right Status Badge
              if (status == AttendanceStatus.markedByStudent ||
                  status == AttendanceStatus.markedByTeacher)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: status == AttendanceStatus.markedByStudent
                        ? const Color(0xFFE0F2F1)
                        : const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: status == AttendanceStatus.markedByStudent
                          ? const Color(0xFFB2DFDB)
                          : const Color(0xFFBBDEFB),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        status == AttendanceStatus.markedByStudent
                            ? Icons.smartphone
                            : Icons.person_add,
                        size: 14,
                        color: status == AttendanceStatus.markedByStudent
                            ? const Color(0xFF00695C)
                            : const Color(0xFF0D47A1),
                      ),
                      const SizedBox(width: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MARKED BY',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: status == AttendanceStatus.markedByStudent
                                  ? const Color(0xFF00695C)
                                  : const Color(0xFF0D47A1),
                            ),
                          ),
                          Text(
                            status == AttendanceStatus.markedByStudent
                                ? 'STUDENT'
                                : 'TEACHER',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: status == AttendanceStatus.markedByStudent
                                  ? const Color(0xFF00695C)
                                  : const Color(0xFF0D47A1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              else if (status == AttendanceStatus.pending)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1), // Light Amber
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFFECB3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.hourglass_empty,
                          size: 14, color: Color(0xFFF57F17)),
                      SizedBox(width: 4),
                      Text(
                        'PENDING',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF57F17),
                        ),
                      ),
                    ],
                  ),
                )
              else if (status == AttendanceStatus.notMarked)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE), // Light Red
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFFCDD2)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline,
                          size: 14, color: Color(0xFFE53935)),
                      SizedBox(width: 4),
                      Text(
                        'NOT MARKED',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE53935),
                        ),
                      ),
                    ],
                  ),
                )
              else if (status == AttendanceStatus.absent)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[300]!),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.cancel, size: 14, color: Colors.red),
                      SizedBox(width: 4),
                      Text(
                        'ABSENT',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
          const SizedBox(height: 16),
          // Action Buttons
          Row(
            children: [
              if (status == AttendanceStatus.markedByStudent ||
                  status == AttendanceStatus.markedByTeacher) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: null, // Disabled as they are present
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: status == AttendanceStatus.markedByStudent
                            ? const Color(0xFF00C853)
                            : Colors.grey,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle,
                            color: status == AttendanceStatus.markedByStudent
                                ? const Color(0xFF00C853)
                                : Colors.grey,
                            size: 16),
                        const SizedBox(width: 8),
                        const Text('Present',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onOverrideAbsent,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.history_edu, color: Colors.red, size: 16),
                        SizedBox(width: 8),
                        Text('Override Absent',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ] else if (status == AttendanceStatus.pending ||
                  status == AttendanceStatus.notMarked ||
                  status == AttendanceStatus.absent) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: onMarkPresent,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF00C853)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.check, color: Color(0xFF00C853), size: 16),
                        SizedBox(width: 8),
                        Text('Mark Present',
                            style: TextStyle(
                                color: Color(0xFF00C853),
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: status == AttendanceStatus.notMarked
                      ? ElevatedButton(
                          onPressed: onMarkAbsent,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFef4444),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.close, color: Colors.white, size: 16),
                              SizedBox(width: 8),
                              Text('Confirm Absent',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      : OutlinedButton(
                          onPressed: onMarkAbsent,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.close, color: Colors.grey, size: 16),
                              SizedBox(width: 8),
                              Text('Marked Absent',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                ),
              ]
            ],
          )
        ],
      ),
    );
  }

  Color _getBorderColor() {
    if (status == AttendanceStatus.markedByStudent)
      return const Color(0xFFE0F2F1); // Light Green
    if (status == AttendanceStatus.markedByTeacher)
      return const Color(0xFFE3F2FD); // Light Blue
    if (status == AttendanceStatus.pending) return Colors.transparent;
    if (status == AttendanceStatus.notMarked)
      return const Color(0xFFFFEBEE); // Light Red
    if (status == AttendanceStatus.absent) return Colors.grey[200]!;
    return Colors.transparent;
  }

  Widget _buildInfoChip(IconData icon, String text, Color bg, Color textColor,
      {bool isTextOnly = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
