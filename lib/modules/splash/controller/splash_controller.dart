import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/services/services.dart';

class SplashController extends GetxController {
  final AuthService authService = Get.find<AuthService>();

  // @override
  // void onReady() {
  //   super.onReady();
  //   checkLogin();
  // }

  @override
  void onInit() {
    super.onInit();
    print("Splash initialized");

    Future.delayed(const Duration(seconds: 1), () {
      print("1 sec");
      checkLogin();
    });
  }

  Future<void> checkLogin() async {
    await Future.delayed(const Duration(seconds: 3));

    if (authService.isLoggedIn.value) {
      Get.offAllNamed(Routes.home);
    } else {
      Get.offAllNamed(Routes.auth);
    }
  }
}