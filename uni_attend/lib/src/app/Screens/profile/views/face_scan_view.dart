import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_attend/src/app/Screens/profile/controllers/face_registration_controller.dart';

class FaceScanView extends GetView<FaceRegistrationController> {
  const FaceScanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(FaceRegistrationController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:
            const Text('Register Face', style: TextStyle(color: Colors.white)),
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
            Transform.scale(
              scale: 1, // Adjust if needed
              child: CameraPreview(controller.cameraController!),
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
                        : Colors.white,
                    width: 3,
                  ),
                ),
              ),
            ),

            // Guidance & Processing
            Positioned(
              bottom: 120,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  controller.guidanceMessage.value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        'Generating Embedding...',
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
}
