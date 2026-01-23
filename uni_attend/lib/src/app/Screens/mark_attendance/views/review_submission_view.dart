import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_attend/src/app/Screens/mark_attendance/controllers/mark_attendance_controller.dart';

class ReviewSubmissionView extends GetView<MarkAttendanceController> {
  const ReviewSubmissionView({Key? key}) : super(key: key);

  // Helper method for info rows
  Widget _buildInfoRow(String label, String value, {bool isRight = false}) {
    return Column(
      crossAxisAlignment:
          isRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF101922),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Review Submission',
          style: TextStyle(
            color: Color(0xFF101922),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Captured Photo Card with Verified Badge
              Container(
                height: 320,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      image: AssetImage(
                          'assets/images/captured_face_placeholder.png'), // Need mock
                      fit: BoxFit.cover,
                    ),
                    color: Colors.grey[300], // Fallback
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ]),
                child: Stack(
                  children: [
                    // Gradient Overlay at bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(20)),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.transparent
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                    // Text Content
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.check_circle,
                                  color: Color(0xFF00AA6C), size: 18),
                              const SizedBox(width: 6),
                              Text(
                                'VERIFIED',
                                style: TextStyle(
                                  color:
                                      const Color(0xFF00AA6C).withOpacity(0.9),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 1,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 6),
                          Obx(() => Text(
                                'Captured at ${controller.captureTime.value}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Location Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Location Details',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF101922),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Text(
                          controller.locationName.value,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        )),
                    const SizedBox(height: 12),
                    // Mini Map Placeholder
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Center(
                        child: Icon(Icons.location_on,
                            color: const Color(0xFF137fec).withOpacity(0.5),
                            size: 30),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Course Details Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoRow('Course', '',
                            isRight:
                                false), // Label only? No, screenshot has label left, value right for top row
                        // Wait, Screenshot 1:
                        // Row 1: Course (Left) ....... CS101\nIntro to Algs (Right)
                        // Row 2: Date (Left) ......... Oct 24, 2023 (Right)
                        // Row 3: Session Type (Left).. Lecture (Right)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Course',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('CS101',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13)), // Hardcoded?
                            Text('Intro to Algorithms',
                                style: TextStyle(
                                    fontSize: 11, color: Colors.grey[500])),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, thickness: 0.5),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoRow('Date', 'Oct 24, 2023'),
                        // No time here? Screenshot shows Date on Left, Value Right.
                        // Wait, screenshot shows:
                        // Date             Oct 24, 2023
                        // Session Type       Lecture
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, thickness: 0.5),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Session Type',
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500)),
                        Row(
                          children: const [
                            Icon(Icons.school,
                                size: 14, color: Color(0xFF137fec)),
                            SizedBox(width: 6),
                            Text('Lecture',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Actions
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.submitAttendance,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF137fec),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Confirm & Submit',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: controller.retakePhoto,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Retake Photo'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF101922),
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
