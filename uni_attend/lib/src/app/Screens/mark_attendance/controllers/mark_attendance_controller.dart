import 'package:get/get.dart';
import 'package:uni_attend/src/app/routes/app_routes.dart';

class MarkAttendanceController extends GetxController {
  // State for Check-In
  final isLocating = true.obs;
  final locationStatus = 'Verifying your location...'.obs;
  final gpsSignalStrength = 0.0.obs; // 0.0 to 1.0

  // State for Capture
  // In a real app, this would handle camera controller initialization

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
    // Simulate location check start if on check-in screen
    // startLocationCheck(); // Call this from the View's interactive init or manually
  }

  void startLocationCheck() async {
    isLocating.value = true;
    locationStatus.value = 'Verifying your location...';
    gpsSignalStrength.value = 0.2;

    await Future.delayed(const Duration(seconds: 1));
    gpsSignalStrength.value = 0.5;

    await Future.delayed(const Duration(seconds: 1));
    gpsSignalStrength.value = 0.8;

    await Future.delayed(const Duration(seconds: 1));
    gpsSignalStrength.value = 1.0;
    isLocating.value = false;
    locationStatus.value = 'Location Verified';
  }

  void proceedToScanFace() {
    Get.toNamed(Routes.SCAN_FACE);
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
}
