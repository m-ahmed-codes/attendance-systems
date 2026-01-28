import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:uni_attend/src/app/routes/app_routes.dart';
import 'package:uni_attend/src/core/services/face_detection_service.dart';
import 'package:uni_attend/src/core/services/face_recognition_service.dart';
import 'package:uni_attend/src/core/utils/image_utils.dart';

class FaceRegistrationController extends GetxController {
  // Services
  final FaceDetectionService _detectionService = FaceDetectionService();
  final FaceRecognitionService _recognitionService = FaceRecognitionService();

  // State
  CameraController? cameraController;
  final RxBool isInitialized = false.obs;
  final RxString guidanceMessage = 'Initializing...'.obs;
  final RxBool canCapture = false.obs;
  final RxBool isProcessing = false.obs;

  // Liveness State
  final RxBool hasBlinked = false.obs;
  final RxBool hasMovedHead = false.obs;
  final RxBool livenessVerified = false.obs;

  // Verification mode
  bool isVerification = false;
  Map<String, dynamic>? faceData;
  String? courseId;
  String? sessionId;

  // Real-time processing
  bool _isBusy = false;
  int _consecutiveMatchCount = 0;
  static const int _requiredMatches = 3;

  // Registration data
  final List<List<double>> _capturedEmbeddings = [];
  final int _requiredRegistrationSamples = 3;
  final RxInt registrationStep = 1.obs;

  @override
  void onInit() {
    super.onInit();
    _handleArguments();
    _initFlow();
  }

  Future<void> _initFlow() async {
    guidanceMessage.value = 'Loading AI Model...';
    await _recognitionService.loadModel();
    if (!_recognitionService.isModelLoaded) {
      guidanceMessage.value = 'ERROR: AI Model failed to load';
      Get.snackbar('Model Error',
          'TFLite model not found in assets. Registration will not work.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 10));
    }
    await _initializeCamera();
  }

  void _handleArguments() {
    if (Get.arguments != null) {
      isVerification = Get.arguments['isVerification'] ?? false;
      faceData = Get.arguments['faceData'] ??
          (Get.arguments['storedEmbedding'] != null
              ? {
                  'embeddings': [Get.arguments['storedEmbedding']]
                }
              : null);
      courseId = Get.arguments['course_id'];
      sessionId = Get.arguments['session_id'];
      print(
          'DEBUG: App started in ${isVerification ? "VERIFICATION" : "REGISTRATION"} mode');
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      guidanceMessage.value = 'No camera found';
      return;
    }

    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.nv21,
    );

    try {
      await cameraController!.initialize();
      isInitialized.value = true;
      guidanceMessage.value = 'Align your face';
      _startImageStream();
    } catch (e) {
      print('ERROR: Camera init failed: $e');
      guidanceMessage.value = 'Camera error';
    }
  }

  void _startImageStream() {
    cameraController?.startImageStream((CameraImage image) {
      if (_isBusy || isProcessing.value) return;
      _isBusy = true;
      _processCameraImage(image);
    });
  }

  Future<void> _processCameraImage(CameraImage image) async {
    try {
      final inputImage = _convertCameraImageToInputImage(image);
      if (inputImage == null) return;

      final faces = await _detectionService.detectFaces(inputImage);

      if (faces.isEmpty) {
        guidanceMessage.value = 'No face detected. Center your face.';
        canCapture.value = false;
        _consecutiveMatchCount = 0;
        return;
      }

      if (faces.length > 1) {
        guidanceMessage.value = 'Too many faces! Stay alone in frame.';
        canCapture.value = false;
        return;
      }

      final face = faces.first;

      // 1. Check Alignment
      if (!_isFaceAligned(face, image.width, image.height)) {
        canCapture.value = false;
        return;
      }

      // 2. Liveness Detection
      _checkLiveness(face);

      if (!livenessVerified.value) {
        guidanceMessage.value =
            'PROVE LIVENESS: Blink your eyes or turn your head';
        canCapture.value = false;
        return;
      }

      if (isVerification) {
        guidanceMessage.value = 'Face Matched! Hold still...';
      } else {
        guidanceMessage.value =
            'Ready for Scan ${registrationStep.value}/$_requiredRegistrationSamples';
      }
      canCapture.value = true;

      // 3. Auto-Verification Flow
      if (isVerification && faceData != null) {
        await _handleAutoVerification(image, face);
      }
    } catch (e) {
      print('ERROR: Stream processing failed: $e');
    } finally {
      _isBusy = false;
    }
  }

  bool _isFaceAligned(Face face, int width, int height) {
    final boundingBox = face.boundingBox;
    final relativeWidth = boundingBox.width / width;

    if (relativeWidth < 0.3) {
      guidanceMessage.value = 'Move closer to the camera';
      return false;
    }
    if (relativeWidth > 0.7) {
      guidanceMessage.value = 'Move farther away';
      return false;
    }

    final centerX = boundingBox.center.dx;
    if (centerX < width * 0.2 || centerX > width * 0.8) {
      guidanceMessage.value = 'Center your face in the oval';
      return false;
    }

    return true;
  }

  void _checkLiveness(Face face) {
    if (livenessVerified.value) return;

    // Eye Blink
    if (face.leftEyeOpenProbability != null &&
        face.rightEyeOpenProbability != null) {
      if (face.leftEyeOpenProbability! < 0.2 &&
          face.rightEyeOpenProbability! < 0.2) {
        print('DEBUG: Blink detected!');
        hasBlinked.value = true;
      }
    }

    // Head Movement
    if (face.headEulerAngleY != null) {
      if (face.headEulerAngleY!.abs() > 15) {
        print('DEBUG: Head movement detected (${face.headEulerAngleY})');
        hasMovedHead.value = true;
      }
    }

    if (hasBlinked.value || hasMovedHead.value) {
      livenessVerified.value = true;
      print('DEBUG: Liveness Verified');
    }
  }

  Future<void> _handleAutoVerification(CameraImage image, Face face) async {
    if (!livenessVerified.value || !_recognitionService.isModelLoaded) return;

    final img.Image converted = ImageUtils.convertCameraImage(image);
    final img.Image faceCrop = ImageUtils.cropFace(converted, face);
    final List<double> currentEmbedding =
        _recognitionService.generateEmbedding(faceCrop);

    if (currentEmbedding.isEmpty) return;

    final storedEmbeddings = (faceData!['embeddings'] as List)
        .map((e) => (e as List).map((v) => (v as num).toDouble()).toList())
        .toList();

    bool isMatched = false;
    double bestSimilarity = -1.0;

    for (var stored in storedEmbeddings) {
      double similarity =
          _recognitionService.compareEmbeddings(currentEmbedding, stored);
      if (similarity > bestSimilarity) bestSimilarity = similarity;
      if (similarity >= FaceRecognitionService.threshold) {
        isMatched = true;
        break;
      }
    }

    print(
        'DEBUG: Verification Similarity: $bestSimilarity (Threshold: ${FaceRecognitionService.threshold})');

    if (isMatched) {
      _consecutiveMatchCount++;
      if (_consecutiveMatchCount >= _requiredMatches) {
        print(
            'DEBUG: Auto-Verification Success! Matched $_requiredMatches consecutive frames.');
        isProcessing.value = true;
        await cameraController?.stopImageStream();

        Get.toNamed(Routes.ATTENDANCE_SUCCESS, arguments: {
          'isVerificationResult': true,
          'isMatched': true,
          'embedding': currentEmbedding,
          'course_id': courseId,
          'session_id': sessionId,
        });
      }
    } else {
      _consecutiveMatchCount = 0;
    }
  }

  void captureAndProcess() async {
    if (!canCapture.value || isProcessing.value) return;
    if (!_recognitionService.isModelLoaded) {
      Get.snackbar('Error', 'AI Model not loaded. Please restart the app.');
      return;
    }

    print('--- STARTING FACE CAPTURE ---');
    isProcessing.value = true;
    guidanceMessage.value = 'Processing...';

    try {
      final imageFile = await cameraController?.takePicture();
      if (imageFile == null) throw Exception('Failed to take picture');

      final bytes = await imageFile.readAsBytes();
      final img.Image? decoded = img.decodeImage(bytes);
      if (decoded == null) throw Exception('Failed to decode image');

      final inputImage = InputImage.fromFilePath(imageFile.path);
      final faces = await _detectionService.detectFaces(inputImage);

      if (faces.isEmpty) {
        throw Exception('Face lost during capture');
      }

      final faceCrop = ImageUtils.cropFace(decoded, faces.first);
      final embedding = _recognitionService.generateEmbedding(faceCrop);

      if (embedding.isEmpty) {
        throw Exception('Failed to generate face embedding');
      }

      print('DEBUG: Captured Sample Embedding Length: ${embedding.length}');

      if (isVerification) {
        _handleManualVerification(embedding);
      } else {
        _capturedEmbeddings.add(embedding);
        print(
            'DEBUG: Captured Sample ${_capturedEmbeddings.length}/$_requiredRegistrationSamples');

        if (_capturedEmbeddings.length < _requiredRegistrationSamples) {
          registrationStep.value = _capturedEmbeddings.length + 1;
          guidanceMessage.value =
              'Sample Recorded! Turn your head slightly for next scan.';
          isProcessing.value = false;
          Get.snackbar('Sample Captured',
              'Saved scan ${_capturedEmbeddings.length}/$_requiredRegistrationSamples',
              backgroundColor: Colors.green, colorText: Colors.white);
        } else {
          print(
              'DEBUG: Registration Data Prepared. Total samples: ${_capturedEmbeddings.length}');
          Get.toNamed(Routes.FACE_REGISTRATION_SUCCESS, arguments: {
            'embeddings': _capturedEmbeddings,
          });
        }
      }
    } catch (e) {
      print('ERROR: Capture failed: $e');
      Get.snackbar('Capture Error', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
      isProcessing.value = false;
    }
  }

  void _handleManualVerification(List<double> embedding) {
    bool isMatched = false;
    final storedEmbeddings = (faceData!['embeddings'] as List)
        .map((e) => (e as List).map((v) => (v as num).toDouble()).toList())
        .toList();

    double bestSimilarity = -1.0;
    for (var stored in storedEmbeddings) {
      double similarity =
          _recognitionService.compareEmbeddings(embedding, stored);
      if (similarity > bestSimilarity) bestSimilarity = similarity;
      if (similarity >= FaceRecognitionService.threshold) {
        isMatched = true;
        break;
      }
    }

    print('DEBUG: Manual Verification Similarity: $bestSimilarity');

    Get.toNamed(Routes.ATTENDANCE_SUCCESS, arguments: {
      'isVerificationResult': true,
      'isMatched': isMatched,
      'embedding': embedding,
      'course_id': courseId,
      'session_id': sessionId,
    });
  }

  InputImage? _convertCameraImageToInputImage(CameraImage image) {
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
          format: InputImageFormat.nv21,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  void onClose() {
    cameraController?.dispose();
    _detectionService.dispose();
    _recognitionService.dispose();
    super.onClose();
  }
}
