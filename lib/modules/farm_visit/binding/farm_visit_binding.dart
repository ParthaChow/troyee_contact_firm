import 'package:get/get.dart';
import '../controller/farm_visit_controller.dart';

class FarmVisitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FarmVisitController>(() => FarmVisitController());
  }
}
