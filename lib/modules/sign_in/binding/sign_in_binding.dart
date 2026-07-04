import 'package:get/get.dart';
import '../../../app/services/api_fetch.dart';
import '../controller/sign_in_controller.dart';
import '../../../app/services/auth_repository.dart';

class SignInBinding extends Bindings{

  @override
  void dependencies () {

    Get.lazyPut<ApiFetch>(() => ApiFetch());

    Get.lazyPut<AuthRepository>(
          () => AuthRepository(Get.find<ApiFetch>()),
    );

    Get.lazyPut(() => SignInController());
  }

}
