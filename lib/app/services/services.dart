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
    required String username,
    required String password,
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

    await _saveProfile(
      username: username,
      password: password,
      fullName: fullName,
      zone: zone,
    );

    isLoggedIn.value = true;
  }

  Future<void> _saveProfile({
    required String username,
    required String password,
    required String fullName,
    required String zone,
  }) async {
    List<dynamic> profiles = storage.read<List<dynamic>>("savedProfiles") ?? [];

    // Check if profile already exists
    final index = profiles.indexWhere((p) => p['username'] == username);

    final profileData = {
      'username': username,
      'password': password,
      'fullName': fullName,
      'zone': zone,
      'lastLogin': DateTime.now().toIso8601String(),
    };

    if (index != -1) {
      profiles[index] = profileData;
    } else {
      profiles.add(profileData);
    }

    await storage.write("savedProfiles", profiles);
  }

  List<Map<String, dynamic>> get savedProfiles {
    List<dynamic> profiles = storage.read<List<dynamic>>("savedProfiles") ?? [];
    List<Map<String, dynamic>> profileList = profiles.map((p) => Map<String, dynamic>.from(p)).toList();
    
    // Sort by last login (newest first)
    profileList.sort((a, b) {
      final aDate = DateTime.tryParse(a['lastLogin'] ?? '') ?? DateTime(2000);
      final bDate = DateTime.tryParse(b['lastLogin'] ?? '') ?? DateTime(2000);
      return bDate.compareTo(aDate);
    });
    
    return profileList;
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
    storage.remove("accessToken");
    storage.remove("refreshToken");
    storage.remove("fieldOfficerId");
    storage.remove("fullName");
    storage.remove("zone");
    storage.remove("accessTokenExpiresAt");
    // We keep savedProfiles and baseUrl
    isLoggedIn.value = false;
  }
}