import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:troyee_contact_firm/models/farm_batch_model.dart';
import '../../../app/services/upload_service.dart';

class CameraVisitController extends GetxController {
  final UploadService _uploadService = Get.find<UploadService>();
  
  CameraController? cameraController;
  final RxBool isInitialized = false.obs;
  final RxList<XFile> capturedImages = <XFile>[].obs;
  final ImagePicker _picker = ImagePicker();
  
  int? visitId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      visitId = args['visitId'];
    }
    /// TODO: Change from 35 later
    visitId ??= 35;
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await cameraController!.initialize();
      isInitialized.value = true;
    } catch (e) {
      print("Camera Error: $e");
    }
  }

  Future<void> takePicture() async {
    if (cameraController == null || !cameraController!.value.isInitialized) return;

    try {
      final image = await cameraController!.takePicture();
      capturedImages.add(image);
    } catch (e) {
      print("Error taking picture: $e");
    }
  }

  Future<void> pickFromGallery() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        capturedImages.addAll(images);
      }
    } catch (e) {
      print("Error picking images: $e");
    }
  }

  void _autoUpload(String path) {
    if (visitId != null) {
      _uploadService.addToQueue(visitId: visitId!, imagePath: path);
      Get.snackbar(
        "সংরক্ষিত", 
        "ছবিটি আপলোড সারিতে যুক্ত করা হয়েছে",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < capturedImages.length) {
      capturedImages.removeAt(index);
    }
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}
