import 'package:get/get.dart';
import '../controller/sign_in_controller.dart';

class AuthBinding extends Bindings{

  @override
  void dependencies () {

    Get.lazyPut(() => AuthController());
  }

}
