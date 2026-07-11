import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../app/services/services.dart';
import '../../home/models/farm_task.dart';
import '../../../models/farm_batch_model.dart';

class FarmVisitController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final Rxn<Position> currentPosition = Rxn<Position>();
  final RxBool isLoading = true.obs;
  
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
