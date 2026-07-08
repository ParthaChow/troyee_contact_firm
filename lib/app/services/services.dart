import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthService extends GetxService {
  final GetStorage storage = GetStorage();

  final isLoggedIn = false.obs;

  Future<AuthService> init() async {
    isLoggedIn.value = storage.hasData("accessToken");
    return this;
  }

  Future<void> saveLogin({
    required String accessToken,
    required String refreshToken,
    required int fieldOfficerId,
    required String fullName,
    required String zone,
    required String expiresAt,
    required String baseUrl,
  }) async {
    await storage.write("accessToken", accessToken);
    await storage.write("refreshToken", refreshToken);
    await storage.write("fieldOfficerId", fieldOfficerId);
    await storage.write("fullName", fullName);
    await storage.write("zone", zone);
    await storage.write("accessTokenExpiresAt", expiresAt);
    await storage.write("baseUrl", baseUrl);

    isLoggedIn.value = true;
  }

  String? get baseUrl =>
      storage.read<String>("baseUrl");

  String? get accessToken =>
      storage.read<String>("accessToken");

  String? get refreshToken =>
      storage.read<String>("refreshToken");

  int? get fieldOfficerId =>
      storage.read<int>("fieldOfficerId");

  String? get fullName =>
      storage.read<String>("fullName");

  String? get zone =>
      storage.read<String>("zone");

  void logout() {
    storage.erase();
    isLoggedIn.value = false;
  }
}