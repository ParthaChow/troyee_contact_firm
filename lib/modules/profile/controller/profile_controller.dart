import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/services/services.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  String get officerName => _authService.fullName ?? '';
  String get zone => _authService.zone ?? '';

  void logout() {
    _authService.logout();
    Get.offAllNamed(Routes.auth);
  }
}
