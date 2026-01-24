import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:uni_attend/src/app/routes/app_routes.dart';

class FaceRegistrationController extends GetxController {
  CameraController? cameraController;
  final RxBool isInitialized = false.obs;
  final RxString guidanceMessage = 'Align your face within the frame'.obs;
  final RxBool canCapture = false.obs;
  final RxBool isProcessing = false.obs;

  // Verification mode
  bool isVerification = false;
  List<dynamic>? storedEmbedding;
  String? courseId;
  String? sessionId;

  late FaceDetector _faceDetector;
  bool _isDetecting = false;

  @override
  void onInit() {
    super.onInit();

    // Handle arguments for verification
    if (Get.arguments != null) {
      isVerification = Get.arguments['isVerification'] ?? false;
      storedEmbedding = Get.arguments['storedEmbedding'];
      courseId = Get.arguments['course_id'];
      sessionId = Get.arguments['session_id'];
    }

    _initializeCamera();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableLandmarks: true,
        enableClassification: true,
        performanceMode: FaceDetectorMode.accurate,
      ),
    );
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      Get.snackbar('Error', 'No camera found');
      return;
    }

    // Use front camera
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    cameraController = CameraController(
      frontCamera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.nv21, // Better for Android ML Kit
    );

    try {
      await cameraController!.initialize();
      isInitialized.value = true;
      _startImageStream();
    } catch (e) {
      Get.snackbar('Error', 'Camera initialization failed: $e');
    }
  }

  void _startImageStream() {
    cameraController?.startImageStream((CameraImage image) {
      if (_isDetecting) return;
      _isDetecting = true;
      _processImage(image);
    });
  }

  Future<void> _processImage(CameraImage image) async {
    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) {
      _isDetecting = false;
      return;
    }

    try {
      final faces = await _faceDetector.processImage(inputImage);
      _handleFaceDetection(faces, image.width, image.height);
    } catch (e) {
      print('Face detection error: $e');
    } finally {
      _isDetecting = false;
    }
  }

  void _handleFaceDetection(List<Face> faces, int width, int height) {
    if (faces.isEmpty) {
      guidanceMessage.value = 'No face detected. Center your face.';
      canCapture.value = false;
      return;
    }

    if (faces.length > 1) {
      guidanceMessage.value =
          'Multiple faces detected. Ensure only you are in frame.';
      canCapture.value = false;
      return;
    }

    final face = faces.first;
    final boundingBox = face.boundingBox;

    // Simple guidance logic based on bounding box size and position
    // These thresholds are approximate and would need tuning
    final relativeWidth = boundingBox.width / width;

    if (relativeWidth < 0.25) {
      guidanceMessage.value = 'Move closer to the camera';
      canCapture.value = false;
    } else if (relativeWidth > 0.6) {
      guidanceMessage.value = 'Move farther from the camera';
      canCapture.value = false;
    } else {
      // Check centering (approximate) - Relaxed to 20%-80%
      final centerX = boundingBox.center.dx;
      if (centerX < width * 0.2 || centerX > width * 0.8) {
        guidanceMessage.value = 'Center your face in the frame';
        canCapture.value = false;
      } else {
        guidanceMessage.value = 'Face Aligned. Perfect!';
        canCapture.value = true;
        // In a real app, we might automatically trigger capture after a few seconds of stability
      }
    }
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    try {
      final sensorOrientation = cameraController!.description.sensorOrientation;

      InputImageRotation? rotation;
      if (sensorOrientation == 90) rotation = InputImageRotation.rotation90deg;
      if (sensorOrientation == 180)
        rotation = InputImageRotation.rotation180deg;
      if (sensorOrientation == 270)
        rotation = InputImageRotation.rotation270deg;
      rotation ??= InputImageRotation.rotation0deg;

      final format = InputImageFormatValue.fromRawValue(image.format.raw);
      if (format == null) return null;

      final bytes = WriteBuffer();
      for (final plane in image.planes) {
        bytes.putUint8List(plane.bytes);
      }

      return InputImage.fromBytes(
        bytes: bytes.done().buffer.asUint8List(),
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: InputImageFormat
              .nv21, // Note: Android usually uses nv21 with Camera2
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );
    } catch (e) {
      print('Error converting image: $e');
      return null;
    }
  }

  void captureAndProcess() async {
    if (!canCapture.value || isProcessing.value) return;

    isProcessing.value = true;
    guidanceMessage.value = 'Processing face...';

    // 1. Stop stream to avoid multiple triggers
    await cameraController?.stopImageStream();

    // 2. Here we would normally run the TFLite model on the cropped face area
    // For this implementation, we simulate embedding generation
    await Future.delayed(const Duration(seconds: 2));

    // Mock embedding (feature vector)
    final mockEmbedding = List.generate(128, (index) => (index / 100.0));

    isProcessing.value = false;

    if (isVerification && storedEmbedding != null) {
      // 3. Compare embeddings
      double distance = _calculateEuclideanDistance(
        mockEmbedding,
        storedEmbedding!.map((e) => (e as num).toDouble()).toList(),
      );

      print('Distance: $distance');

      // Strict threshold (e.g. 0.6 to 1.0 depending on model)
      // For mock, we'll assume a good match if distance is small
      bool isMatched = distance < 1.0;

      Get.toNamed(Routes.ATTENDANCE_SUCCESS, arguments: {
        'isVerificationResult': true,
        'isMatched': isMatched,
        'embedding': mockEmbedding,
        'course_id': courseId,
        'session_id': sessionId,
      });
    } else {
      // 3. Navigate to success screen for registration
      Get.toNamed(Routes.FACE_REGISTRATION_SUCCESS, arguments: {
        'embedding': mockEmbedding,
      });
    }
  }

  double _calculateEuclideanDistance(List<double> v1, List<double> v2) {
    double sum = 0;
    for (int i = 0; i < v1.length; i++) {
      sum += (v1[i] - v2[i]) * (v1[i] - v2[i]);
    }
    return sum; // Standard Euclidean distance squared or sqrt
    // actually sqrt(sum) is standard.
  }

  @override
  void onClose() {
    cameraController?.dispose();
    _faceDetector.close();
    super.onClose();
  }
}
