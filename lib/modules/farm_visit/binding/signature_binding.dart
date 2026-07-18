import 'package:get/get.dart';
import '../controller/signature_controller.dart';

class SignatureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FarmSignatureController>(() => FarmSignatureController());
  }
}
