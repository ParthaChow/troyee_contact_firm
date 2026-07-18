import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/services/api_fetch.dart';
import '../../../app/services/services.dart';
import '../../home/models/farm_task.dart';
import '../../../models/farm_batch_model.dart';

class FarmVisitController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final ApiFetch _apiFetch = ApiFetch();
  
  final Rxn<Position> currentPosition = Rxn<Position>();
  final RxBool isLoading = true.obs;
  final RxBool isCheckingIn = false.obs;
  
  GoogleMapController? mapController;
  final RxSet<Marker> markers = <Marker>{}.obs;

  late FarmTask task;
  late FarmBatch batch;

  String get ownerName => _authService.fullName ?? "Unknown User";

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    task = args['task'];
    batch = args['batch'];
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar("Error", "Location services are disabled.");
        isLoading.value = false;
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar("Error", "Location permissions are denied.");
          isLoading.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar("Error", "Location permissions are permanently denied.");
        isLoading.value = false;
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentPosition.value = position;
      
      _addMarker(position);
      
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
            16,
          ),
        );
      }
      
      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Error", "Failed to get location: $e");
      isLoading.value = false;
    }
  }

  Future<void> checkIn() async {
    if (currentPosition.value == null) {
      Get.snackbar("Error", "Location not available. Please wait.");
      return;
    }

    isCheckingIn.value = true;

    try {
      final pos = currentPosition.value!;
      
      // Use coordinates string as deviceId instead of geocoding address
      final String deviceLocationId = "Lat: ${pos.latitude.toStringAsFixed(6)}, Lon: ${pos.longitude.toStringAsFixed(6)}";

      final baseUrl = _authService.baseUrl;
      final token = _authService.accessToken;

      if (baseUrl == null || token == null || !(await _authService.ensureValidToken())) {
        Get.snackbar("Session Expired", "Please login again to continue", 
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        Get.offAllNamed(Routes.auth);
        return;
      }

      // Re-get the token in case it was refreshed
      final validToken = _authService.accessToken!;

      final response = await _apiFetch.checkIn(
        baseUrl: baseUrl,
        token: validToken,
        farmId: task.id,
        batchId: batch.id,
        latitude: pos.latitude,
        longitude: pos.longitude,
        accuracy: pos.accuracy,
        deviceId: deviceLocationId,
      );

      Get.snackbar(
        "Success",
        "Check-in successful",
        backgroundColor: Colors.green.withOpacity(0.7),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(15),
      );
      
      // Pass the response data forward and replace current route so user can't go back
      Get.offNamed(Routes.info, arguments: {
        ...Get.arguments as Map<String, dynamic>,
        'checkInResponse': response,
      });
    } catch (e) {
      Get.snackbar(
        "Check-in Failed", 
        e.toString(),
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(15),
      );
      final baseUrl = _authService.baseUrl;
      final token = _authService.accessToken;
      print("url $baseUrl");
      print("token $token");
    } finally {
      isCheckingIn.value = false;
    }
  }

  void _addMarker(Position position) {
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: const InfoWindow(title: 'Your Location'),
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (currentPosition.value != null) {
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(currentPosition.value!.latitude, currentPosition.value!.longitude),
          16,
        ),
      );
    }
  }
}
