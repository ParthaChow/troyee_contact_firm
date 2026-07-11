import 'package:get/get.dart';
import '../controller/camera_visit_controller.dart';

class CameraVisitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CameraVisitController>(() => CameraVisitController());
  }
}
