import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CameraVisitController extends GetxController {
  CameraController? cameraController;
  final RxBool isInitialized = false.obs;
  final RxList<XFile> capturedImages = <XFile>[].obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
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
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        capturedImages.add(image);
      }
    } catch (e) {
      print("Error picking image: $e");
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
