import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uni_attend/src/app/Screens/mark_attendance/controllers/mark_attendance_controller.dart';

class AttendanceCheckInView extends GetView<MarkAttendanceController> {
  const AttendanceCheckInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure controller is created
    Get.put(MarkAttendanceController());

    // Start location check on load (mock)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.startLocationCheck();
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Attendance Check-In',
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Map / Radar Pulse Simulation
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[300]!, width: 2),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Obx(() {
                    final pos = controller.currentPosition.value;
                    final isLocating = controller.isLocating.value;
                    final status = controller.locationStatus.value;

                    if (isLocating && pos == null) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: const Color(0xFF137fec).withOpacity(0.5),
                          ),
                          const Positioned(
                            bottom: 20,
                            child: Text(
                              'Waiting for GPS...',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      );
                    }

                    if (pos == null) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_off,
                                  color: Colors.red, size: 48),
                              const SizedBox(height: 12),
                              Text(
                                status,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: controller.startLocationCheck,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final userLatLng = LatLng(pos!.latitude, pos.longitude);
                    final uniLatLng =
                        LatLng(controller.uniLat, controller.uniLng);

                    return GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: userLatLng,
                        zoom: 16,
                      ),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      mapType: MapType.normal,
                      circles: {
                        Circle(
                          circleId: const CircleId('uni_radius'),
                          center: uniLatLng,
                          radius: controller.uniRadius,
                          fillColor: const Color(0xFF137fec).withOpacity(0.2),
                          strokeColor: const Color(0xFF137fec),
                          strokeWidth: 2,
                        ),
                      },
                      markers: {
                        Marker(
                          markerId: const MarkerId('uni_center'),
                          position: uniLatLng,
                          infoWindow: const InfoWindow(title: 'University'),
                        ),
                        Marker(
                          markerId: const MarkerId('user_location'),
                          position: userLatLng,
                          infoWindow: const InfoWindow(title: 'You are here'),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueRed),
                        ),
                      },
                      onMapCreated: (GoogleMapController mapController) {
                        // Optional: fit bounds to show both user and uni?
                      },
                    );
                  }),
                ),
              ),

              const SizedBox(height: 32),

              // Status Text
              Obx(() => Text(
                    controller.locationStatus.value,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: controller.isInsideUni.value ||
                              controller.isLocating.value
                          ? const Color(0xFF101922)
                          : Colors.red,
                    ),
                  )),
              const SizedBox(height: 12),
              Obx(() => Text(
                    controller.isInsideUni.value
                        ? 'Please stand still while we confirm you are within the university premises.'
                        : controller.isLocating.value
                            ? 'Please wait while we fetch your location.'
                            : 'You are outside university premises. Distance: ${controller.distanceFromUni.value.toStringAsFixed(1)}m',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: controller.isInsideUni.value ||
                              controller.isLocating.value
                          ? Colors.grey
                          : Colors.red[700],
                      height: 1.5,
                    ),
                  )),

              const SizedBox(height: 32),

              // GPS Signal Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.satellite_alt,
                                size: 20, color: Color(0xFF101922)),
                            SizedBox(width: 8),
                            Text(
                              'GPS Signal',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF101922),
                              ),
                            ),
                          ],
                        ),
                        // Signal Strength Text (Strong)
                        Obx(() => Text(
                              controller.gpsSignalStrength.value > 0.8
                                  ? 'Strong'
                                  : 'Weak',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF137fec).withOpacity(
                                    controller.gpsSignalStrength.value
                                            .checkRange(0, 1)
                                        ? 1.0
                                        : 0.5), // Hacky check
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Obx(() => LinearProgressIndicator(
                            value: controller.gpsSignalStrength.value,
                            backgroundColor: Colors.grey[100],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF137fec)),
                            minHeight: 6,
                          )),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Acquiring satellites...',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[400]),
                        ),
                        Text(
                          'Accuracy: ±5m',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Action Button (Verify Button shown in screenshot is Loading state... then turns to something else? Screenshot 3 shows "Verifying Location..." grey button. Let's assume after verification it enables a "Proceed" button or auto-navigates.
              // Logic check: "Make sure all UI... pixel perfect".
              // Screenshot 3 button says "Verifying Location..." with a spinner.
              // I will implement that state.
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: controller.isLocating.value ||
                              !controller.isInsideUni.value
                          ? null
                          : controller.proceedToScanFace,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF137fec),
                        disabledBackgroundColor: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: controller.isLocating.value
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.grey[500]!),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Verifying Location...',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            )
                          : const Text(
                              'Proceed to Scan Face',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

// Extension to avoid error for checkRange call if needed
extension RangeCheck on double {
  bool checkRange(double min, double max) => this >= min && this <= max;
}
