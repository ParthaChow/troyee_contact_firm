import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:troyee_contact_firm/l10n/app_localizations.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/services/api_fetch.dart';
import '../../../app/services/services.dart';
import '../../home/models/farm_task.dart';
import '../../../models/farm_batch_model.dart';

class FarmVisitController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final ApiFetch _apiFetch = ApiFetch();

  final Rxn<Position> currentPosition = Rxn<Position>();
  final Rxn<Position> initialPosition = Rxn<Position>();
  final RxBool isLoading = true.obs;
  final RxBool isCheckingIn = false.obs;

  GoogleMapController? mapController;
  final RxSet<Marker> markers = <Marker>{}.obs;
  StreamSubscription<Position>? _positionStreamSubscription;

  late FarmTask task;
  late FarmBatch batch;

  String get ownerName => _authService.fullName ?? "Unknown User";

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    task = args['task'];
    batch = args['batch'];
    _startLocationUpdates();
  }

  @override
  void onClose() {
    _positionStreamSubscription?.cancel();
    super.onClose();
  }

  Future<void> _startLocationUpdates() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        final l10n = AppLocalizations.of(Get.context!)!;
        Get.snackbar(
          l10n.error,
          l10n.location_services_disabled,
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(15),
        );
        isLoading.value = false;
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          final l10n = AppLocalizations.of(Get.context!)!;
          Get.snackbar(
            l10n.error,
            l10n.location_permissions_denied,
            backgroundColor: Colors.red.withOpacity(0.7),
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(15),
          );
          isLoading.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        final l10n = AppLocalizations.of(Get.context!)!;
        Get.snackbar(
          l10n.error,
          l10n.location_permissions_permanently_denied,
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(15),
        );
        isLoading.value = false;
        return;
      }

      // Get initial position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentPosition.value = position;
      initialPosition.value = position;
      _addMarker(position);
      isLoading.value = false;

      // Start listening for updates
      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5, // Update every 5 meters
        ),
      ).listen((Position position) {
        currentPosition.value = position;
        _addMarker(position);
        
        // Follow user on map
        if (mapController != null) {
          mapController!.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(position.latitude, position.longitude),
            ),
          );
        }
      });

    } catch (e) {
      final l10n = AppLocalizations.of(Get.context!)!;
      Get.snackbar(
        l10n.error,
        "${l10n.failed_to_get_location}: $e",
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(15),
      );
      isLoading.value = false;
    }
  }

  Future<void> checkIn() async {
    final l10n = AppLocalizations.of(Get.context!)!;
    if (currentPosition.value == null) {
      Get.snackbar(l10n.error, l10n.location_not_available,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,);
      return;
    }

    isCheckingIn.value = true;

    try {
      final pos = currentPosition.value!;

      // Use coordinates string as deviceId instead of geocoding address
      final String deviceLocationId =
          "Lat: ${pos.latitude.toStringAsFixed(6)}, Lon: ${pos.longitude.toStringAsFixed(6)}";

      final baseUrl = _authService.baseUrl;
      final token = _authService.accessToken;

      if (baseUrl == null ||
          token == null ||
          !(await _authService.ensureValidToken())) {
        Get.snackbar(
          l10n.session_expired,
          l10n.please_login_again,
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
        l10n.success,
        l10n.checkin_success,
        backgroundColor: Colors.green.withOpacity(0.7),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(15),
      );

      // Pass the response data forward and replace current route so user can't go back
      Get.offNamed(
        Routes.info,
        arguments: {
          ...Get.arguments as Map<String, dynamic>,
          'checkInResponse': response,
        },
      );
    } catch (e) {
      final l10n = AppLocalizations.of(Get.context!)!;
      Get.snackbar(
        l10n.checkin_failed,
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
    final l10n = AppLocalizations.of(Get.context!)!;
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(title: l10n.your_location),
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}
