import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uni_attend/src/app/data/repositories/student_repository.dart';
import 'package:uni_attend/src/app/routes/app_routes.dart';

class MarkAttendanceController extends GetxController {
  // State for Check-In
  final isLocating = true.obs;
  final locationStatus = 'Verifying your location...'.obs;
  final gpsSignalStrength = 0.0.obs; // 0.0 to 1.0
  final isInsideUni = false.obs;
  final currentPosition = Rxn<Position>();
  final distanceFromUni = 0.0.obs;

  // University Location (Hardcoded)
  final double uniLat =
      24.918930921038022; // 24.8607; // Placeholder: Karachi, Pakistan area
  final double uniLng = 67.1339365503404; // 67.0011;
  final double uniRadius = 100.0; // 500 meters radius

  final StudentRepository _studentRepository = StudentRepository();
  final Rxn<List<dynamic>> faceEmbedding = Rxn<List<dynamic>>();

  // Data from arguments
  String? courseId;
  String? sessionId;

  // State for Review
  // Mock data for the review screen
  final courseName = 'CS101 - Intro to AI'.obs;
  final courseDate = 'Oct 24, 2023'.obs;
  final courseTime = '09:45 AM'.obs; // Class start time
  final captureTime = '09:42 AM'.obs; // Actual capture time
  final locationName = 'Building C, Room 302'.obs;
  final sessionType = 'Lecture'.obs;

  @override
  void onInit() {
    super.onInit();

    // Handle arguments
    if (Get.arguments != null) {
      courseId = Get.arguments['course_id'];
      sessionId = Get.arguments['session_id'];
      courseName.value = Get.arguments['course_name'] ?? 'CS101 - Intro to AI';
      courseTime.value = Get.arguments['start_time'] ?? '09:45 AM';
      locationName.value = Get.arguments['room'] ?? 'Building C, Room 302';
      sessionType.value = Get.arguments['type'] ?? 'Lecture';

      // Update with current date
      final now = DateTime.now();
      courseDate.value = "${_getMonthName(now.month)} ${now.day}, ${now.year}";
      captureTime.value =
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";

      _checkExistingAttendance();
    }

    // Simulate location check start if on check-in screen
    startLocationCheck();
  }

  Future<void> _checkExistingAttendance() async {
    if (sessionId == null) return;
    final exists =
        await _studentRepository.checkIfAttendanceAlreadyMarked(sessionId!);
    if (exists) {
      locationStatus.value = 'Already Marked';
      Get.snackbar(
        'Info',
        'Attendance already marked for this session',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    }
  }

  void startLocationCheck() async {
    isLocating.value = true;
    locationStatus.value = 'Requesting location permissions...';
    gpsSignalStrength.value = 0.2;

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        locationStatus.value = 'Location services are disabled.';
        Get.snackbar(
          'Location Disabled',
          'Please enable GPS to verify your location.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        isLocating.value = false;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied.');
          locationStatus.value = 'Location permissions are denied';
          Get.snackbar(
            'Permission Denied',
            'Location permission is required for attendance.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          isLocating.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied.');
        locationStatus.value = 'Location permissions are permanently denied';
        Get.snackbar(
          'Permission Required',
          'Please enable location in your app settings.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLocating.value = false;
        return;
      }

      print('Acquiring GPS signal...');
      locationStatus.value = 'Acquiring GPS signal...';
      gpsSignalStrength.value = 0.6;

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      print('Position acquired: ${position.latitude}, ${position.longitude}');

      currentPosition.value = position;
      gpsSignalStrength.value = 1.0;

      // Calculate distance
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        uniLat,
        uniLng,
      );
      print('Distance from Uni: $distance meters');

      distanceFromUni.value = distance;
      isInsideUni.value = distance <= uniRadius;

      if (isInsideUni.value) {
        locationStatus.value = 'Location Verified';
      } else {
        locationStatus.value = 'Outside University Premises';
      }
    } catch (e) {
      print('Error: $e');
      locationStatus.value = 'Error: $e';
    } finally {
      isLocating.value = false;
    }
  }

  Future<void> proceedToScanFace() async {
    if (sessionId != null) {
      final exists =
          await _studentRepository.checkIfAttendanceAlreadyMarked(sessionId!);
      if (exists) {
        Get.snackbar('Already Marked',
            'You have already marked attendance for this session.');
        return;
      }
    }

    // 1. Check if face is registered
    try {
      final profile = await _studentRepository.getStudentProfile();
      if (profile == null || profile['face_embedding'] == null) {
        Get.snackbar(
          'Face not registered',
          'Please register your face first to mark attendance',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      faceEmbedding.value = profile['face_embedding'] as List<dynamic>?;

      // 2. Navigate to face verification for attendance
      // Passing arguments to the shared/new face scan screen
      Get.toNamed(Routes.FACE_REGISTRATION, arguments: {
        'isVerification': true,
        'storedEmbedding': faceEmbedding.value,
        'course_id': courseId,
        'session_id': sessionId,
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to check face registration: $e');
    }
  }

  void capturePhoto() {
    // Simulate capture delay and navigation
    Get.toNamed(Routes.REVIEW_SUBMISSION);
  }

  void retakePhoto() {
    Get.back();
  }

  void submitAttendance() {
    // Navigate to success
    Get.toNamed(Routes.ATTENDANCE_SUCCESS);
  }

  void finish() {
    // Return to dashboard and refresh if needed
    Get.offAllNamed(Routes.DASHBOARD);
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
