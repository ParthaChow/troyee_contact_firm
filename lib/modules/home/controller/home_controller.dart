import 'package:get/get.dart';
import 'package:troyee_contact_farm/app/services/services.dart';

class HomeController extends GetxController {

  void logout() {
    Get.find<AuthService>().logout();

    Get.offNamed('/sign_in');
  }
}