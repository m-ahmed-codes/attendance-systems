import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_attend/src/app/Screens/mark_attendance/controllers/mark_attendance_controller.dart';

class ScanFaceView extends GetView<MarkAttendanceController> {
  const ScanFaceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors
                  .black), // Screenshot shows back arrow on white top bar?
          // WAIT, screenshot 2 "Scan Face" has a WHITE Top Bar with "Scan Face" title.
          // BUT the camera preview is below it.
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Scan Face',
          style: TextStyle(
            color: Color(0xFF101922),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Mock Camera Preview (Image or Grey Background)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[900],
            child: Image.asset(
              'assets/images/camera_preview_mock.png', // Ideally mock or just dark placeholder
              fit: BoxFit.cover,
              errorBuilder: (c, o, s) =>
                  Container(color: Colors.grey[800]), // Fallback
            ),
            // Real app would use CameraPreview(controller)
          ),

          // Face Overlay (The Blue Oval)
          Center(
            child: Container(
              width: 250,
              height: 350,
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color(0xFF137fec), width: 2), // Blue outline
                borderRadius: const BorderRadius.all(
                    Radius.elliptical(250, 350)), // Oval shape
                // We want explicit oval.
              ),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.all(Radius.elliptical(250, 350)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 100,
                        spreadRadius: 10,
                      )
                    ]
                    // Attempting to simulate the darkening OUTSIDE the oval is hard with simple containers.
                    // Usually requires ColorFiltered or a CustomPainter with a hole.
                    // For "Pixel Perfect" mock, simpler is just the blue ring.
                    ),
              ),
            ),
          ),

          // Tip Text Overlay
          Positioned(
            bottom: 180,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'Make sure your face is clearly visible.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),

          // Bottom Control Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(bottom: 40, top: 20),
              color: Colors.black.withOpacity(0.3), // Semi-transparent bottom
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Gallery Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle),
                    child: const Icon(Icons.photo_library_outlined,
                        color: Colors.white),
                  ),

                  // Shutter Button
                  GestureDetector(
                    onTap: controller.capturePhoto,
                    child: Container(
                      width: 72,
                      height: 72,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),

                  // Switch Camera Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle),
                    child: const Icon(Icons.cameraswitch_outlined,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
