import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_attend/src/app/Screens/profile/controllers/face_registration_controller.dart';

class FaceScanView extends GetView<FaceRegistrationController> {
  const FaceScanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<FaceRegistrationController>()) {
      Get.put(FaceRegistrationController());
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Face Scan', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Obx(() {
        if (!controller.isInitialized.value) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.white));
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            // Camera Preview
            Positioned.fill(
              child: AspectRatio(
                aspectRatio: controller.cameraController!.value.aspectRatio,
                child: CameraPreview(controller.cameraController!),
              ),
            ),

            // Face Overlay Ring
            Center(
              child: Container(
                width: 280,
                height: 380,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius:
                      const BorderRadius.all(Radius.elliptical(280, 380)),
                  border: Border.all(
                    color: controller.canCapture.value
                        ? Colors.green
                        : Colors.white.withOpacity(0.5),
                    width: 3,
                  ),
                ),
              ),
            ),

            // Guidance & Processing
            Positioned(
              bottom: 150,
              child: Column(
                children: [
                  if (!controller.isVerification)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'SCAN ${controller.registrationStep.value} OF 3',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                    ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 300),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      controller.guidanceMessage.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Liveness Indicators
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLivenessIndicator(
                          'Blink', controller.hasBlinked.value),
                      const SizedBox(width: 12),
                      _buildLivenessIndicator(
                          'Head Turn', controller.hasMovedHead.value),
                    ],
                  ),
                ],
              ),
            ),

            // Capture Button
            if (controller.canCapture.value && !controller.isProcessing.value)
              Positioned(
                bottom: 40,
                child: GestureDetector(
                  onTap: controller.captureAndProcess,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt,
                          color: Colors.blue, size: 40),
                    ),
                  ),
                ),
              ),

            // Processing Overlay
            if (controller.isProcessing.value)
              Container(
                color: Colors.black.withOpacity(0.6),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 20),
                      Text(
                        'Processing Face Details...',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildLivenessIndicator(String label, bool isDone) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDone
            ? Colors.green.withOpacity(0.2)
            : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDone ? Colors.green : Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.circle_outlined,
            size: 14,
            color: isDone ? Colors.green : Colors.white70,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: isDone ? Colors.green : Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
